package com.hibernate.repository;

import com.hibernate.entity.AdminPostAuditLog;
import lombok.RequiredArgsConstructor;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class AdminPostAuditLogRepositoryImpl implements AdminPostAuditLogRepository {
    private final SessionFactory sessionFactory;

    @Override
    public AdminPostAuditLog save(AdminPostAuditLog auditLog) {
        sessionFactory.getCurrentSession().save(auditLog);
        return auditLog;
    }
}
