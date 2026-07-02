package com.hibernate.repository;

import com.hibernate.entity.MessageReport;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
@Transactional
public class MessageReportRepositoryImpl implements MessageReportRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Long insertReport(MessageReport report) {
        return (Long) getSession().save(report);
    }
}
