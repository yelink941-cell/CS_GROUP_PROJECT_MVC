package com.hibernate.entity;

import java.time.LocalDateTime;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

@Getter
@Setter
@Entity
@Table(name = "admin_post_audit_logs")
public class AdminPostAuditLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "admin_id")
    private Long adminId;

    @Column(name = "admin_name", nullable = false, length = 100)
    private String adminName;

    @Column(nullable = false, length = 50)
    private String action;

    @Column(name = "post_id")
    private Integer postId;

    @Column(name = "post_title", nullable = false, length = 255)
    private String postTitle;

    @Column(columnDefinition = "TEXT")
    private String reason;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
