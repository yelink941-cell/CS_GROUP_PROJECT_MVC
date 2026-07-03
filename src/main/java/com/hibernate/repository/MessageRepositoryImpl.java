package com.hibernate.repository;

import java.util.List;
import java.util.Optional;
import java.time.LocalDateTime;
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
    public Message getByIdWithDetails(Long id) {
        return getSession().createQuery(
                "SELECT DISTINCT m FROM Message m " +
                "LEFT JOIN FETCH m.attachments " +
                "LEFT JOIN FETCH m.parentMessage " +
                "WHERE m.id = :id", Message.class)
                .setParameter("id", id)
                .uniqueResult();
    }

    @Override
    public void updateMessage(Message message) {
        getSession().merge(message);
    }

    @Override
    public List<Message> getChatHistory(Long conversationId, Long lastMessageId, int limit) {
        // NOTE: Hibernate cannot simultaneously fetch multiple bags (attachments + seenStatuses)
        // So we only JOIN FETCH attachments here. seenStatuses will lazy-load via OpenSessionInViewFilter.
        String hql = "SELECT DISTINCT m FROM Message m " +
                     "LEFT JOIN FETCH m.attachments " +
                     "LEFT JOIN FETCH m.parentMessage " +
                     "WHERE m.conversation.id = :conversationId " +
                     "AND m.deletedAt IS NULL " +
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
                "AND m.deletedAt IS NULL " +
                "ORDER BY m.id DESC", Message.class)
                .setParameter("conversationId", conversationId)
                .setMaxResults(1)
                .uniqueResult();
        return Optional.ofNullable(message);
    }

    @Override
    public Optional<Message> findByIdAndSenderId(Long messageId, Long senderId) {
        Message message = getSession().createQuery(
                "SELECT m FROM Message m WHERE m.id = :messageId AND m.senderId = :senderId",
                Message.class)
                .setParameter("messageId", messageId)
                .setParameter("senderId", senderId)
                .uniqueResult();
        return Optional.ofNullable(message);
    }

    @Override
    public int softDeleteAllByConversationId(Long conversationId, LocalDateTime deletedAt) {
        return getSession().createQuery(
                "UPDATE Message m SET m.deletedAt = :deletedAt " +
                "WHERE m.conversation.id = :conversationId AND m.deletedAt IS NULL")
                .setParameter("conversationId", conversationId)
                .setParameter("deletedAt", deletedAt)
                .executeUpdate();
    }
}
