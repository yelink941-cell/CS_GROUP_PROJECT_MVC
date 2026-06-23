package com.hibernate.repository;

import java.util.List;
import java.util.Optional;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import com.hibernate.entity.Message;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
@Transactional
public class MessageRepositoryImpl implements MessageRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Long insertMessage(Message message) {
        return (Long) getSession().save(message);
    }

    @Override
    public Message getById(Long id) {
        return getSession().get(Message.class, id);
    }

    @Override
    public List<Message> getChatHistory(Long conversationId, Long lastMessageId, int limit) {
        String hql = "SELECT DISTINCT m FROM Message m " +
                     "LEFT JOIN FETCH m.attachments " +
                     "WHERE m.conversation.id = :conversationId " +
                     "AND m.id < :lastMessageId " +
                     "ORDER BY m.id DESC";

        return getSession().createQuery(hql, Message.class)
                .setParameter("conversationId", conversationId)
                .setParameter("lastMessageId", lastMessageId)
                .setMaxResults(limit)
                .list();
    }

    @Override
    public Optional<Message> findLatestByConversationId(Long conversationId) {
        Message message = getSession().createQuery(
                "SELECT m FROM Message m " +
                "LEFT JOIN FETCH m.attachments " +
                "WHERE m.conversation.id = :conversationId " +
                "ORDER BY m.id DESC", Message.class)
                .setParameter("conversationId", conversationId)
                .setMaxResults(1)
                .uniqueResult();
        return Optional.ofNullable(message);
    }
}