package com.hibernate.dto;

import com.hibernate.entity.enums.MessageType;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class MessageResponse {

    private Long id;
    private Long senderId;
    private String messageText;
    private MessageType messageType;
    private LocalDateTime createdAt;
    private List<AttachmentResponse> attachments = new ArrayList<>();

    public MessageResponse() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getSenderId() { return senderId; }
    public void setSenderId(Long senderId) { this.senderId = senderId; }

    public String getMessageText() { return messageText; }
    public void setMessageText(String messageText) { this.messageText = messageText; }

    public MessageType getMessageType() { return messageType; }
    public void setMessageType(MessageType messageType) { this.messageType = messageType; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public List<AttachmentResponse> getAttachments() { return attachments; }
    public void setAttachments(List<AttachmentResponse> attachments) { this.attachments = attachments; }
}
