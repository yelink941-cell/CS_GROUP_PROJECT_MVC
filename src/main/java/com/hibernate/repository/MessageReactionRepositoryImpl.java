package com.hibernate.repository;

import com.hibernate.entity.MessageReaction;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class MessageReactionRepositoryImpl implements MessageReactionRepository {

    private final SessionFactory sessionFactory;

    @Autowired
    public MessageReactionRepositoryImpl(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    @Override
    public MessageReaction save(MessageReaction reaction) {
        sessionFactory.getCurrentSession().saveOrUpdate(reaction);
        return reaction;
    }

    @Override
    public void delete(MessageReaction reaction) {
        sessionFactory.getCurrentSession().delete(reaction);
    }

    @Override
    public Optional<MessageReaction> findByMessageIdAndUserIdAndEmoji(Long messageId, Long userId, String emoji) {
        String hql = "FROM MessageReaction r WHERE r.message.id = :messageId AND r.userId = :userId AND r.emoji = :emoji";
        return sessionFactory.getCurrentSession()
                .createQuery(hql, MessageReaction.class)
                .setParameter("messageId", messageId)
                .setParameter("userId", userId)
                .setParameter("emoji", emoji)
                .uniqueResultOptional();
    }

    @Override
    public Optional<MessageReaction> findByMessageIdAndUserId(Long messageId, Long userId) {
        String hql = "FROM MessageReaction r WHERE r.message.id = :messageId AND r.userId = :userId";
        return sessionFactory.getCurrentSession()
                .createQuery(hql, MessageReaction.class)
                .setParameter("messageId", messageId)
                .setParameter("userId", userId)
                .uniqueResultOptional();
    }

    @Override
    public int deleteByMessageIdAndUserId(Long messageId, Long userId) {
        String hql = "DELETE FROM MessageReaction r WHERE r.message.id = :messageId AND r.userId = :userId";
        return sessionFactory.getCurrentSession()
                .createQuery(hql)
                .setParameter("messageId", messageId)
                .setParameter("userId", userId)
                .executeUpdate();
    }

    @Override
    public List<MessageReaction> findByMessageId(Long messageId) {
        String hql = "FROM MessageReaction r WHERE r.message.id = :messageId ORDER BY r.createdAt ASC";
        return sessionFactory.getCurrentSession()
                .createQuery(hql, MessageReaction.class)
                .setParameter("messageId", messageId)
                .getResultList();
    }
}
