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



import java.util.HashMap;

import java.util.Map;



public class ChatWebSocketHandler extends TextWebSocketHandler {
    @Autowired
    private ChatService chatService;
    @Autowired
    private ChatEventBroadcaster broadcaster;
    private final ObjectMapper objectMapper = new ObjectMapper()
            .registerModule(new JavaTimeModule());
    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        broadcaster.registerSession(session);
        System.out.println("WebSocket connection success " + session.getId());
    }
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) {
        try {
            String payload = message.getPayload();
            User currentUser = (User) session.getAttributes().get("currentUser");
            if (currentUser == null) return;

            Map<String, Object> jsonMap = objectMapper.readValue(payload, Map.class);

            // 🌟 ဤနေရာတွင် အောက်ပါကုဒ်ကို ကူးယူပြီး ထည့်သွင်းပါ 🌟
            String type = (String) jsonMap.get("type");
            if ("user_typing".equals(type)) {
                Long conversationId = Long.valueOf(jsonMap.get("conversationId").toString());
                Long senderId = Long.valueOf(jsonMap.get("senderId").toString());
                String senderName = chatService.resolveDisplayName(currentUser.getId());
                broadcaster.broadcastUserTyping(conversationId, senderId, senderName);
                return; // အောက်က သာမန် message သိမ်းတဲ့အပိုင်းထဲ ဆက်မသွားစေရန်
            }
            if ("user_stopped_typing".equals(type)) {
                Long conversationId = Long.valueOf(jsonMap.get("conversationId").toString());
                Long senderId = Long.valueOf(jsonMap.get("senderId").toString());
                String senderName = chatService.resolveDisplayName(currentUser.getId());
                broadcaster.broadcastUserStoppedTyping(conversationId, senderId, senderName);
                return; // အောက်က သာမန် message သိမ်းတဲ့အပိုင်းထဲ ဆက်မသွားစေရန်
            }
            // 🌟 ======================================= 🌟

            // (သင်ပြထားတဲ့ ဓါတ်ပုံထဲက မူရင်းလိုင်းနံပါတ် ၅၆ နေရာမှစပြီး အောက်ကအတိုင်း ဆက်သွားပါမယ်)
            String action = (String) jsonMap.get("action");
            if ("edit_message".equals(action)) {
                // ... ကျန်တာတွေ မူရင်းအတိုင်း ထားပါ
//            if ("edit".equals(action)) {
                Long messageId = Long.valueOf(String.valueOf(jsonMap.get("messageId")));
                String text = String.valueOf(jsonMap.get("text"));
                Message edited = chatService.editMessage(messageId, currentUser.getId(), text);
                MessageResponse response = chatService.toMessageResponse(edited);
                broadcaster.broadcastEditedMessage(response);
                return;

            }



            MessageRequest legacyRequest = objectMapper.readValue(payload, MessageRequest.class);

            Message savedMessage = chatService.sendMessage(

                    legacyRequest.getConversationId(),

                    currentUser.getId(),

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

        broadcaster.unregisterSession(session);

        System.out.println("WebSocket ချိတ်ဆက်မှု ပြီးဆုံးပါသည်: " + session.getId());

    }

}

