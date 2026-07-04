package com.hibernate.service;

import com.hibernate.entity.Follower;
import com.hibernate.entity.User;
import com.hibernate.entity.UserPreference;
import com.hibernate.entity.UserProfile;
import com.hibernate.entity.enums.Role;
import com.hibernate.entity.enums.UserStatus;

import org.hibernate.query.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import com.hibernate.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

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

        Long count = session.createQuery("select count(u) from User u where u.email = :email", Long.class)
                .setParameter("email", user.getEmail())
                .uniqueResult();

        if (count > 0) {
            return false; 
        }

        String hashedPassword = BCrypt.hashpw(user.getPasswordHash(), BCrypt.gensalt());
        user.setPasswordHash(hashedPassword);
        
        session.persist(user); 

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
    public User findUserByEmail(String email) {
        Session session = getCurrentSession(); 
        String hql = "FROM User WHERE email = :email AND deletedAt IS NULL";
        Query<User> query = session.createQuery(hql, User.class);
        query.setParameter("email", email);
        return query.uniqueResult();
    }

    @Override
    @Transactional 
    public void createPasswordResetTokenForUser(User user, String token) {
        Session session = getCurrentSession(); 
        user.setResetToken(token);
    
        user.setTokenExpiryDate(LocalDateTime.now().plusMinutes(5)); 
        session.merge(user);
    }

    @Override
    @Transactional(readOnly = true) 
    public User findUserByResetToken(String token) {
        Session session = getCurrentSession(); 
        
        String hql = "FROM User WHERE resetToken = :token AND tokenExpiryDate > :now AND deletedAt IS NULL";
        Query<User> query = session.createQuery(hql, User.class);
        query.setParameter("token", token);
        query.setParameter("now", LocalDateTime.now());
        return query.uniqueResult();
    }

    @Override
    @Transactional
    public void updatePassword(User user, String newPassword) {
        Session session = getCurrentSession();
        
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        user.setPasswordHash(hashedPassword);
        
        // Burn parameters clean so an entry can never be recycled
        user.setResetToken(null);
        user.setTokenExpiryDate(null);
        
        session.merge(user); 
    }

    @Override
    @Transactional(readOnly = true)
    public UserProfile getUserProfileByUserId(Long userId) {
        return getCurrentSession()
                .createQuery(
                    "FROM UserProfile up " +
                    "JOIN FETCH up.user " + 
                    "WHERE up.user.id = :userId", UserProfile.class)
                .setParameter("userId", userId)
                .uniqueResult();
    }

    @Override
    @Transactional
    public void updateUserProfile(UserProfile profile) {
        getCurrentSession().merge(profile);
    }

    @Override
    @Transactional(readOnly = true)
    public User getUserById(Long userId) {
        return getCurrentSession().get(User.class, userId);
    }
    
    @Override
    @Transactional(readOnly = true)
    public UserPreference getUserPreferenceByUserId(Long userId) {
        return getCurrentSession()
                .createQuery("FROM UserPreference up WHERE up.user.id = :userId", UserPreference.class)
                .setParameter("userId", userId)
                .uniqueResult();
    }

    @Override
    @Transactional
    public void saveUserPreference(UserPreference preference) {
        getCurrentSession().merge(preference);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isFollowing(Long followerId, Long followingId) {
        Long count = getCurrentSession()
                .createQuery("SELECT count(f) FROM Follower f WHERE f.follower.id = :fId AND f.following.id = :gId", Long.class)
                .setParameter("fId", followerId)
                .setParameter("gId", followingId)
                .uniqueResult();
        return count > 0;
    }

    @Override
    @Transactional
    public void followUser(Long followerId, Long followingId) {
        if (isFollowing(followerId, followingId)) return; 
        
        Session session = getCurrentSession();
        Follower edge = new Follower();
        edge.setFollower(session.get(User.class, followerId));
        edge.setFollowing(session.get(User.class, followingId));
        
        session.persist(edge);
    }

    @Override
    @Transactional
    public void unfollowUser(Long followerId, Long followingId) {
        getCurrentSession()
                .createQuery("DELETE FROM Follower f WHERE f.follower.id = :fId AND f.following.id = :gId")
                .setParameter("fId", followerId)
                .setParameter("gId", followingId)
                .executeUpdate();
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> getAllUsers() {
        return getCurrentSession()
                .createQuery("FROM User u LEFT JOIN FETCH u.profile", User.class)
                .getResultList();
    }

    @Override
    @Transactional
    public void updateUserRoleAndStatus(Long userId, Role role, UserStatus status) {
        Session session = getCurrentSession();
        User user = session.get(User.class, userId);
        if (user != null) {
            user.setRole(role);
            user.setStatus(status);
            session.merge(user); 
        }
    }

    @Override
    @Transactional
    public void softDeleteUser(Long userId) {
        Session session = getCurrentSession();
        User user = session.get(User.class, userId);
        if (user != null) {
            user.setStatus(UserStatus.INACTIVE);
            session.merge(user);
        }
    }
}
