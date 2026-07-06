package com.hibernate.service;

import com.hibernate.entity.Tag;
import java.util.List;
import java.util.Optional;

public interface TagService {
    Tag createTag(Tag tag);

    Tag updateTag(Tag tag);

    void deleteTag(Integer id);

    Optional<Tag> getTagById(Integer id);

    List<Tag> getAllTags();

    boolean existsByName(String name);
    double getAverageTagsPerPost();
    String getMostUsedTagName();
    List<Tag> getAllTagsWithPostCount();
}
