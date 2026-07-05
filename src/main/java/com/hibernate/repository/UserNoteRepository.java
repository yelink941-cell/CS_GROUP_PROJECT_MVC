package com.hibernate.repository;

import com.hibernate.entity.UserNote;
import java.util.List;

public interface UserNoteRepository {
    List<UserNote> findByUserId(Long userId);
    List<UserNote> findAdminNotesByUserId(Long userId);
    UserNote findById(Integer id);
    void save(UserNote note);
    void update(UserNote note);
    void delete(UserNote note);
}

