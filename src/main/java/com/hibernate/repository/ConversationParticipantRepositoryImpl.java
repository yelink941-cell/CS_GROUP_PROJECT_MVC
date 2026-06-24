package com.hibernate.repository;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import com.hibernate.entity.ConversationParticipant;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
@Transactional
public class ConversationParticipantRepositoryImpl implements ConversationParticipantRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }
//==========================================================
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
}