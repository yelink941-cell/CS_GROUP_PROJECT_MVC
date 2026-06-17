package com.hibernate.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import com.hibernate.entity.enums.ExportFormat;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "post_downloads")
public class PostDownload {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user; // ON DELETE SET NULL ဖြစ်လို့ nullable ဖြစ်ပါတယ်

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "post_id", nullable = false)
    private Post post;

    @Enumerated(EnumType.STRING)
    @Column(name = "export_format", length = 20)
    private ExportFormat exportFormat = ExportFormat.PDF;

    @Column(name = "ip_address", length = 45)
    private String ipAddress;

    @CreationTimestamp
    @Column(name = "downloaded_at", updatable = false)
    private LocalDateTime downloadedAt;
}