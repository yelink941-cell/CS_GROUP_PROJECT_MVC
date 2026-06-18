package com.hibernate.service;

import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;
import com.hibernate.entity.enums.Role;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private SessionFactory sessionFactory;

    // Helper method to get the current context-bound transaction session
    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    @Transactional
    public boolean registerNewUser(User user, UserProfile profile) {
        Session session = getCurrentSession();

        // 1. Check if email already exists using HQL
        Long count = session.createQuery("select count(u) from User u where u.email = :email", Long.class)
                .setParameter("email", user.getEmail())
                .uniqueResult();

        if (count > 0) {
            return false; // Email already registered
        }

        // 2. Hash password and persist parent entity (User)
        String hashedPassword = BCrypt.hashpw(user.getPasswordHash(), BCrypt.gensalt());
        user.setPasswordHash(hashedPassword);
        
        // This inserts the user into DB and assigns the auto-generated ID to the object
        session.persist(user); 

        // 3. Link parent to child entity and persist child (UserProfile)
        profile.setUser(user); 
        session.persist(profile);
        
        return true;
    }

    @Override
    @Transactional(readOnly = true)
    public User authenticateUser(String email, String plainPassword) {
        Session session = getCurrentSession();
        
        User user = session.createQuery("from User u where u.email = :email", User.class)
                .setParameter("email", email)
                .uniqueResult();
                
        if (user != null && BCrypt.checkpw(plainPassword, user.getPasswordHash())) {
            return user;
        }
        return null;
    }

    @Override
    @Transactional(readOnly = true)
    public UserProfile getUserProfileByUserId(int userId) {
        return getCurrentSession()
                .createQuery("FROM UserProfile up WHERE up.user.id = :userId", UserProfile.class)
                .setParameter("userId", userId)
                .uniqueResult();
    }

    @Override
    @Transactional
    public void updateUserProfile(UserProfile profile) {
        // merge acts as an update for detached objects coming from the MVC controller
        getCurrentSession().merge(profile);
    }
}