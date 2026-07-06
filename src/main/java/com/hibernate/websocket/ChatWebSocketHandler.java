package com.hibernate.websocket;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.web.socket.CloseStatus;

import org.springframework.web.socket.TextMessage;

import org.springframework.web.socket.WebSocketSession;

import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.databind.ObjectMapper;

import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import com.hibernate.dto.MessageRequest;

import com.hibernate.dto.MessageResponse;

import com.hibernate.entity.Message;

import com.hibernate.entity.User;

import com.hibernate.service.ChatService;



import com.hibernate.service.UserService;

import java.util.HashMap;
import java.util.Map;

public class ChatWebSocketHandler extends TextWebSocketHandler {
    @Autowired
    private ChatService chatService;
    @Autowired
    private ChatEventBroadcaster broadcaster;
    @Autowired
    private UserService userService;

    private final ObjectMapper objectMapper = new ObjectMapper()
            .registerModule(new JavaTimeModule());

    private Long extractUserId(WebSocketSession session) {
        if (session == null || session.getAttributes() == null) return null;
        Object currentUser = session.getAttributes().get("currentUser");
        if (currentUser == null) {
            currentUser = session.getAttributes().get("user");
        }
        if (currentUser instanceof User) {
            return ((User) currentUser).getId();
        }
        Object userIdObj = session.getAttributes().get("userId");
        if (userIdObj != null) {
            try {
                return Long.valueOf(userIdObj.toString());
            } catch (Exception ignored) {}
        }
        return null;
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        broadcaster.registerSession(session);
        Long currentUserId = extractUserId(session);
        if (currentUserId != null) {
            try {
                userService.updateUserOnlineStatus(currentUserId, true);
                broadcaster.broadcastUserStatus(currentUserId, true, java.time.LocalDateTime.now());
            } catch (Exception e) {
                System.err.println("Failed to update user online status: " + e.getMessage());
            }
        }
        System.out.println("WebSocket connection success " + session.getId());
    }
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) {
        try {
            String payload = message.getPayload();
            User currentUser = (User) session.getAttributes().get("currentUser");
            if (currentUser == null) {
                currentUser = (User) session.getAttributes().get("user");
            }
            Long currentUserId = currentUser != null ? currentUser.getId() : null;
            if (currentUserId == null && session.getAttributes().get("userId") != null) {
                try {
                    currentUserId = Long.valueOf(session.getAttributes().get("userId").toString());
                } catch (Exception ignored) {}
            }
            if (currentUserId == null) return;

            Map<String, Object> jsonMap = objectMapper.readValue(payload, Map.class);

            String type = (String) jsonMap.get("type");
            if ("user_typing".equals(type)) {
                Long conversationId = Long.valueOf(jsonMap.get("conversationId").toString());
                Long senderId = Long.valueOf(jsonMap.get("senderId").toString());
                String senderName = chatService.resolveDisplayName(currentUserId);
                broadcaster.broadcastUserTyping(conversationId, senderId, senderName);
                return;
            }
            if ("user_stopped_typing".equals(type)) {
                Long conversationId = Long.valueOf(jsonMap.get("conversationId").toString());
                Long senderId = Long.valueOf(jsonMap.get("senderId").toString());
                String senderName = chatService.resolveDisplayName(currentUserId);
                broadcaster.broadcastUserStoppedTyping(conversationId, senderId, senderName);
                return;
            }

            String action = (String) jsonMap.get("action");
            if ("edit_message".equals(action)) {
                Long messageId = Long.valueOf(String.valueOf(jsonMap.get("messageId")));
                String text = String.valueOf(jsonMap.get("text"));
                Message edited = chatService.editMessage(messageId, currentUserId, text);
                MessageResponse response = chatService.toMessageResponse(edited);
                broadcaster.broadcastEditedMessage(response);
                return;
            }

            MessageRequest legacyRequest = objectMapper.readValue(payload, MessageRequest.class);

            Message savedMessage = chatService.sendMessage(
                    legacyRequest.getConversationId(),
                    currentUserId,
                    legacyRequest.getText(),
                    legacyRequest.getParentMessageId()
            );

            MessageResponse response = chatService.toMessageResponse(savedMessage);

            broadcaster.broadcastNewMessage(response);

        } catch (Exception e) {

            System.err.println("Error handling websocket text message: " + e.getMessage());

            e.printStackTrace();

            Map<String, String> error = new HashMap<>();

            error.put("type", "error");

            error.put("message", e.getMessage());

            try {
                session.sendMessage(new TextMessage(objectMapper.writeValueAsString(error)));
            } catch (Exception sendError) {
                System.err.println("Failed to send websocket error message: " + sendError.getMessage());
            }

        }

    }



    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        Long currentUserId = extractUserId(session);
        broadcaster.unregisterSession(session);
        if (currentUserId != null) {
            try {
                if (broadcaster.getUserSessionCount(currentUserId) == 0) {
                    userService.updateUserOnlineStatus(currentUserId, false);
                    broadcaster.broadcastUserStatus(currentUserId, false, java.time.LocalDateTime.now());
                }
            } catch (Exception e) {
                System.err.println("Failed to update user offline status: " + e.getMessage());
            }
        }
        System.out.println("WebSocket connection closed: " + session.getId());
    }
}

