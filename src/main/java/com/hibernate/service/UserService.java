package com.hibernate.service;

import com.hibernate.dao.UserDao;
import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.mindrot.jbcrypt.BCrypt;

@Service 
public class UserService {

    @Autowired
    private UserDao userDao;

    @Transactional
    public boolean registerNewUser(User user, UserProfile profile) {
        // ၁။ Email ရှိပြီးသားလား အရင်စစ်မယ်
        if (userDao.isEmailExists(user.getEmail())) {
            return false; 
        }

        // ၂။ Password ကို BCrypt ဖြင့် ဟက်ရှ်လုပ်မည်
        String hashedPassword = BCrypt.hashpw(user.getPasswordHash(), BCrypt.gensalt());
        user.setPasswordHash(hashedPassword);

        // ၃။ Users table ထဲသို့ အရင် Insert လုပ်မည်
        userDao.saveUser(user);

        // ၄။ ရလာသော User Object နှင့် Profile အား ချိတ်ဆက်ပေးမည်
        profile.setUser(user); 
        
        // ၅။ UserProfile table ထဲသို့ ကျန်ရှိသော ဒေတာအားလုံး သိမ်းဆည်းမည်
        userDao.saveProfile(profile);
        
        return true;
    }
    @Transactional
    public User authenticateUser(String email, String plainPassword) {
    	User user = userDao.getUserByEmail(email);
    	
    	if (user!= null && BCrypt.checkpw(plainPassword, user.getPasswordHash() ) ) {
    		return user;
    	}
    	return null;
    }
}
