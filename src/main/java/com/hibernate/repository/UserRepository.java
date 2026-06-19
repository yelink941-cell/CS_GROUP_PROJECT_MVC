package com.hibernate.repository;

import com.hibernate.entity.User;



public interface UserRepository {
	void saveUser(User user);
    boolean isEmailExists(String email);
    User getUserById(Integer id);
    User getUserByEmail(String email);
}	
