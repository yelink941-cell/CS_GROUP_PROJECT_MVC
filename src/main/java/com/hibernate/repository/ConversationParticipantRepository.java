package com.hibernate.repository;

import com.hibernate.entity.ConversationParticipant;
import com.hibernate.entity.enums.ParticipantRole;

import java.util.Optional;

public interface ConversationParticipantRepository {
    // Participant ကို Database ထဲ ထည့်ရန်
    public Long insertParticipant(ConversationParticipant participant);
    
    // လူတစ်ယောက်က အဆိုပါ Chat Room ထဲမှာ တကယ်ရှိမရှိ စစ်ဆေးရန် (Security Check အတွက်)
    public boolean isUserParticipant(Long conversationId, Long userId);

    Long findOtherParticipantUserId(Long conversationId, Long currentUserId);

    Long findDirectConversationIdBetweenUsers(Long userId1, Long userId2);

    Optional<ParticipantRole> findParticipantRole(Long conversationId, Long userId);

    Optional<ConversationParticipant> findParticipant(Long conversationId, Long userId);

    void updateParticipant(ConversationParticipant participant);

    void restoreConversationForUser(Long conversationId, Long userId);
}