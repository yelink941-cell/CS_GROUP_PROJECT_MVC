package com.hibernate.repository;

import com.hibernate.entity.UserPreference;
import lombok.RequiredArgsConstructor;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class UserPreferenceRepositoryImpl implements UserPreferenceRepository {

    private final SessionFactory sessionFactory;

    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public UserPreference save(UserPreference preference) {
        getCurrentSession().save(preference);
        return preference;
    }

    @Override
    public UserPreference update(UserPreference preference) {
        getCurrentSession().update(preference);
        return preference;
    }

    @Override
    public Optional<UserPreference> findByUserId(Long userId) {
        UserPreference preference = getCurrentSession()
                .createQuery("SELECT up FROM UserPreference up WHERE up.user.id = :userId", UserPreference.class)
                .setParameter("userId", userId)
                .uniqueResult();
        return Optional.ofNullable(preference);
    }
}