package com.hibernate.service;

public interface RatingService {
    void toggleRating(Integer postId, Long userId, Integer ratingValue);
    Double getAverageRating(Integer postId);
    long getRatingCount(Integer postId);
    boolean hasUserRated(Integer postId, Long userId);
    Integer getUserRating(Integer postId, Long userId);
}