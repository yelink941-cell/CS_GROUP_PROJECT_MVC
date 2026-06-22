package com.hibernate.service;

import com.hibernate.dto.RegistrationDto;
import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;
import com.hibernate.entity.enums.Role;
import com.hibernate.entity.enums.UserStatus;
import com.hibernate.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository; // ဒါကိုပဲ သုံးပါမယ်

    @Override
    @Transactional
    public User registerNewUser(RegistrationDto dto) {
    	
        // ၁။ User Object အသစ်တည်ဆောက်ခြင်း
        User user = new User();
        user.setUsername(dto.getUsername());
        user.setEmail(dto.getEmail());
        user.setPasswordHash(dto.getPassword()); 
        user.setStatus(UserStatus.ACTIVE);
        user.setRole(Role.USER);

        // ၂။ UserProfile Object အသစ်တည်ဆောက်ခြင်း
        UserProfile profile = new UserProfile();
        profile.setFullName(dto.getFullName());
        profile.setBio(dto.getBio());
        profile.setDobDay(dto.getDobDay());
        profile.setDobMonth(dto.getDobMonth());
        profile.setDobYear(dto.getDobYear());
        
        // ၃။ Relationship ချိတ်ဆက်ခြင်း
        profile.setUser(user);   
        user.setProfile(profile);

        // ၄။ Save လုပ်ခြင်း (EntityManager အစား UserRepository ကိုသုံးပါ)
        User savedUser = userRepository.save(user); 
        userRepository.flush(); // Database ထဲသို့ ချက်ချင်း ပို့ပေးရန်
        
        return savedUser;
    }
}