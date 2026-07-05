package com.hibernate.websocket;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.hibernate.dto.MarkReadResponse;
import com.hibernate.dto.MessageResponse;
import com.hibernate.entity.User;
import com.hibernate.service.ChatService;
import com.hibernate.util.LastSeenFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class ChatEventBroadcaster {

    private static final Map<String, WebSocketSession> SESSIONS = new ConcurrentHashMap<>();

    private final ObjectMapper objectMapper = new ObjectMapper().registerModule(new JavaTimeModule());

    @Autowired
    private ChatService chatService;
    public void registerSession(WebSocketSession session) {
        SESSIONS.put(session.getId(), session);
    }

    public void unregisterSession(WebSocketSession session) {
        SESSIONS.remove(session.getId());
    }
    public void broadcastPayload (Long conversationId, Object payload) {
        try {
            String json = objectMapper.writeValueAsString(payload);
            TextMessage message = new TextMessage(json);
            for (WebSocketSession session : SESSIONS.values()) {
                try {
                    if (!session.isOpen()) {
                        continue;
                    }
                    Long userId = extractUserIdFromSession(session);
                    if (userId != null && chatService.isParticipant(conversationId, userId)) {
                        synchronized (session) {
                            if (session.isOpen()) {
                                session.sendMessage(message);
                            }
                        }
                    }
                } catch (Exception e) {
                    System.err.println("[ChatBroadcaster] Error broadcasting to session " + session.getId() + ": " + e.getMessage());
                }
            }
        } catch (Exception e) {
            System.err.println("[ChatBroadcaster] Failed to broadcast: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private Long extractUserIdFromSession(WebSocketSession session) {
        Object userObj = session.getAttributes().get("currentUser");
        if (userObj == null) {
            userObj = session.getAttributes().get("user");
        }
        if (userObj instanceof User) {
            return ((User) userObj).getId();
        }
        Object userIdObj = session.getAttributes().get("userId");
        if (userIdObj != null) {
            try {
                return Long.valueOf(userIdObj.toString());
            } catch (Exception ignored) {}
        }
        return null;
    }	
    public void broadcastNewMessage(MessageResponse response) {
        Map<String, Object> envelope = new HashMap<>();
        envelope.put("type", "message");
        envelope.put("payload", response);
        broadcastPayload(response.getConversationId(), envelope);
    }

    public void broadcastEditedMessage(MessageResponse response) {
        Map<String, Object> envelope = new HashMap<>();
        envelope.put("type", "message_edited");
        envelope.put("payload", response);
        broadcastPayload(response.getConversationId(), envelope);
    }

    public void broadcastReaction(MessageResponse response) {
        Map<String, Object> envelope = new HashMap<>();
        envelope.put("type", "message_reaction");
        envelope.put("payload", response);
        broadcastPayload(response.getConversationId(), envelope);
    }
    public void broadcastReadReceipt(MarkReadResponse response) {
        Map<String, Object> envelope = new HashMap<>();
        envelope.put("type", "messages_read");
        envelope.put("payload", response);
        broadcastPayload(response.getConversationId(), envelope);
    }

    public void broadcastDeletedMessage(Long conversationId, Long messageId) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("conversationId", conversationId);
        payload.put("messageId", messageId);

        Map<String, Object> envelope = new HashMap<>();
        envelope.put("type", "message_deleted");
        envelope.put("payload", payload);
        broadcastPayload(conversationId, envelope);
    }

    public void broadcastConversationCleared(Long conversationId) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("conversationId", conversationId);

        Map<String, Object> envelope = new HashMap<>();
        envelope.put("type", "conversation_cleared");
        envelope.put("payload", payload);
        broadcastPayload(conversationId, envelope);
    }
    public void broadcastUserTyping(Long conversationId, Long senderId, String senderName) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("conversationId", conversationId);
        payload.put("senderId", senderId);
        payload.put("senderName", senderName);

        Map<String, Object> envelope = new HashMap<>();
        envelope.put("type", "user_typing");
        envelope.put("payload", payload);

        broadcastPayload(conversationId, envelope);
    }

    public void broadcastUserStoppedTyping(Long conversationId, Long senderId, String senderName) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("conversationId", conversationId);
        payload.put("senderId", senderId);
        payload.put("senderName", senderName);

        Map<String, Object> envelope = new HashMap<>();
        envelope.put("type", "user_stopped_typing");
        envelope.put("payload", payload);

        broadcastPayload(conversationId, envelope);
    }

    public int getUserSessionCount(Long userId) {
        if (userId == null) return 0;
        int count = 0;
        for (WebSocketSession session : SESSIONS.values()) {
            Long sUserId = extractUserIdFromSession(session);
            if (userId.equals(sUserId)) {
                count++;
            }
        }
        return count;
    }

    public void broadcastUserStatus(Long userId, boolean isOnline, LocalDateTime lastSeen) {
        if (userId == null) return;
        try {
            Map<String, Object> payload = new HashMap<>();
            payload.put("userId", userId);
            payload.put("isOnline", isOnline);
            payload.put("lastSeen", lastSeen != null ? lastSeen.toString() : null);
            payload.put("lastSeenFormatted", LastSeenFormatter.format(isOnline, lastSeen));

            Map<String, Object> envelope = new HashMap<>();
            envelope.put("type", "user_status_changed");
            envelope.put("payload", payload);

            String json = objectMapper.writeValueAsString(envelope);
            TextMessage message = new TextMessage(json);

            for (WebSocketSession session : SESSIONS.values()) {
                if (session.isOpen()) {
                    synchronized (session) {
                        if (session.isOpen()) {
                            session.sendMessage(message);
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("[ChatBroadcaster] Failed to broadcast user status: " + e.getMessage());
        }
    }
}

