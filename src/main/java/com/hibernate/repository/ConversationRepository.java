package com.hibernate.repository;

import com.hibernate.entity.Conversation;
import java.util.List;

public interface ConversationRepository {
    Conversation save(Conversation conversation);
    Conversation findById(Long id);
    List<Conversation> findConversationsByUserId(Long userId);
}