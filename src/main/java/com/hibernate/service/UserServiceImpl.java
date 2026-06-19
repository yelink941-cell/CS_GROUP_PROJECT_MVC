package com.hibernate.service;

import com.hibernate.dto.RegistrationDto;
import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;
import com.hibernate.entity.enums.Role;
import com.hibernate.entity.enums.UserStatus;
import com.hibernate.repository.UserRepository;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.mindrot.jbcrypt.BCrypt;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final SessionFactory sessionFactory;
    private final UserRepository userRepository;

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
    @Transactional
    public User registerNewUser(RegistrationDto dto) {
        if (dto.getPassword() == null
                || !dto.getPassword().equals(dto.getConfirmPassword())) {
            throw new IllegalArgumentException("Password and confirmation do not match.");
        }

        User user = new User();
        user.setUsername(dto.getUsername());
        user.setEmail(dto.getEmail());
        user.setPasswordHash(dto.getPassword());
        user.setStatus(UserStatus.ACTIVE);
        user.setRole(Role.USER);

        UserProfile profile = new UserProfile();
        profile.setFullName(dto.getFullName());
        profile.setBio(dto.getBio());
        profile.setDobDay(dto.getDobDay());
        profile.setDobMonth(dto.getDobMonth());
        profile.setDobYear(dto.getDobYear());

        if (!registerNewUser(user, profile)) {
            throw new IllegalArgumentException("This email is already registered.");
        }

        return user;
    }

    @Override
    @Transactional(readOnly = true)
    public User authenticateUser(String email, String plainPassword) {
        User user = userRepository.getUserByEmail(email);

        if (user != null && BCrypt.checkpw(plainPassword, user.getPasswordHash())) {
            return user;
        }
        return null;
    }

    @Override
    @Transactional(readOnly = true)
    public User loginUser(String email, String password) {
        return authenticateUser(email, password);
    }
}
