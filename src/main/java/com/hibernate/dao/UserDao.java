package com.hibernate.dao;

import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UserDao {

    @Autowired
    private SessionFactory sessionFactory;

    public void saveUser(User user) {
        sessionFactory.getCurrentSession().persist(user); 
    }

    public void saveProfile(UserProfile profile) {
        sessionFactory.getCurrentSession().persist(profile);
    }

    public boolean isEmailExists(String email) {
        Long count = (Long) sessionFactory.getCurrentSession()
                .createQuery("select count(u) from User u where u.email = :email", Long.class)
                .setParameter("email", email)
                .uniqueResult();
        return count > 0;
    }
    
    public User getUserByEmail(String email) {
    	return sessionFactory.getCurrentSession()
    			.createQuery("from User u where u.email =:email",User.class)
    			.setParameter("email", email).uniqueResult();
    }
    
}