package com.hibernate.service;

import com.hibernate.entity.Post;
import com.hibernate.entity.enums.PostStatus;
import java.util.List;
import java.util.Optional;

public interface PostService {
    Post createPost(Post post, Integer categoryId, List<Integer> tagIds);

    Post updatePost(Integer id, Post post, Integer categoryId, List<Integer> tagIds);

    void deletePost(Integer id);

    Optional<Post> getPostById(Integer id);

    List<Post> getAllPosts();

    Optional<Post> getPostBySlug(String slug);

    boolean existsBySlug(String slug);

    List<Post> getPostsByCategoryId(Integer categoryId);

    List<Post> getPostsByStatus(PostStatus status);
}
