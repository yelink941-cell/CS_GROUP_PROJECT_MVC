package com.hibernate.repository;

import com.hibernate.entity.Post;
import com.hibernate.entity.enums.PostStatus;
import java.util.List;
import java.util.Optional;

public interface PostRepository {
    Post save(Post post);

    Post update(Post post);

    void delete(Integer id);

    Optional<Post> findById(Integer id);

    List<Post> findAll();

    List<Post> findByAuthorId(Integer authorId);

    Optional<Post> findBySlug(String slug);

    boolean existsBySlug(String slug);

    List<Post> findByCategoryId(Integer categoryId);

    List<Post> findByStatus(PostStatus status);

    List<Post> findPendingPosts();

    List<Post> findPublishedPublicPosts();
}
