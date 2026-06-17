package com.hibernate.repository;

import com.hibernate.entity.User;
import java.util.Optional;

public interface UserRepository {
    User save(User user);
    Optional<User> findByEmail(String email);
    Optional<User> findByUsername(String username);
}	