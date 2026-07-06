package com.hibernate.repository;

import com.hibernate.entity.Post;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class AdminPostManagementRepositoryImpl implements AdminPostManagementRepository {
    private final SessionFactory sessionFactory;

    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public List<Post> findAllForManagement() {
        return getCurrentSession()
                .createQuery(
                        "SELECT DISTINCT p FROM Post p "
                                + "LEFT JOIN FETCH p.author "
                                + "LEFT JOIN FETCH p.category "
                                + "LEFT JOIN FETCH p.tags "
                                + "ORDER BY p.createdAt DESC",
                        Post.class)
                .getResultList();
    }

    @Override
    public Optional<Post> findByIdForManagement(Integer id) {
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
    public Post update(Post post) {
        getCurrentSession().update(post);
        return post;
    }
}
