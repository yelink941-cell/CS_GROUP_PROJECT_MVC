package com.hibernate.entity;

import javax.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Entity
@Table(name = "message_seen_statuses",
       uniqueConstraints = @UniqueConstraint(name = "uq_msg_user", columnNames = {"message_id", "user_id"}),
       indexes = @Index(name = "idx_seen_statuses_user", columnList = "user_id"))
@Getter
@Setter
public class MessageSeenStatus {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "message_id", nullable = false)
    private Message message;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "read_at", nullable = false, columnDefinition = "DATETIME(6)")
    private LocalDateTime readAt = LocalDateTime.now();
}
