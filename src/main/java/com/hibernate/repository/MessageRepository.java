package com.hibernate.repository;

import java.util.List;
import java.util.Optional;
import java.time.LocalDateTime;
import com.hibernate.entity.Message;

public interface MessageRepository {
    Long insertMessage(Message message);
    Message getById(Long id);
    Message getByIdWithDetails(Long id);
    void updateMessage(Message message);
    List<Message> getChatHistory(Long conversationId, Long lastMessageId, int limit);
    Optional<Message> findLatestByConversationId(Long conversationId);
    Optional<Message> findByIdAndSenderId(Long messageId, Long senderId);

    int softDeleteAllByConversationId(Long conversationId, LocalDateTime deletedAt);
}
