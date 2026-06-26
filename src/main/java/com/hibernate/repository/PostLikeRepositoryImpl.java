package com.hibernate.repository;

import com.hibernate.entity.PostLike;
import java.util.Optional;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class PostLikeRepositoryImpl implements PostLikeRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Optional<PostLike> findByPostIdAndUserId(Integer postId, Long userId) { // 🟢 (Integer, Long) အတိုင်း အတိအကျရေးပါ
        try {
            PostLike like = getSession()
                    .createQuery("FROM PostLike pl WHERE pl.post.id = :postId AND pl.user.id = :userId", PostLike.class)
                    .setParameter("postId", postId)
                    .setParameter("userId", userId)
                    .uniqueResult();
            return Optional.ofNullable(like);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public boolean existsByPostIdAndUserId(Integer postId, Long userId) { // 🟢 (Integer, Long) အတိုင်း အတိအကျရေးပါ
        Long count = getSession()
                .createQuery("SELECT COUNT(pl) FROM PostLike pl WHERE pl.post.id = :postId AND pl.user.id = :userId", Long.class)
                .setParameter("postId", postId)
                .setParameter("userId", userId)
                .uniqueResult();
        return count != null && count > 0;
    }

    @Override
    public long countByPostId(Integer postId) { // 🟢 (Integer) အတိုင်း အတိအကျရေးပါ
        Long count = getSession()
                .createQuery("SELECT COUNT(pl) FROM PostLike pl WHERE pl.post.id = :postId", Long.class)
                .setParameter("postId", postId)
                .uniqueResult();
        return count != null ? count : 0;
    }
    
    @Override
    public void save(PostLike postLike) {
        getSession().saveOrUpdate(postLike);
    }

    @Override
    public void delete(PostLike postLike) {
        getSession().delete(postLike);
    }
}