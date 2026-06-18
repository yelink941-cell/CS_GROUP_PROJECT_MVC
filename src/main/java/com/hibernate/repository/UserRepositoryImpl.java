package com.hibernate.repository;
import com.hibernate.entity.User;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

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
    public User save(User user) {
        if (user.getId() == null) {
            getCurrentSession().save(user); // Data အသစ်သွင်းခြင်း
            return user;
        } else {
            getCurrentSession().update(user); // Update လုပ်ခြင်း
            return user;
        }
    }

    @Override
    public Optional<User> findByEmail(String email) {
        User user = getCurrentSession().createQuery(
            "FROM User u WHERE u.email = :email", User.class)
            .setParameter("email", email)
            .uniqueResult(); 
            
        return Optional.ofNullable(user);
    }

    @Override
    public Optional<User> findByUsername(String username) {
        User user = getCurrentSession().createQuery(
            "FROM User u WHERE u.username = :username", User.class)
            .setParameter("username", username)
            .uniqueResult();
            
        return Optional.ofNullable(user);
    }
}