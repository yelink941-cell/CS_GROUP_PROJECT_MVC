package com.hibernate.service;
import java.util.List;

import com.hibernate.entity.User;
import com.hibernate.entity.UserPreference;
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
    void updateUserRoleAndStatus(Long userId, Role role, UserStatus status);
    void softDeleteUser(Long userId);
    
    UserPreference getUserPreferenceByUserId(Long userId);
    void saveUserPreference(UserPreference preference);

    boolean isFollowing(Long followerId, Long followingId);
    void followUser(Long followerId, Long followingId);
    void unfollowUser(Long followerId, Long followingId);
    
    User findUserByEmail(String email);
    void createPasswordResetTokenForUser(User user, String token);
    User findUserByResetToken(String token);
    void updatePassword(User user, String newPassword);
}