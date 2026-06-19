package com.hibernate.repository;

import com.hibernate.entity.User;
import java.util.List;
import java.util.Optional;

public interface UserRepository {
    User save(User user);
    Optional<User> findByEmail(String email);
    Optional<User> findByUsername(String username);
    Optional<User> findById(Long id);
    List<User> searchByUsername(String keyword, Long excludeUserId, int limit);
}	