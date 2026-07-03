package com.hibernate.entity;

import javax.persistence.*;

import com.hibernate.entity.enums.MessageType;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.BatchSize;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "messages", indexes = {
    @Index(name = "idx_messages_conversation", columnList = "conversation_id, created_at DESC"),
    @Index(name = "idx_messages_parent", columnList = "parent_message_id")
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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_message_id")
    private Message parentMessage;

    @OneToMany(mappedBy = "parentMessage", fetch = FetchType.LAZY)
    private List<Message> replies = new ArrayList<>();

    @Column(name = "sender_id", nullable = false)
    private Long senderId;

    @Column(name = "message_text", columnDefinition = "TEXT")
    private String messageText;

    @Column(name = "is_edited", nullable = false)
    private boolean edited = false;

    @Enumerated(EnumType.STRING)
    @Column(name = "message_type", length = 50, nullable = false)
    private MessageType messageType = MessageType.TEXT;

    @Column(name = "created_at", updatable = false, nullable = false, columnDefinition = "DATETIME(6)")
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at", columnDefinition = "DATETIME(6)")
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at", columnDefinition = "DATETIME(6)")
    private LocalDateTime deletedAt;

    @BatchSize(size = 20)
    @OneToMany(mappedBy = "message", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<MessageAttachment> attachments = new ArrayList<>();

    @BatchSize(size = 20)
    @OneToMany(mappedBy = "message", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<MessageSeenStatus> seenStatuses = new ArrayList<>();
}
