package com.hibernate.repository;

import com.hibernate.entity.Tag;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class TagRepositoryImpl implements TagRepository {
    private final SessionFactory sessionFactory;

    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Tag save(Tag tag) {
        getCurrentSession().save(tag);
        return tag;
    }

    @Override
    public Tag update(Tag tag) {
        getCurrentSession().update(tag);
        return tag;
    }

    @Override
    public void delete(Integer id) {
        findById(id).ifPresent(getCurrentSession()::delete);
    }

    @Override
    public Optional<Tag> findById(Integer id) {
        return Optional.ofNullable(getCurrentSession().get(Tag.class, id));
    }

    @Override
    public List<Tag> findAll() {
        return getCurrentSession()
                .createQuery("FROM Tag", Tag.class)
                .getResultList();
    }

    @Override
    public boolean existsByName(String name) {
        Long count = getCurrentSession()
                .createQuery("SELECT COUNT(t.id) FROM Tag t WHERE t.name = :name", Long.class)
                .setParameter("name", name)
                .uniqueResult();

        return count != null && count > 0;
    }
}
