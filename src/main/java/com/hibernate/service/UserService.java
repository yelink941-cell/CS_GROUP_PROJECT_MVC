package com.hibernate.service;
import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;

public interface UserService {
	boolean registerNewUser(User user, UserProfile profile);
    User authenticateUser(String email, String plainPassword);
    UserProfile getUserProfileByUserId(int userId);
    void updateUserProfile(UserProfile profile);
}