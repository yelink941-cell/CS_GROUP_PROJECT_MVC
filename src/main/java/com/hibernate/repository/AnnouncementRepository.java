package com.hibernate.repository;

import com.hibernate.entity.Announcement;
import java.util.List;
import java.util.Optional;

public interface AnnouncementRepository {
    Announcement save(Announcement announcement);
    Optional<Announcement> findById(Integer id);
    List<Announcement> findAll();
    void delete(Integer id);
}
