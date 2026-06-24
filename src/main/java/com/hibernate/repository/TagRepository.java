package com.hibernate.repository;

import com.hibernate.entity.Tag;
import java.util.List;
import java.util.Optional;

public interface TagRepository {
    Tag save(Tag tag);

    Tag update(Tag tag);

    void delete(Integer id);

    Optional<Tag> findById(Integer id);

    List<Tag> findAll();

    boolean existsByName(String name);
}
