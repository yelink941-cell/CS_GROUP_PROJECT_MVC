package com.hibernate.service;

import com.hibernate.entity.Category;
import java.util.List;
import java.util.Optional;

public interface CategoryService {
    Category createCategory(Category category);

    Category updateCategory(Category category);

    void deleteCategory(Integer id);

    Optional<Category> getCategoryById(Integer id);

    List<Category> getAllCategories();

    boolean existsByName(String name);
    long getTotalPostsInCategories();
}
