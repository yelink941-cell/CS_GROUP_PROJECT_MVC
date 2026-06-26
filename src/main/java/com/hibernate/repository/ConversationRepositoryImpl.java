package com.hibernate.repository;

import java.util.List;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import com.hibernate.entity.Conversation;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
@Transactional
public class ConversationRepositoryImpl implements ConversationRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Long insertConversation(Conversation conversation) {
        return (Long) getSession().save(conversation);
    }

    @Override
    public Conversation getById(Long id) {
        return getSession().get(Conversation.class, id);
    }

    @Override
    public Conversation getByIdWithParticipants(Long id) {
        return getSession().createQuery(
                "SELECT DISTINCT c FROM Conversation c " +
                "LEFT JOIN FETCH c.participants " +
                "WHERE c.id = :id", Conversation.class)
                .setParameter("id", id)
                .uniqueResult();
    }

    @Override
    public List<Conversation> getAllConversationsByUserId(Long userId) {
        String hql = "SELECT DISTINCT c FROM Conversation c " +
                     "JOIN FETCH c.participants p " +
                     "WHERE p.userId = :userId " +
                     "ORDER BY c.updatedAt DESC";
                     
        return getSession().createQuery(hql, Conversation.class)
                .setParameter("userId", userId)
                .list();
    }

    @Override
    public void updateConversation(Conversation conversation) {
        getSession().update(conversation);
    }
}