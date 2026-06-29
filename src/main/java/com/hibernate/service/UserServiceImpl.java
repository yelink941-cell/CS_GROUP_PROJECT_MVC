package com.hibernate.service;

import java.time.LocalDateTime;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hibernate.entity.Follower;
import com.hibernate.entity.User;
import com.hibernate.entity.UserPreference;
import com.hibernate.entity.UserProfile;
import com.hibernate.entity.enums.Role;
import com.hibernate.entity.enums.UserStatus;
import com.hibernate.repository.UserRepository;

import lombok.RequiredArgsConstructor;

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
        if (userRepository.isEmailExists(user.getEmail())
                || userRepository.findByUsername(user.getUsername()).isPresent()) {
            return false;
        }

        String hashedPassword = BCrypt.hashpw(user.getPasswordHash(), BCrypt.gensalt());
        user.setPasswordHash(hashedPassword);
        user.setStatus(UserStatus.ACTIVE);
        user.setRole(Role.USER);

        getCurrentSession().persist(user);

        profile.setUser(user);
        getCurrentSession().persist(profile);

        return true;
    }

    @Override
    @Transactional(readOnly = true)
    public User authenticateUser(String email, String plainPassword) {
        User user = findUserByEmail(email);

        if (user != null && BCrypt.checkpw(plainPassword, user.getPasswordHash())) {
            return user;
        }
        return null;
    }

    @Override
    @Transactional(readOnly = true)
    public User findUserByEmail(String email) {
        String hql = "FROM User WHERE email = :email AND deletedAt IS NULL";
        Query<User> query = getCurrentSession().createQuery(hql, User.class);
        query.setParameter("email", email);
        return query.uniqueResult();
    }

    @Override
    @Transactional
    public void createPasswordResetTokenForUser(User user, String token) {
        user.setResetToken(token);
        user.setTokenExpiryDate(LocalDateTime.now().plusMinutes(15));
        getCurrentSession().merge(user);
    }

    @Override
    @Transactional(readOnly = true)
    public User findUserByResetToken(String token) {
        String hql = "FROM User WHERE resetToken = :token AND tokenExpiryDate > :now AND deletedAt IS NULL";
        Query<User> query = getCurrentSession().createQuery(hql, User.class);
        query.setParameter("token", token);
        query.setParameter("now", LocalDateTime.now());
        return query.uniqueResult();
    }

    @Override
    @Transactional(readOnly = true)
    public boolean checkPassword(User user, String rawPassword) {
        return user != null && rawPassword != null && BCrypt.checkpw(rawPassword, user.getPasswordHash());
    }

    @Override
    @Transactional
    public void updatePassword(User user, String newPassword) {
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        user.setPasswordHash(hashedPassword);
        user.setResetToken(null);
        user.setTokenExpiryDate(null);
        getCurrentSession().merge(user);
    }

    @Override
    @Transactional(readOnly = true)
    public UserProfile getUserProfileByUserId(Long userId) {
        return getCurrentSession()
                .createQuery(
                        "FROM UserProfile up JOIN FETCH up.user WHERE up.user.id = :userId",
                        UserProfile.class)
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
    public boolean isFollowing(Long followerId, int followingId) {
        Long count = getCurrentSession()
                .createQuery(
                        "SELECT count(f) FROM Follower f WHERE f.follower.id = :fId AND f.following.id = :gId",
                        Long.class)
                .setParameter("fId", followerId)
                .setParameter("gId", Long.valueOf(followingId))
                .uniqueResult();
        return count != null && count > 0;
    }

    @Override
    @Transactional
    public void followUser(Long followerId, int followingId) {
        if (isFollowing(followerId, followingId)) {
            return;
        }

        Session session = getCurrentSession();
        Follower edge = new Follower();
        edge.setFollower(session.load(User.class, followerId));
        edge.setFollowing(session.load(User.class, Long.valueOf(followingId)));
        session.persist(edge);
    }

    @Override
    @Transactional
    public void unfollowUser(Long followerId, int followingId) {
        getCurrentSession()
                .createQuery("DELETE FROM Follower f WHERE f.follower.id = :fId AND f.following.id = :gId")
                .setParameter("fId", followerId)
                .setParameter("gId", Long.valueOf(followingId))
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
    public void updateUserRoleAndStatus(int userId, Role role, UserStatus status) {
        Session session = getCurrentSession();
        User user = session.get(User.class, Long.valueOf(userId));
        if (user != null) {
            user.setRole(role);
            user.setStatus(status);
            session.merge(user);
        }
    }

    @Override
    @Transactional
    public void softDeleteUser(int userId) {
        Session session = getCurrentSession();
        User user = session.get(User.class, Long.valueOf(userId));
        if (user != null) {
            user.setStatus(UserStatus.INACTIVE);
            session.merge(user);
        }
    }
}
