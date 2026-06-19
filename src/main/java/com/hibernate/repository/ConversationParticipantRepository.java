package com.hibernate.repository;

import com.hibernate.entity.ConversationParticipant;

public interface ConversationParticipantRepository {
    // Participant ကို Database ထဲ ထည့်ရန်
    public Long insertParticipant(ConversationParticipant participant);
    
    // လူတစ်ယောက်က အဆိုပါ Chat Room ထဲမှာ တကယ်ရှိမရှိ စစ်ဆေးရန် (Security Check အတွက်)
    public boolean isUserParticipant(Long conversationId, Long userId);
}