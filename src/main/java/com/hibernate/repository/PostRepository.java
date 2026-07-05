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

    List<Post> findByAuthorId(Long authorId);

    Optional<Post> findBySlug(String slug);

    Optional<Post> findActiveBySlug(String slug);

    boolean existsBySlug(String slug);

    List<Post> findByCategoryId(Integer categoryId);

    List<Post> findPublishedPublicByTagId(Integer tagId);

    List<Post> findPopularPublishedPublicPosts();

    List<Object[]> countPublishedPublicPostsByCategory();

    List<Object[]> countPublishedPublicPostsByTag();

    List<Post> findByStatus(PostStatus status);

    List<Post> findPendingPosts();

    List<Post> findPublishedPublicPosts();
    
    long count(); // စုစုပေါင်း Post အရေအတွက်
    long countByStatus(PostStatus status); // Pending Post အရေအတွက်အတွက်
}
