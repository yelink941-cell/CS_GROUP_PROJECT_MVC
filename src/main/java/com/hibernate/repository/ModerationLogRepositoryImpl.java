package com.hibernate.repository;

import com.hibernate.entity.ModerationLog;
import lombok.RequiredArgsConstructor;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class ModerationLogRepositoryImpl implements ModerationLogRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public void save(ModerationLog log) {
        getSession().saveOrUpdate(log);
    }

    @Override
    public List<ModerationLog> findAll() {
        return getSession()
                .createQuery("FROM ModerationLog m ORDER BY m.createdAt DESC", ModerationLog.class)
                .getResultList();
    }
}
