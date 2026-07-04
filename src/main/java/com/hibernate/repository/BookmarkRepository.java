package com.hibernate.repository;

import com.hibernate.entity.Bookmark;
import com.hibernate.entity.Post;

import java.util.List;
import java.util.Optional;
import org.springframework.stereotype.Repository;

@Repository
public interface BookmarkRepository {
    Optional<Bookmark> findByUserIdAndPostId(Long userId, Integer postId);
    boolean existsByUserIdAndPostId(Long userId, Integer postId);
    long countByPostId(Integer postId);
    void save(Bookmark bookmark);
    void delete(Bookmark bookmark);
    List<Post> findPostsByUserId(Long userId);
}