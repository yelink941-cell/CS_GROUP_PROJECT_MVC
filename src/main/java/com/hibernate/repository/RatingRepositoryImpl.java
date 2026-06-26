package com.hibernate.repository;

import com.hibernate.entity.Rating;
import java.util.Optional;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class RatingRepositoryImpl implements RatingRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Optional<Rating> findByPostIdAndUserId(Integer postId, Long userId) {
        try {
            Rating rating = getSession()
                    .createQuery("FROM Rating r WHERE r.post.id = :postId AND r.user.id = :userId", Rating.class)
                    .setParameter("postId", postId)
                    .setParameter("userId", userId)
                    .uniqueResult();
            return Optional.ofNullable(rating);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public boolean existsByPostIdAndUserId(Integer postId, Long userId) {
        Long count = getSession()
                .createQuery("SELECT COUNT(r) FROM Rating r WHERE r.post.id = :postId AND r.user.id = :userId", Long.class)
                .setParameter("postId", postId)
                .setParameter("userId", userId)
                .uniqueResult();
        return count != null && count > 0;
    }

    @Override
    public Double getAverageRatingByPostId(Integer postId) {
        Double avg = getSession()
                .createQuery("SELECT AVG(r.rating) FROM Rating r WHERE r.post.id = :postId", Double.class)
                .setParameter("postId", postId)
                .uniqueResult();
        return avg != null ? avg : 0.0;
    }

    @Override
    public long countByPostId(Integer postId) {
        Long count = getSession()
                .createQuery("SELECT COUNT(r) FROM Rating r WHERE r.post.id = :postId", Long.class)
                .setParameter("postId", postId)
                .uniqueResult();
        return count != null ? count : 0;
    }

    @Override
    public void save(Rating rating) {
        getSession().saveOrUpdate(rating);
    }

    @Override
    public void delete(Rating rating) {
        getSession().delete(rating);
    }
}