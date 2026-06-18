package com.hibernate.entity;

import javax.persistence.*;

import com.hibernate.entity.enums.MessageType;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "messages", indexes = {
    @Index(name = "idx_messages_conversation", columnList = "conversation_id, created_at DESC")
})
@Getter
@Setter
public class Message {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "conversation_id", nullable = false)
    private Conversation conversation;

    @Column(name = "sender_id", nullable = false)
    private Long senderId;

    @Column(name = "message_text", columnDefinition = "TEXT")
    private String messageText;

    @Enumerated(EnumType.STRING)
    @Column(name = "message_type", length = 50, nullable = false)
    private MessageType messageType = MessageType.TEXT;

    @Column(name = "created_at", updatable = false, nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @OneToMany(mappedBy = "message", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<MessageAttachment> attachments = new ArrayList<>();

    @OneToMany(mappedBy = "message", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<MessageRead> reads = new ArrayList<>();
}