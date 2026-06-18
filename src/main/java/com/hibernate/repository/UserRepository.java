package com.hibernate.repository;

import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;



public interface UserRepository {
	void saveUser(User user);
    void saveProfile(UserProfile profile);
    boolean isEmailExists(String email);
    User getUserByEmail(String email);
    UserProfile getUserProfileByUserId(int userId);
    void updateProfile(UserProfile profile);
}	