package com.hibernate.entity;


import javax.persistence.*;

import com.hibernate.entity.enums.ParticipantRole;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Entity
@Table(name = "conversation_participants",
       uniqueConstraints = @UniqueConstraint(columnNames = {"conversation_id", "user_id"}))
@Getter
@Setter
public class ConversationParticipant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "conversation_id", nullable = false)
    private Conversation conversation;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Enumerated(EnumType.STRING)
    @Column(length = 50, nullable = false)
    private ParticipantRole role = ParticipantRole.MEMBER;
    
    @Column(name = "joined_at", updatable = false, nullable = false)
    private LocalDateTime joinedAt = LocalDateTime.now();

    @Column(name = "hidden_at", columnDefinition = "DATETIME(6)")
    private LocalDateTime hiddenAt;
}