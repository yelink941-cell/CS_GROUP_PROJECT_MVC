package com.hibernate.service;

import com.hibernate.entity.Notification;
import java.util.List;

public interface NotificationService {
    void createNotification(Long userId, String type, String title, String message, String referenceType, Integer referenceId);
    void broadcastNotification(String type, String title, String message, String referenceType, Integer referenceId);
    List<Notification> getNotificationsForUser(Long userId);
    long getUnreadCount(Long userId);
    void markAsRead(Integer notificationId, Long userId);
    void markAllAsRead(Long userId);
}
