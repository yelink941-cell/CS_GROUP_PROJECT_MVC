package com.hibernate.service;

import com.hibernate.dto.RegistrationDto;
import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;
import com.hibernate.entity.enums.Role;
import com.hibernate.entity.enums.UserStatus;
import com.hibernate.repository.UserRepository;
import com.hibernate.service.UserService;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserServiceImpl implements UserService {
	@Autowired
    private SessionFactory sessionFactory;

    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }
    private final UserRepository userRepository;

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

}
