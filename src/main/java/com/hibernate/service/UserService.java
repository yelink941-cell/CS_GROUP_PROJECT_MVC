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
    UserProfile getUserProfileByUserId(int userId);
    void updateUserProfile(UserProfile profile);
    
    User getUserById(int userId);
    List<User> getAllUsers();
    void updateUserRoleAndStatus(int userId, Role role, UserStatus status);
    void softDeleteUser(int userId);
    
    UserPreference getUserPreferenceByUserId(int userId);
    void saveUserPreference(UserPreference preference);

    boolean isFollowing(int followerId, int followingId);
    void followUser(int followerId, int followingId);
    void unfollowUser(int followerId, int followingId);
    
    User findUserByEmail(String email);
    void createPasswordResetTokenForUser(User user, String token);
    User findUserByResetToken(String token);
    void updatePassword(User user, String newPassword);
}
import com.hibernate.entity.UserProfile;

public interface UserService {
    boolean registerNewUser(User user, UserProfile profile);

    User registerNewUser(RegistrationDto registrationDto);

    User authenticateUser(String email, String plainPassword);

    User loginUser(String email, String password);
}
