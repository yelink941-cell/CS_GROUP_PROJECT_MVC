package com.hibernate.repository;

import java.util.List;
import java.util.Optional;
import com.hibernate.entity.Message;

public interface MessageRepository {
    Long insertMessage(Message message);
    Message getById(Long id);
    List<Message> getChatHistory(Long conversationId, Long lastMessageId, int limit);
    Optional<Message> findLatestByConversationId(Long conversationId);
}