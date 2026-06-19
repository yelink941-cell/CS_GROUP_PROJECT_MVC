package com.hibernate.repository;

import java.util.List;
import com.hibernate.entity.Conversation;

public interface ConversationRepository {
    Long insertConversation(Conversation conversation);
    Conversation getById(Long id);
    Conversation getByIdWithParticipants(Long id);
    List<Conversation> getAllConversationsByUserId(Long userId);
    void updateConversation(Conversation conversation);
}