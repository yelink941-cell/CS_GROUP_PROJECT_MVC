package com.hibernate.repository;

import com.hibernate.entity.Post;
import com.hibernate.entity.enums.PostStatus;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class PostRepositoryImpl implements PostRepository {
    private final SessionFactory sessionFactory;

    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Post save(Post post) {
        getCurrentSession().save(post);
        return post;
    }

    @Override
    public Post update(Post post) {
        getCurrentSession().update(post);
        return post;
    }

    @Override
    public void delete(Integer id) {
        findById(id).ifPresent(post -> {
            post.setDeletedAt(LocalDateTime.now());
            getCurrentSession().update(post);
        });
    }

    @Override
    public Optional<Post> findById(Integer id) {
        return Optional.ofNullable(getCurrentSession().get(Post.class, id));
    }

    @Override
    public List<Post> findAll() {
        return getCurrentSession()
                .createQuery("FROM Post p WHERE p.deletedAt IS NULL", Post.class)
                .getResultList();
    }

    @Override
    public Optional<Post> findBySlug(String slug) {
        Post post = getCurrentSession()
                .createQuery("FROM Post p WHERE p.slug = :slug AND p.deletedAt IS NULL", Post.class)
                .setParameter("slug", slug)
                .uniqueResult();

        return Optional.ofNullable(post);
    }

    @Override
    public boolean existsBySlug(String slug) {
        Long count = getCurrentSession()
                .createQuery("SELECT COUNT(p.id) FROM Post p WHERE p.slug = :slug", Long.class)
                .setParameter("slug", slug)
                .uniqueResult();

        return count != null && count > 0;
    }

    @Override
    public List<Post> findByCategoryId(Integer categoryId) {
        return getCurrentSession()
                .createQuery(
                        "FROM Post p WHERE p.category.id = :categoryId AND p.deletedAt IS NULL",
                        Post.class)
                .setParameter("categoryId", categoryId)
                .getResultList();
    }

    @Override
    public List<Post> findByStatus(PostStatus status) {
        return getCurrentSession()
                .createQuery("FROM Post p WHERE p.status = :status AND p.deletedAt IS NULL", Post.class)
                .setParameter("status", status)
                .getResultList();
    }
}
