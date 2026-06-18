package com.hibernate.service;

import com.hibernate.entity.Conversation;
import com.hibernate.entity.Message;
import java.util.List;

public interface ChatService {
    
    // ၁။ စကားဝိုင်း (သို့) Group Chat အသစ်ဆောက်ရန်
    Conversation createConversation(String title, boolean isGroup, List<Long> userIds);
    
    // ၂။ စကားဝိုင်းတစ်ခုထဲကို စာလှမ်းပို့ရန်
    Message sendMessage(Long conversationId, Long senderId, String text);
    
    // ၃။ Chat Room ထဲက စာရာဇဝင် (Chat History) ကို ပြန်ခေါ်ထုတ်ရန်
    List<Message> getChatHistory(Long conversationId);
}