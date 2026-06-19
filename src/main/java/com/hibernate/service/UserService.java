package com.hibernate.service;

import com.hibernate.dto.RegistrationDto;
import com.hibernate.entity.User;

public interface UserService {
	boolean registerNewUser(User user, UserProfile profile);
    User authenticateUser(String email, String plainPassword);
}
