package com.hibernate.repository;

import com.hibernate.entity.Post;
import com.hibernate.entity.PostView;
import com.hibernate.entity.enums.PostStatus;
import com.hibernate.entity.enums.PostVisibility;
import java.time.LocalDateTime;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class PostViewRepositoryImpl implements PostViewRepository {
    private final SessionFactory sessionFactory;

    @Override
    public boolean recordView(PostView postView) {
        Session session = sessionFactory.getCurrentSession();
        session.save(postView);
        session.createNativeQuery(
                        "UPDATE posts "
                                + "SET view_count = COALESCE(view_count, 0) + 1 "
                                + "WHERE id = :postId")
                .setParameter("postId", postView.getPost().getId())
                .executeUpdate();
        Integer currentViewCount = postView.getPost().getViewCount();
        postView.getPost().setViewCount(currentViewCount == null ? 1 : currentViewCount + 1);
        return true;
    }

    @Override
    public boolean existsUserViewWithin24Hours(Long postId, Long userId) {
        return !sessionFactory.getCurrentSession()
                .createNativeQuery(
                        "SELECT id FROM post_views "
                                + "WHERE post_id = :postId "
                                + "AND user_id = :userId "
                                + "AND viewed_at >= NOW() - INTERVAL 24 HOUR "
                                + "LIMIT 1")
                .setParameter("postId", postId)
                .setParameter("userId", userId)
                .getResultList()
                .isEmpty();
    }

    @Override
    public boolean existsGuestViewWithin24Hours(Long postId, String guestToken) {
        return !sessionFactory.getCurrentSession()
                .createNativeQuery(
                        "SELECT id FROM post_views "
                                + "WHERE post_id = :postId "
                                + "AND guest_token = :guestToken "
                                + "AND viewed_at >= NOW() - INTERVAL 24 HOUR "
                                + "LIMIT 1")
                .setParameter("postId", postId)
                .setParameter("guestToken", guestToken)
                .getResultList()
                .isEmpty();
    }

    @Override
    public List<PostView> findByPostId(Integer postId) {
        return sessionFactory.getCurrentSession()
                .createQuery(
                        "SELECT postView FROM PostView postView "
                                + "LEFT JOIN FETCH postView.viewer "
                                + "WHERE postView.post.id = :postId "
                                + "ORDER BY postView.viewedAt DESC",
                        PostView.class)
                .setParameter("postId", postId)
                .getResultList();
    }

    @Override
    public long countByPostId(Integer postId) {
        Long count = sessionFactory.getCurrentSession()
                .createQuery(
                        "SELECT COUNT(postView.id) FROM PostView postView "
                                + "WHERE postView.post.id = :postId",
                        Long.class)
                .setParameter("postId", postId)
                .uniqueResult();
        return count == null ? 0L : count;
    }

    @Override
    public List<Object[]> findTrendingPublishedPublicPosts(LocalDateTime viewedSince) {
        List<Object[]> trendingPosts = sessionFactory.getCurrentSession()
                .createQuery(
                        "SELECT post, COUNT(postView.id) FROM PostView postView "
                                + "JOIN postView.post post "
                                + "WHERE post.status = :status "
                                + "AND post.visibility = :visibility "
                                + "AND post.deletedAt IS NULL "
                                + "AND postView.viewedAt >= :viewedSince "
                                + "GROUP BY post "
                                + "ORDER BY COUNT(postView.id) DESC, "
                                + "COALESCE(post.viewCount, 0) DESC",
                        Object[].class)
                .setParameter("status", PostStatus.PUBLISHED)
                .setParameter("visibility", PostVisibility.PUBLIC)
                .setParameter("viewedSince", viewedSince)
                .getResultList();

        for (Object[] result : trendingPosts) {
            Post post = (Post) result[0];
            Hibernate.initialize(post.getAuthor());
            Hibernate.initialize(post.getCategory());
            Hibernate.initialize(post.getTags());
        }

        return trendingPosts;
    }
}
