package com.hibernate.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import com.hibernate.entity.enums.ProfileVisibility;
import com.hibernate.entity.enums.Theme;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "user_preferences")
public class UserPreference {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private Theme theme = Theme.SYSTEM;

    @Column(name = "language_code", length = 10)
    private String languageCode = "en";

    @Column(name = "email_notifications")
    private Boolean emailNotifications = true;

    @Column(name = "push_notifications")
    private Boolean pushNotifications = true;

    @Column(name = "allow_messages")
    private Boolean allowMessages = true;

    @Enumerated(EnumType.STRING)
    @Column(name = "profile_visibility", length = 20)
    private ProfileVisibility profileVisibility = ProfileVisibility.PUBLIC;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}