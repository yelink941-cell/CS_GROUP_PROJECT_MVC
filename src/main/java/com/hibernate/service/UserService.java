package com.hibernate.service;

import org.springframework.stereotype.Service;

import com.hibernate.dto.RegistrationDto;
import com.hibernate.entity.User;
@Service
public interface UserService {
    User registerNewUser(RegistrationDto registrationDto);
}