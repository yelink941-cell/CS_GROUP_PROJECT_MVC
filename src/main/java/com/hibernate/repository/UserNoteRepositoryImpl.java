package com.hibernate.repository;

import com.hibernate.entity.UserNote;
import lombok.RequiredArgsConstructor;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class UserNoteRepositoryImpl implements UserNoteRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public List<UserNote> findByUserId(Long userId) {
        return getSession()
                .createQuery(
                    "FROM UserNote n WHERE n.user.id = :userId AND n.admin IS NULL AND n.deletedAt IS NULL ORDER BY n.updatedAt DESC",
                    UserNote.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    @Override
    public List<UserNote> findAdminNotesByUserId(Long userId) {
        return getSession()
                .createQuery(
                    "FROM UserNote n WHERE n.user.id = :userId AND n.admin IS NOT NULL AND n.deletedAt IS NULL ORDER BY n.createdAt DESC",
                    UserNote.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    @Override
    public UserNote findById(Integer id) {
        return getSession()
                .createQuery(
                    "FROM UserNote n WHERE n.id = :id AND n.deletedAt IS NULL",
                    UserNote.class)
                .setParameter("id", id)
                .uniqueResult();
    }

    @Override
    public void save(UserNote note) {
        getSession().saveOrUpdate(note);
    }

    @Override
    public void update(UserNote note) {
        getSession().merge(note);
    }

    @Override
    public void delete(UserNote note) {
        // Soft delete — deletedAt field ကို set မည်
        note.setDeletedAt(java.time.LocalDateTime.now());
        getSession().saveOrUpdate(note);
    }
}
