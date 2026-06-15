package com.hibernate.dao;

import com.hibernate.entity.Category;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public class CategoryDAO {

    @Autowired
    private SessionFactory sessionFactory;

    public List<Category> getAllCategories() {
        Session session = sessionFactory.getCurrentSession();
        return session.createQuery("from Category", Category.class).getResultList();
    }

    public Category getCategoryById(int id) {
        return sessionFactory.getCurrentSession().get(Category.class, id);
    }

    public void saveOrUpdateCategory(Category category) {
        sessionFactory.getCurrentSession().saveOrUpdate(category);
    }

    public void deleteCategory(int id) {
        Session session = sessionFactory.getCurrentSession();
        Category category = session.get(Category.class, id);
        if (category != null) {
            session.delete(category);
        }
    }
}