package com.hibernate.repository;

import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;

import java.util.List;
import java.util.Optional;

public interface UserRepository {
    void saveUser(User user);
    User save(User user);
    boolean isEmailExists(String email);
    
    // 🔴 ဤနေရာတွင် primitive (long l) (သို့) အခြား အမျိုးအစား မဟုတ်ဘဲ Long Object Type ကို အသုံးပြုထားရပါမည်
    User getUserById(Long longUserId); 
    
    User getUserByEmail(String email);
    
    void updateProfile(UserProfile profile);
    
    UserProfile getUserProfileByUserId(int userId);

    Optional<User> findByEmail(String email);
    Optional<User> findByUsername(String username);
    Optional<User> findById(Long id);
    List<User> searchByUsername(String keyword, Long excludeUserId, int limit);
}
