package com.hibernate.repository;

import com.hibernate.entity.Message;
import java.util.List;

public interface MessageRepository {
    Message save(Message message);
    List<Message> findByConversationId(Long conversationId);
}