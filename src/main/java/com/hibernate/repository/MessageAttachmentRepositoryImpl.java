package com.hibernate.repository;

import com.hibernate.entity.MessageAttachment;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
@Transactional
public class MessageAttachmentRepositoryImpl implements MessageAttachmentRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Long insertAttachment(MessageAttachment attachment) {
        return (Long) getSession().save(attachment);
    }
}
