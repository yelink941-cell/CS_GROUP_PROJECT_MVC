package com.hibernate.entity;

import java.time.LocalDateTime;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Index;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

@Getter
@Setter
@Entity
@Table(
        name = "post_views",
        indexes = {
            @Index(name = "idx_post_views_post_id", columnList = "post_id"),
            @Index(name = "idx_post_views_viewed_at", columnList = "viewed_at"),
            @Index(
                    name = "idx_post_views_post_user_time",
                    columnList = "post_id,user_id,viewed_at"),
            @Index(
                    name = "idx_post_views_post_guest_time",
                    columnList = "post_id,guest_token,viewed_at")
        })
public class PostView {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "post_id", nullable = false)
    private Post post;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = true)
    private User viewer;

    @Column(name = "guest_token", length = 255)
    private String guestToken;

    @Column(name = "viewer_name", length = 150)
    private String viewerName;

    @Column(name = "ip_address", length = 45)
    private String ipAddress;

    @Column(name = "user_agent", length = 500)
    private String userAgent;

    @CreationTimestamp
    @Column(name = "viewed_at", nullable = false, updatable = false)
    private LocalDateTime viewedAt;
}
