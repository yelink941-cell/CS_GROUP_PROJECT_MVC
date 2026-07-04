package com.hibernate.repository;

import java.util.Optional;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import com.hibernate.entity.ConversationParticipant;
import com.hibernate.entity.enums.ParticipantRole;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
@Transactional
public class ConversationParticipantRepositoryImpl implements ConversationParticipantRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }
    @Override
    public Long insertParticipant(ConversationParticipant participant) {
        return (Long) getSession().save(participant);
    }

    @Override
    public boolean isUserParticipant(Long conversationId, Long userId) {
        // HQL Query သုံးပြီး အရေအတွက်ကို လှမ်းစစ်တာ ဖြစ်ပါတယ်
        String hql = "SELECT COUNT(p) FROM ConversationParticipant p " +
                     "WHERE p.conversation.id = :conversationId AND p.userId = :userId";
        
        Long count = getSession().createQuery(hql, Long.class)
                .setParameter("conversationId", conversationId)
                .setParameter("userId", userId)
                .uniqueResult();
                
        return count != null && count > 0;
    }

    @Override
    public Long findOtherParticipantUserId(Long conversationId, Long currentUserId) {
        String hql = "SELECT p.userId FROM ConversationParticipant p " +
                     "WHERE p.conversation.id = :conversationId AND p.userId <> :userId";

        return getSession().createQuery(hql, Long.class)
                .setParameter("conversationId", conversationId)
                .setParameter("userId", currentUserId)
                .setMaxResults(1)
                .uniqueResult();
    }

    @Override
    public Long findDirectConversationIdBetweenUsers(Long userId1, Long userId2) {
        String hql = "SELECT p1.conversation.id FROM ConversationParticipant p1, ConversationParticipant p2 " +
                     "WHERE p1.conversation.id = p2.conversation.id " +
                     "AND p1.userId = :userId1 AND p2.userId = :userId2 " +
                     "AND p1.conversation.isGroup = false";

        return getSession().createQuery(hql, Long.class)
                .setParameter("userId1", userId1)
                .setParameter("userId2", userId2)
                .setMaxResults(1)
                .uniqueResult();
    }

    @Override
    public Optional<ParticipantRole> findParticipantRole(Long conversationId, Long userId) {
        String hql = "SELECT p.role FROM ConversationParticipant p " +
                     "WHERE p.conversation.id = :conversationId AND p.userId = :userId";

        ParticipantRole role = getSession().createQuery(hql, ParticipantRole.class)
                .setParameter("conversationId", conversationId)
                .setParameter("userId", userId)
                .uniqueResult();

        return Optional.ofNullable(role);
    }

    @Override
    public Optional<ConversationParticipant> findParticipant(Long conversationId, Long userId) {
        String hql = "SELECT p FROM ConversationParticipant p " +
                     "WHERE p.conversation.id = :conversationId AND p.userId = :userId";

        ConversationParticipant participant = getSession().createQuery(hql, ConversationParticipant.class)
                .setParameter("conversationId", conversationId)
                .setParameter("userId", userId)
                .uniqueResult();

        return Optional.ofNullable(participant);
    }

    @Override
    public void updateParticipant(ConversationParticipant participant) {
        getSession().merge(participant);
    }

    @Override
    public void restoreConversationForUser(Long conversationId, Long userId) {
        findParticipant(conversationId, userId).ifPresent(participant -> {
            if (participant.getHiddenAt() != null) {
                participant.setHiddenAt(null);
                updateParticipant(participant);
            }
        });
    }
}