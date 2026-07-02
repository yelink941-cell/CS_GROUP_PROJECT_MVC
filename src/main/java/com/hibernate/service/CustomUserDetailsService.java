package com.hibernate.service;

import com.hibernate.entity.User;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;

@Service("customUserDetailsService")
public class CustomUserDetailsService implements UserDetailsService {

    private final UserService userService;

    // Spring automatically injects your existing UserServiceImpl here
    public CustomUserDetailsService(UserService userService) {
        this.userService = userService;
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        // 1. Look up the user by email using your existing Hibernate method
        User user = userService.findUserByEmail(email);
        
        // 2. If the email doesn't exist, throw this to let Spring Security block the login
        if (user == null) {
            throw new UsernameNotFoundException("No active profile matching email: " + email);
        }
        
        // 3. Take your Role enum (like ADMIN) and turn it into "ROLE_ADMIN" for Spring rules
        String roleName = "ROLE_" + user.getRole().name();

        // 4. Return this wrapped object so Spring can automatically verify the BCrypt hash
        return new org.springframework.security.core.userdetails.User(
            user.getEmail(), 
            user.getPasswordHash(), // This is the BCrypt hash from your database
            Collections.singletonList(new SimpleGrantedAuthority(roleName))
        );
    }
}