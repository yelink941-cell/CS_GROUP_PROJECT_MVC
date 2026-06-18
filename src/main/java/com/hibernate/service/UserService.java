package com.hibernate.service;

import com.hibernate.dto.RegistrationDto;
import com.hibernate.entity.User;

public interface UserService {
    User registerNewUser(RegistrationDto registrationDto);
    User loginUser(String email, String password);
}