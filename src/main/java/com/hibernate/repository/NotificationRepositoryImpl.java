package com.hibernate.repository;

import com.hibernate.entity.Notification;
import lombok.RequiredArgsConstructor;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class NotificationRepositoryImpl implements NotificationRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public void save(Notification notification) {
        getSession().saveOrUpdate(notification);
    }

    @Override
    public List<Notification> findByUserId(Long userId) {
        return getSession()
                .createQuery(
                        "FROM Notification n WHERE n.user.id = :userId ORDER BY n.createdAt DESC",
                        Notification.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    @Override
    public long countUnreadByUserId(Long userId) {
        Long count = getSession()
                .createQuery(
                        "SELECT COUNT(n) FROM Notification n WHERE n.user.id = :userId AND n.isRead = false",
                        Long.class)
                .setParameter("userId", userId)
                .uniqueResult();
        return count != null ? count : 0L;
    }

    @Override
    public Notification findById(Integer id) {
        return getSession().get(Notification.class, id);
    }

    @Override
    public void delete(Notification notification) {
        getSession().delete(notification);
    }
}
