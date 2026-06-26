package com.hibernate.repository;

import com.hibernate.entity.Category;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class CategoryRepositoryImpl implements CategoryRepository {
    private final SessionFactory sessionFactory;

    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Category save(Category category) {
        getCurrentSession().save(category);
        return category;
    }

    @Override
    public Category update(Category category) {
        getCurrentSession().update(category);
        return category;
    }

    @Override
    public void delete(Integer id) {
        findById(id).ifPresent(getCurrentSession()::delete);
    }

    @Override
    public Optional<Category> findById(Integer id) {
        return Optional.ofNullable(getCurrentSession().get(Category.class, id));
    }

    @Override
    public List<Category> findAll() {
        return getCurrentSession()
                .createQuery("FROM Category", Category.class)
                .getResultList();
    }

    @Override
    public boolean existsByName(String name) {
        Long count = getCurrentSession()
                .createQuery("SELECT COUNT(c.id) FROM Category c WHERE c.name = :name", Long.class)
                .setParameter("name", name)
                .uniqueResult();

        return count != null && count > 0;
    }
}
