package com.hibernate.dto;

import java.time.LocalDateTime;

public class ChatInboxItem {

    private Long conversationId;
    private String displayName;
    private String displayRole;
    private boolean group;
    private String lastMessagePreview;
    private LocalDateTime lastMessageAt;

    public Long getConversationId() { return conversationId; }
    public void setConversationId(Long conversationId) { this.conversationId = conversationId; }

    public String getDisplayName() { return displayName; }
    public void setDisplayName(String displayName) { this.displayName = displayName; }

    public String getDisplayRole() { return displayRole; }
    public void setDisplayRole(String displayRole) { this.displayRole = displayRole; }

    public boolean isGroup() { return group; }
    public void setGroup(boolean group) { this.group = group; }

    public String getLastMessagePreview() { return lastMessagePreview; }
    public void setLastMessagePreview(String lastMessagePreview) { this.lastMessagePreview = lastMessagePreview; }

    public LocalDateTime getLastMessageAt() { return lastMessageAt; }
    public void setLastMessageAt(LocalDateTime lastMessageAt) { this.lastMessageAt = lastMessageAt; }
}
