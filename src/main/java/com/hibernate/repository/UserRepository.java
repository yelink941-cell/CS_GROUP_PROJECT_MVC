package com.hibernate.repository;

import com.hibernate.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional; // ဒီ Import ကို သေချာစစ်ပါ

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
    
    // Optional သုံးထားမှသာ .isPresent() ကို သုံးလို့ရပါမယ်
    Optional<User> findByEmail(String email);
    Optional<User> findByUsername(String username);
}