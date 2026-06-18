package com.hibernate.repository;

import com.hibernate.entity.Message;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public class MessageRepositoryImpl implements MessageRepository {

    private final SessionFactory sessionFactory;

    public MessageRepositoryImpl(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Message save(Message message) {
        getCurrentSession().save(message);
        return message;
    }

    @Override
    public List<Message> findByConversationId(Long conversationId) {
        // အခန်းနံပါတ်အလိုက် စာတွေကို အချိန်အလိုက် စီပြီး ရှာဖွေရန် HQL ရေးနည်းပါ
        String hql = "FROM Message m WHERE m.conversation.id = :conversationId ORDER BY m.createdAt DESC";
        return getCurrentSession().createQuery(hql, Message.class)
                .setParameter("conversationId", conversationId)
                .getResultList();
    }
}