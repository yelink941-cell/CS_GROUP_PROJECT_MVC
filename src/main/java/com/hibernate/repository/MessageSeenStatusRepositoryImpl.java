package com.hibernate.repository;

import com.hibernate.entity.Message;
import com.hibernate.entity.MessageSeenStatus;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Repository
@RequiredArgsConstructor
@Transactional
public class MessageSeenStatusRepositoryImpl implements MessageSeenStatusRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Long insertSeenStatus(MessageSeenStatus seenStatus) {
        return (Long) getSession().save(seenStatus);
    }

    @Override
    public List<MessageSeenStatus> findByMessageId(Long messageId) {
        return getSession().createQuery(
                "SELECT s FROM MessageSeenStatus s WHERE s.message.id = :messageId",
                MessageSeenStatus.class)
                .setParameter("messageId", messageId)
                .list();
    }

    @Override
    public boolean existsByMessageIdAndUserId(Long messageId, Long userId) {
        Long count = getSession().createQuery(
                "SELECT COUNT(s.id) FROM MessageSeenStatus s " +
                "WHERE s.message.id = :messageId AND s.userId = :userId", Long.class)
                .setParameter("messageId", messageId)
                .setParameter("userId", userId)
                .uniqueResult();
        return count != null && count > 0;
    }

    @Override
    public int markConversationReadUpTo(Long conversationId, Long userId, Long upToMessageId) {
        List<Long> unreadMessageIds = getSession().createQuery(
                "SELECT m.id FROM Message m " +
                "WHERE m.conversation.id = :conversationId " +
                "AND m.id <= :upToMessageId " +
                "AND m.senderId <> :userId " +
                "AND NOT EXISTS (" +
                "  SELECT 1 FROM MessageSeenStatus s " +
                "  WHERE s.message.id = m.id AND s.userId = :userId" +
                ")", Long.class)
                .setParameter("conversationId", conversationId)
                .setParameter("upToMessageId", upToMessageId)
                .setParameter("userId", userId)
                .list();

        LocalDateTime now = LocalDateTime.now();
        for (Long messageId : unreadMessageIds) {
            MessageSeenStatus status = new MessageSeenStatus();
            status.setMessage(getSession().getReference(Message.class, messageId));
            status.setUserId(userId);
            status.setReadAt(now);
            getSession().save(status);
        }
        return unreadMessageIds.size();
    }

    @Override
    public long countUnreadMessages(Long conversationId, Long userId) {
        Long count = getSession().createQuery(
                "SELECT COUNT(m.id) FROM Message m " +
                "WHERE m.conversation.id = :conversationId " +
                "AND m.senderId <> :userId " +
                "AND m.deletedAt IS NULL " +
                "AND NOT EXISTS (" +
                "  SELECT 1 FROM MessageSeenStatus s " +
                "  WHERE s.message.id = m.id AND s.userId = :userId" +
                ")", Long.class)
                .setParameter("conversationId", conversationId)
                .setParameter("userId", userId)
                .uniqueResult();
        return count != null ? count : 0L;
    }
}
