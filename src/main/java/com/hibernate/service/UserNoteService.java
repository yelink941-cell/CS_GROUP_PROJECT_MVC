package com.hibernate.service;

import com.hibernate.entity.UserNote;
import java.util.List;

public interface UserNoteService {
    List<UserNote> getNotesByUser(Long userId);
    UserNote getNoteById(Integer id, Long userId);
    void saveNote(UserNote note, Long userId);
    void deleteNote(Integer id, Long userId);

    List<UserNote> getAdminNotesForUser(Long userId);
    void saveAdminNote(Long adminId, Long targetUserId, String title, String content);
    void editAdminNote(Long adminId, Integer noteId, String title, String content, boolean isSuperAdmin);
    void deleteAdminNote(Long adminId, Integer noteId, boolean isSuperAdmin);
}

