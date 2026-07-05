package com.hibernate.repository;

import com.hibernate.entity.UserPreference;
import java.util.Optional;

public interface UserPreferenceRepository {
    UserPreference save(UserPreference preference);
    UserPreference update(UserPreference preference);
    Optional<UserPreference> findByUserId(Long userId);
}