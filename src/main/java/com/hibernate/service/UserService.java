package com.hibernate.service;

<<<<<<< Updated upstream
import com.hibernate.dto.RegistrationDto;
import com.hibernate.entity.User;

public interface UserService {
    User registerNewUser(RegistrationDto registrationDto);
=======
import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;
import java.util.List;

public interface UserService {
    boolean registerNewUser(User user, UserProfile profile);
    User authenticateUser(String email, String plainPassword);
    UserProfile getUserProfileByUserId(int userId);
    void updateUserProfile(UserProfile profile);
    
    // User List အတွက် အသစ်ထည့်လိုက်သည့် method
    List<User> getAllUsers(); 
    void deleteUser(int id); // ဒီစာကြောင်းကို ထည့်ပေးပါ
    void banUser(int id);
>>>>>>> Stashed changes
}