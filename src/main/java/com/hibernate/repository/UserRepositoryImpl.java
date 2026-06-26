package com.hibernate.repository;

import com.hibernate.entity.User;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Repository
@Transactional
public class UserRepositoryImpl implements UserRepository {
    
    @Autowired
    private SessionFactory sessionFactory;

    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public void saveUser(User user) {
        getCurrentSession().persist(user);
    }

    @Override
    public User save(User user) {
        if (user.getId() == null) {
            getCurrentSession().save(user);
        } else {
            getCurrentSession().update(user);
        }

        return user;
    }

    @Override
    public boolean isEmailExists(String email) {
        Long count = getCurrentSession()
                .createQuery("select count(u) from User u where u.email = :email", Long.class)
                .setParameter("email", email)
                .uniqueResult();
        return count != null && count > 0;
    }

    @Override
    public User getUserById(Long id) {
        return getCurrentSession().get(User.class, id);
    }

    @Override
    public User getUserByEmail(String email) {
        return getCurrentSession()
                .createQuery("from User u where u.email = :email", User.class)
                .setParameter("email", email)
                .uniqueResult();
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return Optional.ofNullable(getUserByEmail(email));
    }

    @Override
    public Optional<User> findByUsername(String username) {
        User user = getCurrentSession()
                .createQuery("from User u where u.username = :username", User.class)
                .setParameter("username", username)
                .uniqueResult();

        return Optional.ofNullable(user);
    }

    @Override
    public Optional<User> findById(Long id) {
        return Optional.ofNullable(getUserById(id));
    }

    @Override
    public List<User> searchByUsername(String keyword, Long excludeUserId, int limit) {
        return getCurrentSession()
                .createQuery(
                        "from User u where u.deletedAt is null "
                                + "and u.id <> :excludeId "
                                + "and lower(u.username) like lower(:keyword) "
                                + "order by u.username asc",
                        User.class)
                .setParameter("excludeId", excludeUserId)
                .setParameter("keyword", "%" + keyword + "%")
                .setMaxResults(limit)
                .getResultList();
    }
}