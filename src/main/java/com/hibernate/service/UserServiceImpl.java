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
    public boolean isFollowing(Long followerId, Long followingId) { 
        Long count = getCurrentSession()
                .createQuery(
                        "SELECT count(f) FROM Follower f WHERE f.follower.id = :fId AND f.following.id = :gId",
                        Long.class)
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
       
        edge.setFollower(session.load(User.class, followerId));
        edge.setFollowing(session.load(User.class, followingId)); 
        
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
    public long getFollowerCount(Long userId) {
        String hql = "SELECT COUNT(f) FROM Follower f WHERE f.following.id = :userId";
        Long count = getCurrentSession()
                .createQuery(hql, Long.class)
                .setParameter("userId", userId)
                .uniqueResult();
        return count != null ? count : 0L;
    }

    @Override
    @Transactional(readOnly = true)
    public long getFollowingCount(Long userId) {
        String hql = "SELECT COUNT(f) FROM Follower f WHERE f.follower.id = :userId";
        Long count = getCurrentSession()
                .createQuery(hql, Long.class)
                .setParameter("userId", userId)
                .uniqueResult();
        return count != null ? count : 0L;
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<User> getFollowersByUserId(Long userId) {
        // Grab all User objects who are following this target userId
        String hql = "SELECT f.follower FROM Follower f LEFT JOIN FETCH f.follower.profile WHERE f.following.id = :userId";
        return getCurrentSession().createQuery(hql, User.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> getFollowingByUserId(Long userId) {
        // Grab all User objects that this specific userId is actively following
        String hql = "SELECT f.following FROM Follower f LEFT JOIN FETCH f.following.profile WHERE f.follower.id = :userId";
        return getCurrentSession().createQuery(hql, User.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> getAllUsers() {
        return getCurrentSession()
                .createQuery("FROM User u LEFT JOIN FETCH u.profile", User.class)
                .getResultList();
    }
    
 // 🛠️ Updated paginated method with smart parameter check logic
    @Override
    @Transactional(readOnly = true)
    public List<User> getAllUsersPaginated(int page, int pageSize, String search) {
        int firstResult = (page - 1) * pageSize;
        
        StringBuilder hql = new StringBuilder("FROM User u LEFT JOIN FETCH u.profile ");
        boolean hasSearch = (search != null && !search.trim().isEmpty());
        
        // Group conditions inside brackets so OR clauses don't break row filters
        if (hasSearch) {
            hql.append("WHERE u.deletedAt IS NULL AND (u.username LIKE :search OR u.email LIKE :search OR u.profile.fullName LIKE :search) ");
        } else {
            hql.append("WHERE u.deletedAt IS NULL ");
        }
        hql.append("ORDER BY u.id DESC");
        
        var query = getCurrentSession().createQuery(hql.toString(), User.class);
        if (hasSearch) {
            query.setParameter("search", "%" + search.trim() + "%");
        }
        
        return query.setFirstResult(firstResult)
                    .setMaxResults(pageSize)
                    .getResultList();
    }

    // 🛠️ Updated helper counter method with matching logic grouping
    @Override
    @Transactional(readOnly = true)
    public long getTotalUserCount(String search) {
        StringBuilder hql = new StringBuilder("SELECT COUNT(u) FROM User u WHERE u.deletedAt IS NULL ");
        boolean hasSearch = (search != null && !search.trim().isEmpty());
        
        if (hasSearch) {
            hql.append("AND (u.username LIKE :search OR u.email LIKE :search OR u.profile.fullName LIKE :search) ");
        }
        
        var query = getCurrentSession().createQuery(hql.toString(), Long.class);
        if (hasSearch) {
            query.setParameter("search", "%" + search.trim() + "%");
        }
        
        Long count = query.uniqueResult();
        return count != null ? count : 0L;
    }

    @Override
    @Transactional
    public void updateUserRoleAndStatus(Long userId, Role role, UserStatus status) {
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
    public void softDeleteUser(Long userId) {
        Session session = getCurrentSession();
        User user = session.get(User.class, Long.valueOf(userId));
        if (user != null) {
            user.setStatus(UserStatus.INACTIVE);
            session.merge(user);
        }
    }
    @Override
    @Transactional(readOnly = true)
    public long getPostCountByUserId(Long userId) {
        String hql = "SELECT COUNT(p) FROM Post p WHERE p.author.id = :userId AND p.deletedAt IS NULL";
        Long count = getCurrentSession()
                .createQuery(hql, Long.class)
                .setParameter("userId", userId) 
                .uniqueResult();
        return count != null ? count : 0L;
    }
    @Override
    @Transactional
    public void updateUserOnlineStatus(Long userId, boolean isOnline) {
        if (userId == null) return;
        Session session = getCurrentSession();
        User user = session.get(User.class, userId);
        if (user != null) {
            user.setIsOnline(isOnline);
            user.setLastSeen(LocalDateTime.now());
            session.merge(user);
        }
    }
}

