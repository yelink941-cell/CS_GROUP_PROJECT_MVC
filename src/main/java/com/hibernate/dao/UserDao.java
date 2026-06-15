package com.hibernate.dao;

import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UserDao {

    @Autowired
    private SessionFactory sessionFactory;

    /**
     * Persist a new user row during registration
     */
    public void saveUser(User user) {
        sessionFactory.getCurrentSession().persist(user); 
    }

    /**
     * Persist a new companion user profile row
     */
    public void saveProfile(UserProfile profile) {
        sessionFactory.getCurrentSession().persist(profile);
    }

    /**
     * Validate email uniqueness
     */
    public boolean isEmailExists(String email) {
        Long count = sessionFactory.getCurrentSession()
                .createQuery("select count(u) from User u where u.email = :email", Long.class)
                .setParameter("email", email)
                .uniqueResult();
        return count > 0;
    }
    
    /**
     * Fetch user instance for login authentication sequences
     */
    public User getUserByEmail(String email) {
        return sessionFactory.getCurrentSession()
                .createQuery("from User u where u.email = :email", User.class)
                .setParameter("email", email)
                .uniqueResult();
    }

    /**
     * Fetch specific profile row tied securely via entity mappings
     */
    public UserProfile getUserProfileByUserId(int userId) {
        return sessionFactory.getCurrentSession()
               .createQuery("FROM UserProfile up WHERE up.user.id = :userId", UserProfile.class)
               .setParameter("userId", userId)
               .uniqueResult();
    }
    
    /**
     * NEW: Merges detached updates back into database storage rows safely
     */
    public void updateProfile(UserProfile profile) {
        sessionFactory.getCurrentSession().merge(profile);
    }
}