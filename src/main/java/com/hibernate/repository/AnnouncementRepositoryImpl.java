package com.hibernate.repository;

import com.hibernate.entity.Announcement;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class AnnouncementRepositoryImpl implements AnnouncementRepository {

    private final SessionFactory sessionFactory;

    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Announcement save(Announcement announcement) {
        getCurrentSession().saveOrUpdate(announcement);
        return announcement;
    }

    @Override
    public Optional<Announcement> findById(Integer id) {
        Announcement announcement = getCurrentSession()
                .createQuery("SELECT a FROM Announcement a LEFT JOIN FETCH a.createdAdmin WHERE a.id = :id", Announcement.class)
                .setParameter("id", id)
                .uniqueResult();
        return Optional.ofNullable(announcement);
    }

    @Override
    public List<Announcement> findAll() {
        return getCurrentSession()
                .createQuery("SELECT a FROM Announcement a LEFT JOIN FETCH a.createdAdmin ORDER BY a.createdAt DESC", Announcement.class)
                .getResultList();
    }

    @Override
    public void delete(Integer id) {
        findById(id).ifPresent(announcement -> getCurrentSession().delete(announcement));
    }
}
