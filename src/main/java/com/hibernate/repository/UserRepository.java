package com.hibernate.repository;

import java.util.List;
import java.util.Optional;

import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;

public interface UserRepository {
    void saveUser(User user);

    User save(User user);

    boolean isEmailExists(String email);

    User getUserById(Long id);

    User getUserByEmail(String email);

    void updateProfile(UserProfile profile);

    UserProfile getUserProfileByUserId(int userId);

    Optional<User> findByEmail(String email);

    Optional<User> findByUsername(String username);

    Optional<User> findById(Long id);

    List<User> searchByUsername(String keyword, Long excludeUserId, int limit);
}
