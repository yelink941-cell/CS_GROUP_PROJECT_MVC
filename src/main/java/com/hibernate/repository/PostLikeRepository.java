package com.hibernate.repository;

import java.util.Optional;
import org.springframework.stereotype.Repository;
import com.hibernate.entity.PostLike;

@Repository
public interface PostLikeRepository {
    
    Optional<PostLike> findByPostIdAndUserId(Integer postId, Long userId);
    
    boolean existsByPostIdAndUserId(Integer postId, Long userId);
    
    long countByPostId(Integer postId);
    
    void save(PostLike postLike);
    
    void delete(PostLike postLike);
}