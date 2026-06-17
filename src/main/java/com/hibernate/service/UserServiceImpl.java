package com.hibernate.service;

<<<<<<< Updated upstream
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
=======
import com.hibernate.dao.UserDao;
import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.mindrot.jbcrypt.BCrypt;
import java.util.List; // List အတွက် လိုအပ်သည်

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    @Override
    @Transactional
    public boolean registerNewUser(User user, UserProfile profile) {
        if (userDao.isEmailExists(user.getEmail())) {
            return false;
        }
        String hashedPassword = BCrypt.hashpw(user.getPasswordHash(), BCrypt.gensalt());
        user.setPasswordHash(hashedPassword);
        userDao.saveUser(user);
        profile.setUser(user);
        userDao.saveProfile(profile);
        return true;
>>>>>>> Stashed changes
    }

    @Override
    @Transactional
<<<<<<< Updated upstream
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
=======
    public User authenticateUser(String email, String plainPassword) {
        User user = userDao.getUserByEmail(email);
        if (user != null && BCrypt.checkpw(plainPassword, user.getPasswordHash())) {
            return user;
        }
        return null;
    }

    @Override
    @Transactional
    public UserProfile getUserProfileByUserId(int userId) {
        return userDao.getUserProfileByUserId(userId);
    }

    @Override
    @Transactional
    public void updateUserProfile(UserProfile profile) {
        userDao.updateProfile(profile);
    }

    // User List ထုတ်ရန် Method အသစ်
    @Override
    @Transactional
    public List<User> getAllUsers() {
        return userDao.getAllUsers();
    }
    
    @Override
    @Transactional
    public void deleteUser(int id) {
        userDao.deleteUser(id);
    }

    @Override
    @Transactional
    public void banUser(int id) {
        userDao.banUser(id);
>>>>>>> Stashed changes
    }
}