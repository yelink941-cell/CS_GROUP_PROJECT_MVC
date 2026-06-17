package com.hibernate.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import com.hibernate.entity.enums.ModerationAction;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "moderation_logs")
public class ModerationLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "post_id", nullable = false)
    private Integer postId;

    @Column(name = "admin_id", nullable = false)
    private Integer adminId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private ModerationAction action;

    @Column(columnDefinition = "TEXT")
    private String reason;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}