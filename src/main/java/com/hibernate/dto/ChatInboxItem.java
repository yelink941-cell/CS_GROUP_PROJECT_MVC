package com.hibernate.dto;

import java.time.LocalDateTime;

public class ChatInboxItem {

    private Long conversationId;
    private String displayName;
    private String displayRole;
    private boolean group;
    private boolean blockedByMe;
    private Long partnerUserId;
    private String lastMessagePreview;
    private LocalDateTime lastMessageAt;
    private boolean partnerOnline;
    private String partnerLastSeenFormatted;

    public Long getConversationId() { return conversationId; }
    public void setConversationId(Long conversationId) { this.conversationId = conversationId; }

    public String getDisplayName() { return displayName; }
    public void setDisplayName(String displayName) { this.displayName = displayName; }

    public String getDisplayRole() { return displayRole; }
    public void setDisplayRole(String displayRole) { this.displayRole = displayRole; }

    public boolean isGroup() { return group; }
    public void setGroup(boolean group) { this.group = group; }

    public boolean isBlockedByMe() { return blockedByMe; }
    public void setBlockedByMe(boolean blockedByMe) { this.blockedByMe = blockedByMe; }

    public Long getPartnerUserId() { return partnerUserId; }
    public void setPartnerUserId(Long partnerUserId) { this.partnerUserId = partnerUserId; }

    public String getLastMessagePreview() { return lastMessagePreview; }
    public void setLastMessagePreview(String lastMessagePreview) { this.lastMessagePreview = lastMessagePreview; }

    public LocalDateTime getLastMessageAt() { return lastMessageAt; }
    public void setLastMessageAt(LocalDateTime lastMessageAt) { this.lastMessageAt = lastMessageAt; }

    public boolean isPartnerOnline() { return partnerOnline; }
    public void setPartnerOnline(boolean partnerOnline) { this.partnerOnline = partnerOnline; }

    public String getPartnerLastSeenFormatted() { return partnerLastSeenFormatted; }
    public void setPartnerLastSeenFormatted(String partnerLastSeenFormatted) { this.partnerLastSeenFormatted = partnerLastSeenFormatted; }
}

