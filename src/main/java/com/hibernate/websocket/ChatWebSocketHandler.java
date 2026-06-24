package com.hibernate.websocket;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class ChatWebSocketHandler extends TextWebSocketHandler {

    // လက်ရှိ ချိတ်ဆက်ထားတဲ့ User အားလုံးရဲ့ WebSocket Session တွေကို သိမ်းထားမယ့် နေရာ
    private static final Map<String, WebSocketSession> sessions = new ConcurrentHashMap<>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        // User တစ်ယောက် Connection ဆောက်လိုက်တာနဲ့ စာရင်းမှတ်ထားမယ်
        sessions.put(session.getId(), session);
        System.out.println("WebSocket connection success " + session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        // Frontend ကနေ စာပို့လိုက်ရင် ဒီနေရာကို ရောက်လာပါမယ်
        String payload = message.getPayload();
        System.out.println("Message Recevied " + payload);

        // စာပြန်ပို့တဲ့ စမ်းသပ်ချက်အနေနဲ့ ပို့လိုက်တဲ့သူဆီကိုပဲ Echo ပြန်လုပ်ကြည့်မယ်
        session.sendMessage(new TextMessage("Received From Server" + payload));
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        // User ထွက်သွားရင် စာရင်းထဲက ဖြုတ်မယ်
        sessions.remove(session.getId());
        System.out.println("WebSocket ချိတ်ဆက်မှု ပြီးဆုံးပါသည်: " + session.getId());
    }
}