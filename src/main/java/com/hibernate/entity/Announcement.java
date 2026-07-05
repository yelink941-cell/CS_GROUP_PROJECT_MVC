package com.hibernate.entity;

import java.time.LocalDateTime;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

@Getter
@Setter
@Entity
@Table(name = "announcements")
public class Announcement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 255)
    private String title;

    @Column(nullable = false, length = 50)
    private String type = "EVENT"; // EVENT, ANNOUNCEMENT, SYSTEM, MAINTENANCE

    @Column(columnDefinition = "TEXT", nullable = false)
    private String content;

    @Column(name = "event_date")
    private LocalDateTime eventDate;

    @Column(name = "action_url", length = 500)
    private String actionUrl;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_admin_id")
    private User createdAdmin;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
