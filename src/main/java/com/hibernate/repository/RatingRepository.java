package com.hibernate.repository;

import com.hibernate.entity.Rating;
import java.util.Optional;
import org.springframework.stereotype.Repository;

@Repository
public interface RatingRepository {
    Optional<Rating> findByPostIdAndUserId(Integer postId, Long userId);
    boolean existsByPostIdAndUserId(Integer postId, Long userId);
    Double getAverageRatingByPostId(Integer postId);
    long countByPostId(Integer postId);
    void save(Rating rating);
    void delete(Rating rating);
}