package com.hibernate.repository;
import com.hibernate.entity.User;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository; 
import java.util.Optional;
@Repository
public class UserRepositoryImpl implements UserRepository {
	@Autowired
    private SessionFactory sessionFactory;

    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }
    @Override
    public void saveUser(User user) {
        getSession().persist(user); 
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
    public User getUserById(Integer id) {
        return getSession().get(User.class, id);
    }

    @Override
    public User getUserByEmail(String email) {
        return getSession()
                .createQuery("from User u where u.email = :email", User.class)
                .setParameter("email", email)
                .uniqueResult();
    }

}
