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
            post.setIsDeleted(true);
            post.setStatus(PostStatus.USER_DELETED);
            getCurrentSession().update(post);
        });
    }

    @Override
    public void deletePermanently(Integer id) {
        Session session = getCurrentSession();

        session.createQuery(
                        "DELETE FROM CommentReport commentReport "
                                + "WHERE commentReport.comment.id IN ("
                                + "SELECT comment.id FROM Comment comment WHERE comment.post.id = :postId)")
                .setParameter("postId", id)
                .executeUpdate();

        session.createQuery("UPDATE Comment comment SET comment.parent = NULL WHERE comment.post.id = :postId")
                .setParameter("postId", id)
                .executeUpdate();

        session.createQuery("DELETE FROM Comment comment WHERE comment.post.id = :postId")
                .setParameter("postId", id)
                .executeUpdate();

        session.createQuery("DELETE FROM PostView postView WHERE postView.post.id = :postId")
                .setParameter("postId", id)
                .executeUpdate();

        session.createQuery("DELETE FROM PostLike postLike WHERE postLike.post.id = :postId")
                .setParameter("postId", id)
                .executeUpdate();

        session.createQuery("DELETE FROM Bookmark bookmark WHERE bookmark.post.id = :postId")
                .setParameter("postId", id)
                .executeUpdate();

        session.createQuery("DELETE FROM Rating rating WHERE rating.post.id = :postId")
                .setParameter("postId", id)
                .executeUpdate();

        session.createQuery("DELETE FROM PostReport postReport WHERE postReport.post.id = :postId")
                .setParameter("postId", id)
                .executeUpdate();

        session.createQuery("DELETE FROM PostDownload postDownload WHERE postDownload.post.id = :postId")
                .setParameter("postId", id)
                .executeUpdate();

        session.createQuery("DELETE FROM PostContent postContent WHERE postContent.post.id = :postId")
                .setParameter("postId", id)
                .executeUpdate();

        session.createNativeQuery("DELETE FROM collection_posts WHERE post_id = :postId")
                .setParameter("postId", id)
                .executeUpdate();

        session.createNativeQuery("DELETE FROM post_tags WHERE post_id = :postId")
                .setParameter("postId", id)
                .executeUpdate();

        session.createNativeQuery("DELETE FROM reports WHERE post_id = :postId")
                .setParameter("postId", id)
                .executeUpdate();

        session.createNativeQuery("DELETE FROM moderation_logs WHERE post_id = :postId")
                .setParameter("postId", id)
                .executeUpdate();

        session.createNativeQuery("DELETE FROM posts WHERE id = :postId")
                .setParameter("postId", id)
                .executeUpdate();
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
                                + "WHERE p.deletedAt IS NULL "
                                + "ORDER BY p.createdAt DESC",
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
    public List<Post> findPopularPublishedPublicPosts(int limit) {
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
                .setMaxResults(limit)
                .getResultList();
    }

    @Override
    public List<Post> findTrendingPublishedPublicPosts(int limit, LocalDateTime since) {
        return getCurrentSession()
                .createQuery(
                        "SELECT DISTINCT p FROM Post p "
                                + "LEFT JOIN FETCH p.author "
                                + "LEFT JOIN FETCH p.category "
                                + "LEFT JOIN FETCH p.tags "
                                + "WHERE p.status = :status "
                                + "AND p.visibility = :visibility "
                                + "AND p.deletedAt IS NULL "
                                + "AND p.createdAt >= :since "
                                + "ORDER BY COALESCE(p.viewCount, 0) DESC, p.createdAt DESC",
                        Post.class)
                .setParameter("status", PostStatus.PUBLISHED)
                .setParameter("visibility", PostVisibility.PUBLIC)
                .setParameter("since", since)
                .setMaxResults(limit)
                .getResultList();
    }

    @Override
    public List<Post> findNewestPublishedPublicPosts(int limit) {
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
                .setMaxResults(limit)
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
    @Override
    public long count() {
        return getCurrentSession()
                .createQuery("SELECT COUNT(p) FROM Post p WHERE p.deletedAt IS NULL", Long.class)
                .getSingleResult();
    }

    @Override
    public long countByStatus(PostStatus status) {
        return getCurrentSession()
                .createQuery("SELECT COUNT(p) FROM Post p WHERE p.status = :status AND p.deletedAt IS NULL", Long.class)
                .setParameter("status", status)
                .getSingleResult();
    }
}
