package com.hibernate.service;

import com.hibernate.dto.RegistrationDto;
import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;
import com.hibernate.entity.enums.Role;
import com.hibernate.entity.enums.UserStatus;
import com.hibernate.repository.UserRepository;
import com.hibernate.service.UserService;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserServiceImpl implements UserService {
	@Autowired
    private SessionFactory sessionFactory;

    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }
    private final UserRepository userRepository;

    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    @Transactional
    public User registerNewUser(RegistrationDto dto) {
        
        // ၁။ Password Check
        if (dto.getPassword() == null || !dto.getPassword().equals(dto.getConfirmPassword())) {
            throw new IllegalArgumentException("Password နှင့် Confirm Password မကိုက်ညီပါ!");
        }

        // ၂။ Duplicate Email Check
        if (userRepository.findByEmail(dto.getEmail()).isPresent()) {
            throw new IllegalArgumentException("ဤ Email မှာ အသုံးပြုပြီးသား ဖြစ်နေပါသည်။");
        }

        // ၃။ Duplicate Username Check
        if (userRepository.findByUsername(dto.getUsername()).isPresent()) {
            throw new IllegalArgumentException("ဤ Username မှာ အသုံးပြုပြီးသား ဖြစ်နေပါသည်။");
        }

        // ၄။ User Map
        User user = new User();
        user.setUsername(dto.getUsername());
        user.setEmail(dto.getEmail());
        user.setPasswordHash(dto.getPassword()); // လက်တွေ့တွင် encode လုပ်ရန်လိုသည်
        user.setStatus(UserStatus.ACTIVE);
        user.setRole(Role.USER);

        // ၅။ UserProfile Map
        UserProfile profile = new UserProfile();
        profile.setFullName(dto.getFullName());
        profile.setBio(dto.getBio());
        profile.setDobDay(dto.getDobDay());
        profile.setDobMonth(dto.getDobMonth());
        profile.setDobYear(dto.getDobYear());
        
        // ၆။ Bind Relationship (အရေးကြီးဆုံးအပိုင်း)
        profile.setUser(user);    
        user.setProfile(profile); 

        // ၇။ Save to Database
        return userRepository.save(user);
    }
}