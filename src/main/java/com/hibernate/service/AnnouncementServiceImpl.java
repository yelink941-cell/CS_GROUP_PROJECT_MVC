package com.hibernate.service;

import com.hibernate.entity.Announcement;
import com.hibernate.entity.User;
import com.hibernate.repository.AnnouncementRepository;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AnnouncementServiceImpl implements AnnouncementService {

    private final AnnouncementRepository announcementRepository;
    private final NotificationService notificationService;
    private final SessionFactory sessionFactory;

    @Override
    @Transactional
    public Announcement createAndBroadcastAnnouncement(Long adminUserId, String title, String type, String content, String eventDateStr, String actionUrl) {
        User admin = sessionFactory.getCurrentSession().get(User.class, adminUserId);

        Announcement announcement = new Announcement();
        announcement.setTitle(title);
        announcement.setType(type != null && !type.isBlank() ? type.toUpperCase() : "EVENT");
        announcement.setContent(content);
        announcement.setActionUrl(actionUrl);
        announcement.setCreatedAdmin(admin);

        if (eventDateStr != null && !eventDateStr.isBlank()) {
            try {
                LocalDateTime parsedDate = LocalDateTime.parse(eventDateStr);
                announcement.setEventDate(parsedDate);
            } catch (Exception e) {
                try {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                    LocalDateTime parsedDate = LocalDateTime.parse(eventDateStr, formatter);
                    announcement.setEventDate(parsedDate);
                } catch (Exception ignored) {
                }
            }
        }

        Announcement saved = announcementRepository.save(announcement);

        // Broadcast notification to ALL registered users
        String notiType = saved.getType();
        String notiTitle = (saved.getType().equals("EVENT") ? "🎉 Event Announcement: " : "📢 Notice: ") + saved.getTitle();
        String notiMessage = saved.getContent();

        notificationService.broadcastNotification(notiType, notiTitle, notiMessage, "ANNOUNCEMENT", saved.getId());

        return saved;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Announcement> getAllAnnouncements() {
        return announcementRepository.findAll();
    }

    @Override
    @Transactional
    public void deleteAnnouncement(Integer id) {
        announcementRepository.delete(id);
    }
}
