package com.hibernate.service;

import com.hibernate.entity.Announcement;
import java.util.List;

public interface AnnouncementService {
    Announcement createAndBroadcastAnnouncement(Long adminUserId, String title, String type, String content, String eventDateStr, String actionUrl);
    List<Announcement> getAllAnnouncements();
    void deleteAnnouncement(Integer id);
}
