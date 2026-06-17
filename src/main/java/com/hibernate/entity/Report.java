package com.hibernate.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import com.hibernate.entity.enums.ReportStatus;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "reports")
public class Report {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "post_id", nullable = false)
    private Integer postId;

    @Column(name = "user_id", nullable = false)
    private Integer userId;

    @Column(length = 255)
    private String reason;

    @Column(columnDefinition = "TEXT")
    private String detail;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private ReportStatus status = ReportStatus.PENDING;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}