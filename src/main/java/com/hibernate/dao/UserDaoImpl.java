package com.hibernate.dao;

import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import java.util.List;
import org.hibernate.Session;

@Repository
public class UserDaoImpl implements UserDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void saveUser(User user) {
        sessionFactory.getCurrentSession().persist(user); 
    }

    @Override
    public void saveProfile(UserProfile profile) {
        sessionFactory.getCurrentSession().persist(profile);
    }

    @Override
    public boolean isEmailExists(String email) {
        Long count = sessionFactory.getCurrentSession()
                .createQuery("select count(u) from User u where u.email = :email", Long.class)
                .setParameter("email", email)
                .uniqueResult();
        return count != null && count > 0;
    }
    
    @Override
    public User getUserByEmail(String email) {
        return sessionFactory.getCurrentSession()
                .createQuery("from User u where u.email = :email", User.class)
                .setParameter("email", email)
                .uniqueResult();
    }

    @Override
    public UserProfile getUserProfileByUserId(int userId) {
        return sessionFactory.getCurrentSession()
               .createQuery("FROM UserProfile up WHERE up.user.id = :userId", UserProfile.class)
               .setParameter("userId", userId)
               .uniqueResult();
    }
    
    @Override
    public void updateProfile(UserProfile profile) {
        sessionFactory.getCurrentSession().merge(profile);
    }

 // User List ထုတ်ပေးမည့် Method အသစ် (Soft Delete အတွက် ပြင်ဆင်ထားသည်)
    @Override
    public List<User> getAllUsers() {
        return sessionFactory.getCurrentSession()
                .createQuery("from User u where u.status != 'DELETED'", User.class)
                .getResultList();
    }
    
    @Override
    public void deleteUser(int id) {
        Session session = sessionFactory.getCurrentSession();
        User user = session.get(User.class, id);
        if(user != null) {
            user.setStatus("DELETED"); // ဒါကို Soft Delete လို့ခေါ်ပါတယ်
            session.update(user);
        }
    }           
    
    @Override
    public void banUser(int id) {
        Session session = sessionFactory.getCurrentSession();
        User user = session.get(User.class, id);
        if(user != null) {
            user.setRole("BANNED"); // Role ကို BANNED လို့ ပြောင်းလိုက်တာပါ
            session.update(user);=[]
        }
    }
}