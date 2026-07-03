package com.hibernate.service;

import com.hibernate.entity.Post;
import com.hibernate.entity.enums.ContentType;
import com.hibernate.entity.enums.PostStatus;
import com.hibernate.entity.enums.PostVisibility;

import java.util.List;
import java.util.Optional;

public interface PostService {
    Post createPost(
            Post post,
            Integer categoryId,
            List<Integer> tagIds,
            Long userId,
            PostVisibility visibility,
            List<String> sectionSubtitles,
            List<ContentType> contentTypes,
            List<String> contentDataList,
            List<Integer> sortOrders);

    Post updatePost(Integer id, Post post, Integer categoryId, List<Integer> tagIds, PostVisibility visibility);

    void deletePost(Integer id);

    Optional<Post> getPostById(Integer id);

    List<Post> getAllPosts();

    List<Post> getPostsByAuthorId(Long authorId);

    Optional<Post> getPostBySlug(String slug);

    Optional<Post> getActivePostBySlug(String slug);

    boolean existsBySlug(String slug);

    List<Post> getPostsByCategoryId(Integer categoryId);

    List<Post> getPublishedPublicPostsByTagId(Integer tagId);

    List<Post> getPopularPublishedPublicPosts();

    List<Post> getNewestPublishedPublicPosts();

    List<Object[]> getPublishedPublicPostCountsByCategory();

    List<Object[]> getPublishedPublicPostCountsByTag();

    List<Post> getPostsByStatus(PostStatus status);

    List<Post> getPendingPosts();

    List<Post> getPublishedPublicPosts();

    void approvePost(Integer id);

    void rejectPost(Integer id, String rejectionReason);
    
    boolean toggleLike(Integer postId, Long userId);
    
    void addComment(Integer postId, Long userId, String text);
    
    boolean hasUserLiked(Integer postId, Long userId);
    
}