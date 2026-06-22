package com.hibernate.service;

import org.springframework.stereotype.Service;

import com.hibernate.dto.RegistrationDto;
import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;

public interface UserService {
    boolean registerNewUser(User user, UserProfile profile);

    User registerNewUser(RegistrationDto registrationDto);

    User authenticateUser(String email, String plainPassword);

    User loginUser(String email, String password);
}
