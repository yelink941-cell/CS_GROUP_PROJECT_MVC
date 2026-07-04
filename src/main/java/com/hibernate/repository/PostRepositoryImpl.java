package com.hibernate.repository;

import com.hibernate.entity.Post;
import com.hibernate.entity.enums.PostStatus;
import com.hibernate.entity.enums.PostVisibility;
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
        Post post = getCurrentSession()
                .createQuery(
                        "SELECT DISTINCT p FROM Post p "
                                + "LEFT JOIN FETCH p.author "
                                + "LEFT JOIN FETCH p.category "
                                + "LEFT JOIN FETCH p.tags "
                                + "WHERE p.id = :id",
                        Post.class)
                .setParameter("id", id)
                .uniqueResult();

        return Optional.ofNullable(post);
    }

    @Override
    public List<Post> findAll() {
        return getCurrentSession()
                .createQuery(
                        "SELECT p FROM Post p "
                                + "LEFT JOIN FETCH p.category "
                                + "WHERE p.deletedAt IS NULL",
                        Post.class)
                .getResultList();
    }

    @Override
    public List<Post> findByAuthorId(Long authorId) {
        return getCurrentSession()
                .createQuery(
                        "SELECT p FROM Post p "
                                + "LEFT JOIN FETCH p.category "
                                + "WHERE p.author.id = :authorId "
                                + "AND p.deletedAt IS NULL "
                                + "ORDER BY p.createdAt DESC",
                        Post.class)
                .setParameter("authorId", authorId)
                .getResultList();
    }

    @Override
    public Optional<Post> findBySlug(String slug) {
        Post post = getCurrentSession()
                .createQuery(
                        "SELECT DISTINCT p FROM Post p "
                                + "LEFT JOIN FETCH p.author "
                                + "LEFT JOIN FETCH p.category "
                                + "LEFT JOIN FETCH p.tags "
                                + "WHERE p.slug = :slug "
                                + "AND p.status = :status "
                                + "AND p.visibility = :visibility "
                                + "AND p.deletedAt IS NULL",
                        Post.class)
                .setParameter("slug", slug)
                .setParameter("status", PostStatus.PUBLISHED)
                .setParameter("visibility", PostVisibility.PUBLIC)
                .uniqueResult();

        return Optional.ofNullable(post);
    }

    @Override
    public Optional<Post> findActiveBySlug(String slug) {
        Post post = getCurrentSession()
                .createQuery(
                        "SELECT DISTINCT p FROM Post p "
                                + "LEFT JOIN FETCH p.author "
                                + "LEFT JOIN FETCH p.category "
                                + "LEFT JOIN FETCH p.tags "
                                + "WHERE p.slug = :slug "
                                + "AND p.deletedAt IS NULL",
                        Post.class)
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
                        "SELECT DISTINCT p FROM Post p "
                                + "LEFT JOIN FETCH p.author "
                                + "LEFT JOIN FETCH p.category "
                                + "LEFT JOIN FETCH p.tags "
                                + "WHERE p.category.id = :categoryId "
                                + "AND p.status = :status "
                                + "AND p.visibility = :visibility "
                                + "AND p.deletedAt IS NULL "
                                + "ORDER BY p.createdAt DESC",
                        Post.class)
                .setParameter("categoryId", categoryId)
                .setParameter("status", PostStatus.PUBLISHED)
                .setParameter("visibility", PostVisibility.PUBLIC)
                .getResultList();
    }

    @Override
    public List<Post> findPublishedPublicByTagId(Integer tagId) {
        return getCurrentSession()
                .createQuery(
                        "SELECT DISTINCT p FROM Post p "
                                + "JOIN p.tags filteredTag "
                                + "LEFT JOIN FETCH p.author "
                                + "LEFT JOIN FETCH p.category "
                                + "LEFT JOIN FETCH p.tags "
                                + "WHERE filteredTag.id = :tagId "
                                + "AND p.status = :status "
                                + "AND p.visibility = :visibility "
                                + "AND p.deletedAt IS NULL "
                                + "ORDER BY p.createdAt DESC",
                        Post.class)
                .setParameter("tagId", tagId)
                .setParameter("status", PostStatus.PUBLISHED)
                .setParameter("visibility", PostVisibility.PUBLIC)
                .getResultList();
    }

    @Override
    public List<Post> findPopularPublishedPublicPosts() {
        return getCurrentSession()
                .createQuery(
                        "SELECT DISTINCT p FROM Post p "
                                + "LEFT JOIN FETCH p.author "
                                + "LEFT JOIN FETCH p.category "
                                + "LEFT JOIN FETCH p.tags "
                                + "WHERE p.status = :status "
                                + "AND p.visibility = :visibility "
                                + "AND p.deletedAt IS NULL "
                                + "ORDER BY COALESCE(p.viewCount, 0) DESC, p.createdAt DESC",
                        Post.class)
                .setParameter("status", PostStatus.PUBLISHED)
                .setParameter("visibility", PostVisibility.PUBLIC)
                .getResultList();
    }

    @Override
    public List<Object[]> countPublishedPublicPostsByCategory() {
        return getCurrentSession()
                .createQuery(
                        "SELECT category, COUNT(post.id) FROM Category category "
                                + "LEFT JOIN category.posts post WITH "
                                + "post.status = :status "
                                + "AND post.visibility = :visibility "
                                + "AND post.deletedAt IS NULL "
                                + "GROUP BY category "
                                + "ORDER BY category.name",
                        Object[].class)
                .setParameter("status", PostStatus.PUBLISHED)
                .setParameter("visibility", PostVisibility.PUBLIC)
                .getResultList();
    }

    @Override
    public List<Object[]> countPublishedPublicPostsByTag() {
        return getCurrentSession()
                .createQuery(
                        "SELECT tag, COUNT(post.id) FROM Tag tag "
                                + "LEFT JOIN tag.posts post WITH "
                                + "post.status = :status "
                                + "AND post.visibility = :visibility "
                                + "AND post.deletedAt IS NULL "
                                + "GROUP BY tag "
                                + "ORDER BY tag.name",
                        Object[].class)
                .setParameter("status", PostStatus.PUBLISHED)
                .setParameter("visibility", PostVisibility.PUBLIC)
                .getResultList();
    }

    @Override
    public List<Post> findByStatus(PostStatus status) {
        return getCurrentSession()
                .createQuery(
                        "SELECT p FROM Post p "
                                + "LEFT JOIN FETCH p.category "
                                + "WHERE p.status = :status "
                                + "AND p.visibility = :visibility "
                                + "AND p.deletedAt IS NULL",
                        Post.class)
                .setParameter("status", status)
                .setParameter("visibility", PostVisibility.PUBLIC)
                .getResultList();
    }

    @Override
    public List<Post> findPendingPosts() {
        return getCurrentSession()
                .createQuery(
                        "SELECT p FROM Post p "
                                + "LEFT JOIN FETCH p.author "
                                + "LEFT JOIN FETCH p.category "
                                + "WHERE p.status = :status "
                                + "AND p.deletedAt IS NULL",
                        Post.class)
                .setParameter("status", PostStatus.PENDING)
                .getResultList();
    }

    @Override
    public List<Post> findPublishedPublicPosts() {
        return getCurrentSession()
                .createQuery(
                        "SELECT DISTINCT p FROM Post p "
                                + "LEFT JOIN FETCH p.author "
                                + "LEFT JOIN FETCH p.category "
                                + "LEFT JOIN FETCH p.tags "
                                + "WHERE p.status = :status "
                                + "AND p.visibility = :visibility "
                                + "AND p.deletedAt IS NULL "
                                + "ORDER BY p.createdAt DESC",
                        Post.class)
                .setParameter("status", PostStatus.PUBLISHED)
                .setParameter("visibility", PostVisibility.PUBLIC)
                .getResultList();
    }
}
