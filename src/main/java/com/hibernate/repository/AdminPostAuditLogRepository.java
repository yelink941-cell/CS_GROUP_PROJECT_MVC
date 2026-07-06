package com.hibernate.repository;

import com.hibernate.entity.AdminPostAuditLog;

public interface AdminPostAuditLogRepository {
    AdminPostAuditLog save(AdminPostAuditLog auditLog);
}
