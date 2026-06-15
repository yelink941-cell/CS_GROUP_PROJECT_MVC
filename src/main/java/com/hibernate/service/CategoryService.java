package com.hibernate.service;

import com.hibernate.dao.CategoryDAO;
import com.hibernate.entity.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class CategoryService {

    @Autowired
    private CategoryDAO categoryDAO;

    @Transactional
    public List<Category> listAll() {
        return categoryDAO.getAllCategories();
    }

    @Transactional
    public Category get(int id) {
        return categoryDAO.getCategoryById(id);
    }

    @Transactional
    public void save(Category category) {
        categoryDAO.saveOrUpdateCategory(category);
    }

    @Transactional
    public void delete(int id) {
        categoryDAO.deleteCategory(id);
    }
}