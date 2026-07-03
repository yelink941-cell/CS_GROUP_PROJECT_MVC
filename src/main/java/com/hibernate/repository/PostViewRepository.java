package com.hibernate.repository;

import com.hibernate.entity.PostView;
import java.time.LocalDateTime;
import java.util.List;

public interface PostViewRepository {
    boolean recordView(PostView postView);

    boolean existsUserViewWithin24Hours(Long postId, Long userId);

    boolean existsGuestViewWithin24Hours(Long postId, String guestToken);

    List<PostView> findByPostId(Integer postId);

    long countByPostId(Integer postId);

    List<Object[]> findTrendingPublishedPublicPosts(LocalDateTime viewedSince);
}
