package com.hibernate.service;

import com.hibernate.entity.User;
import com.hibernate.entity.UserNote;
import com.hibernate.repository.UserNoteRepository;
import lombok.RequiredArgsConstructor;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserNoteServiceImpl implements UserNoteService {

    private final UserNoteRepository userNoteRepository;
    private final SessionFactory sessionFactory;
    private final NotificationService notificationService;

    @Override
    @Transactional(readOnly = true)
    public List<UserNote> getNotesByUser(Long userId) {
        return userNoteRepository.findByUserId(userId);
    }

    @Override
    @Transactional(readOnly = true)
    public UserNote getNoteById(Integer id, Long userId) {
        UserNote note = userNoteRepository.findById(id);
        // Ownership check — သူတစ်ပါးရဲ့ note ကို ဖတ်လို့မရ
        if (note == null || !note.getUser().getId().equals(userId)) {
            return null;
        }
        return note;
    }

    @Override
    @Transactional
    public void saveNote(UserNote note, Long userId) {
        if (note.getId() != null) {
            updateNote(note, userId);
            return;
        }
        if (note.getUser() == null) {
            User user = sessionFactory.getCurrentSession().get(User.class, userId);
            note.setUser(user);
        }
        // Always enforce private
        note.setIsPrivate(true);
        userNoteRepository.save(note);
    }

    @Override
    @Transactional
    public void updateNote(UserNote note, Long userId) {
        if (note == null || note.getId() == null) {
            throw new IllegalArgumentException("Note ID must not be null for update.");
        }
        UserNote existing = userNoteRepository.findById(note.getId());
        if (existing == null || existing.getUser() == null || !existing.getUser().getId().equals(userId)) {
            throw new SecurityException("Unauthorized: You do not own this note.");
        }
        existing.setTitle(note.getTitle());
        existing.setContent(note.getContent());
        existing.setIsPrivate(true);
        userNoteRepository.update(existing);
    }

    @Override
    @Transactional
    public void deleteNote(Integer id, Long userId) {
        UserNote note = userNoteRepository.findById(id);
        // Ownership check — သူတစ်ပါးရဲ့ note ကို ဖျက်လို့မရ
        if (note != null && note.getUser() != null && note.getUser().getId().equals(userId)) {
            userNoteRepository.delete(note);
        } else if (note != null) {
            throw new SecurityException("Unauthorized: You do not own this note.");
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<UserNote> getAdminNotesForUser(Long userId) {
        return userNoteRepository.findAdminNotesByUserId(userId);
    }

    @Override
    @Transactional
    public void saveAdminNote(Long adminId, Long targetUserId, String title, String content) {
        User admin = sessionFactory.getCurrentSession().get(User.class, adminId);
        User target = sessionFactory.getCurrentSession().get(User.class, targetUserId);
        if (admin == null || target == null) {
            throw new IllegalArgumentException("Admin or target user not found.");
        }

        UserNote note = new UserNote();
        note.setAdmin(admin);
        note.setUser(target);
        note.setTitle(title);
        note.setContent(content);
        note.setIsPrivate(true);
        userNoteRepository.save(note);

        notificationService.createNotification(
                targetUserId,
                "ADMIN_NOTE",
                "Message from Admin",
                title + ": " + content,
                "USER_NOTE",
                note.getId()
        );
    }

    @Override
    @Transactional
    public void editAdminNote(Long adminId, Integer noteId, String title, String content, boolean isSuperAdmin) {
        UserNote note = userNoteRepository.findById(noteId);
        if (note == null) {
            throw new IllegalArgumentException("Note not found.");
        }

        // Ownership Rule: admin can only edit their own note unless Super Admin
        if (!isSuperAdmin && (note.getAdmin() == null || !note.getAdmin().getId().equals(adminId))) {
            throw new SecurityException("Unauthorized: You can only edit your own notes.");
        }

        note.setTitle(title);
        note.setContent(content);
        userNoteRepository.save(note);
    }

    @Override
    @Transactional
    public void deleteAdminNote(Long adminId, Integer noteId, boolean isSuperAdmin) {
        UserNote note = userNoteRepository.findById(noteId);
        if (note == null) {
            throw new IllegalArgumentException("Note not found.");
        }

        // Ownership Rule: admin can only delete their own note unless Super Admin
        if (!isSuperAdmin && (note.getAdmin() == null || !note.getAdmin().getId().equals(adminId))) {
            throw new SecurityException("Unauthorized: You can only delete your own notes.");
        }

        userNoteRepository.delete(note);
    }
}

