package com.hibernate.repository;

import com.hibernate.entity.ModerationLog;
import java.util.List;

public interface ModerationLogRepository {
    void save(ModerationLog log);
    List<ModerationLog> findAll();
}
