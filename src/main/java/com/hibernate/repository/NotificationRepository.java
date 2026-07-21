package com.hibernate.repository;

import com.hibernate.entity.Notification;
import java.util.List;

public interface NotificationRepository {
    void save(Notification notification);
    List<Notification> findByUserId(Long userId);
    long countUnreadByUserId(Long userId);
    Notification findById(Integer id);
    void delete(Notification notification);
}
