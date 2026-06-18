package com.hibernate.repository;
import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
@Repository
@Transactional
public class UserRepositoryImpl implements UserRepository {
	@Autowired
    private SessionFactory sessionFactory;

	private Session getSession() {
        return sessionFactory.getCurrentSession();
    }
   
    @Override
    public User save(User user) {
        if (user.getId() == null) {
            getCurrentSession().save(user); // Hi Data အသစ်သွင်းခြင်း
            return user;
        } else {
            getCurrentSession().update(user); // Update လုပ်ခြင်း
            return user;
        }
    }

    @Override
    public boolean isEmailExists(String email) {
        Long count = getSession()
                .createQuery("select count(u) from User u where u.email = :email", Long.class)
                .setParameter("email", email)
                .uniqueResult();
        return count > 0;
    }
    @Override
    public User getUserByEmail(String email) {
        return getSession()
                .createQuery("from User u where u.email = :email", User.class)
                .setParameter("email", email)
                .uniqueResult();
    }

    @Override
    public UserProfile getUserProfileByUserId(int userId) {
        return getSession()
               .createQuery("FROM UserProfile up WHERE up.user.id = :userId", UserProfile.class)
               .setParameter("userId", userId)
               .uniqueResult();
    }

    @Override
    public void updateProfile(UserProfile profile) {
        getSession().merge(profile);
    }

    
}