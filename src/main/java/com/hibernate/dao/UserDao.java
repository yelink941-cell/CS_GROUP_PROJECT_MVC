package com.hibernate.dao;

import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;
import java.util.List;

public interface UserDao {
    void saveUser(User user);
    void saveProfile(UserProfile profile);
    boolean isEmailExists(String email);
    User getUserByEmail(String email);
    UserProfile getUserProfileByUserId(int userId);
    void updateProfile(UserProfile profile);
 
    // User List ထုတ်ရန်
    List<User> getAllUsers();
    void deleteUser(int id); 
    void banUser(int id);
}