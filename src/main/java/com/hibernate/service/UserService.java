package com.hibernate.service;

import java.util.List;

import com.hibernate.entity.User;
import com.hibernate.entity.UserPreference;  // ✅ ဒီ import ကိုထည့်ပါ
import com.hibernate.entity.UserProfile;
import com.hibernate.entity.enums.Role;
import com.hibernate.entity.enums.UserStatus;

public interface UserService {
    boolean registerNewUser(User user, UserProfile profile);

    User authenticateUser(String email, String plainPassword);

    UserProfile getUserProfileByUserId(Long userId);

    void updateUserProfile(UserProfile profile);

    User getUserById(Long userId);

    List<User> getAllUsers();
    List<User> getAllUsersPaginated(int page, int pageSize, String search);
    long getTotalUserCount(String search);
    void updateUserRoleAndStatus(Long userId, Role role, UserStatus status);
    void softDeleteUser(Long userId);
    
    boolean isFollowing(Long followerId, Long followingId);
    void followUser(Long followerId, Long followingId);
    void unfollowUser(Long followerId, Long followingId);
    long getFollowerCount(Long userId);
    long getFollowingCount(Long userId);
    List<User> getFollowersByUserId(Long userId);
    List<User> getFollowingByUserId(Long userId);
    
    User findUserByEmail(String email);

    void createPasswordResetTokenForUser(User user, String token);

    User findUserByResetToken(String token);
    void updatePassword(User user, String newPassword);
    long getPostCountByUserId(Long userId);

    void updateUserOnlineStatus(Long userId, boolean isOnline);
    long countAllUsers();
    
    // ✅ UserPreference methods
    UserPreference getUserPreferenceByUserId(Long userId);
    void saveUserPreference(UserPreference preference);
}