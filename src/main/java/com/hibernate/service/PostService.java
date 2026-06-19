package com.hibernate.service;

import com.hibernate.entity.Post;
import com.hibernate.entity.enums.PostStatus;
import com.hibernate.entity.enums.PostVisibility;
import java.util.List;
import java.util.Optional;

public interface PostService {
    Post createPost(Post post, Integer categoryId, List<Integer> tagIds, Long userId, PostVisibility visibility);

    Post updatePost(Integer id, Post post, Integer categoryId, List<Integer> tagIds, PostVisibility visibility);

    void deletePost(Integer id);

    Optional<Post> getPostById(Integer id);

    List<Post> getAllPosts();

    List<Post> getPostsByAuthorId(Long authorId);

    Optional<Post> getPostBySlug(String slug);

    boolean existsBySlug(String slug);

    List<Post> getPostsByCategoryId(Integer categoryId);

    List<Post> getPostsByStatus(PostStatus status);

    List<Post> getPendingPosts();

    List<Post> getPublishedPublicPosts();

    void approvePost(Integer id);

    void rejectPost(Integer id, String rejectionReason);
}
