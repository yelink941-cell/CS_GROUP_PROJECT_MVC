package com.hibernate.dto;

import com.hibernate.entity.enums.MessageType;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class MessageResponse {

    private Long id;
    private Long conversationId;
    private Long senderId;
    private String senderDisplayName;
    private Long parentMessageId;
    private String parentMessagePreview;
    private String messageText;
    private MessageType messageType;
    private boolean edited;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<AttachmentResponse> attachments = new ArrayList<>();
    private List<Long> readByUserIds = new ArrayList<>();
    private int readCount;
    private List<MessageReactionDto> reactions = new ArrayList<>();

    public MessageResponse() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getConversationId() { return conversationId; }
    public void setConversationId(Long conversationId) { this.conversationId = conversationId; }

    public Long getSenderId() { return senderId; }
    public void setSenderId(Long senderId) { this.senderId = senderId; }

    public String getSenderDisplayName() { return senderDisplayName; }
    public void setSenderDisplayName(String senderDisplayName) { this.senderDisplayName = senderDisplayName; }

    public Long getParentMessageId() { return parentMessageId; }
    public void setParentMessageId(Long parentMessageId) { this.parentMessageId = parentMessageId; }

    public String getParentMessagePreview() { return parentMessagePreview; }
    public void setParentMessagePreview(String parentMessagePreview) { this.parentMessagePreview = parentMessagePreview; }

    public String getMessageText() { return messageText; }
    public void setMessageText(String messageText) { this.messageText = messageText; }

    public MessageType getMessageType() { return messageType; }
    public void setMessageType(MessageType messageType) { this.messageType = messageType; }

    public boolean isEdited() { return edited; }
    public void setEdited(boolean edited) { this.edited = edited; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public List<AttachmentResponse> getAttachments() { return attachments; }
    public void setAttachments(List<AttachmentResponse> attachments) { this.attachments = attachments; }

    public List<Long> getReadByUserIds() { return readByUserIds; }
    public void setReadByUserIds(List<Long> readByUserIds) { this.readByUserIds = readByUserIds; }

    public int getReadCount() { return readCount; }
    public void setReadCount(int readCount) { this.readCount = readCount; }

    public List<MessageReactionDto> getReactions() { return reactions; }
    public void setReactions(List<MessageReactionDto> reactions) { this.reactions = reactions; }
}
