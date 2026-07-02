package com.hibernate.repository;

import com.hibernate.entity.Bookmark;
import com.hibernate.entity.Post;

import java.util.List;
import java.util.Optional;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class BookmarkRepositoryImpl implements BookmarkRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Optional<Bookmark> findByUserIdAndPostId(Long userId, Integer postId) {
        try {
            Bookmark bookmark = getSession()
                    .createQuery("FROM Bookmark b WHERE b.user.id = :userId AND b.post.id = :postId", Bookmark.class)
                    .setParameter("userId", userId)
                    .setParameter("postId", postId)
                    .uniqueResult();
            return Optional.ofNullable(bookmark);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public boolean existsByUserIdAndPostId(Long userId, Integer postId) {
        Long count = getSession()
                .createQuery("SELECT COUNT(b) FROM Bookmark b WHERE b.user.id = :userId AND b.post.id = :postId", Long.class)
                .setParameter("userId", userId)
                .setParameter("postId", postId)
                .uniqueResult();
        return count != null && count > 0;
    }

    @Override
    public long countByPostId(Integer postId) {
        Long count = getSession()
                .createQuery("SELECT COUNT(b) FROM Bookmark b WHERE b.post.id = :postId", Long.class)
                .setParameter("postId", postId)
                .uniqueResult();
        return count != null ? count : 0L;
    }

    @Override
    public void save(Bookmark bookmark) {
        getSession().saveOrUpdate(bookmark);
    }

    @Override
    public void delete(Bookmark bookmark) {
        getSession().delete(bookmark);
    }
    
    @Override
    public List<Post> findPostsByUserId(Long userId) {
        try {
            return getSession()
                    .createQuery("SELECT b.post FROM Bookmark b WHERE b.user.id = :userId", Post.class)
                    .setParameter("userId", userId)
                    .getResultList();
        } catch (Exception e) {
            return List.of(); // Error တက်ပါက Empty list ပြန်ရန်
        }
    }
}