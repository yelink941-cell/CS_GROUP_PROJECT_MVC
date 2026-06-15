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

    /**
     * အသုံးပြုသူအသစ်အား Password Hash ပြုလုပ်၍ ဒေတာဘေ့စ်ထဲသို့ သိမ်းဆည်းခြင်း
     */
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

        // ၄။ ရလာသော User Object နှင့် Profile အား ချိတ်ဆက်ပေးမည် (@OneToOne Relation)
        profile.setUser(user); 
        
        // ၅။ UserProfile table ထဲသို့ ကျန်ရှိသော ဒေတာအားလုံး သိမ်းဆည်းမည်
        userDao.saveProfile(profile);
        
        return true;
    }

    /**
     * အသုံးပြုသူ၏ Email နှင့် Password ကို ကိုက်ညီမှု ရှိမရှိ စစ်ဆေးခြင်း (Login Sytem)
     */
    @Transactional
    public User authenticateUser(String email, String plainPassword) {
        User user = userDao.getUserByEmail(email);
        
        // User ရှိပြီး Password ကော ကိုက်ညီမှုရှိပါက User Object အား ပြန်ပေးမည်
        if (user != null && BCrypt.checkpw(plainPassword, user.getPasswordHash())) {
            return user;
        }
        return null;
    }

    /**
     * လက်ရှိ Login ဝင်ထားသော User ID ကို အသုံးပြု၍ သက်ဆိုင်ရာ Profile ဒေတာအား ရှာဖွေဆွဲထုတ်ခြင်း
     */
    @Transactional
    public UserProfile getUserProfileByUserId(int userId) {
        // UserDao ထဲက ဒေတာလှမ်းထုတ်မယ့် မက်သတ်ကို ဆင့်ခေါ်လိုက်တာပါ
        return userDao.getUserProfileByUserId(userId);
    }
    @Transactional
    public void updateUserProfile(UserProfile profile) {
        // UserDao တွင်းရှိ Profile Update logic အား လှမ်းခေါ်ခြင်း ဖြစ်သည်
        userDao.updateProfile(profile);
    }
}