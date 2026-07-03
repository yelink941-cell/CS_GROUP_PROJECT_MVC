package com.hibernate.repository;

import com.hibernate.entity.Category;
import java.util.List;
import java.util.Optional;

public interface CategoryRepository {
    Category save(Category category);

    Category update(Category category);

    void delete(Integer id);

    Optional<Category> findById(Integer id);

    List<Category> findAll();

    boolean existsByName(String name);
    long countTotalPostsInAllCategories();
}
