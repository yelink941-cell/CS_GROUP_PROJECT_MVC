package com.hibernate.dto;

public class ChatRoomView {

    private Long conversationId;
    private String title;
    private Long partnerUserId;
    private String partnerRole;
    private boolean group;
    private boolean canModerate;

    public Long getConversationId() { return conversationId; }
    public void setConversationId(Long conversationId) { this.conversationId = conversationId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public Long getPartnerUserId() { return partnerUserId; }
    public void setPartnerUserId(Long partnerUserId) { this.partnerUserId = partnerUserId; }

    public String getPartnerRole() { return partnerRole; }
    public void setPartnerRole(String partnerRole) { this.partnerRole = partnerRole; }

    public boolean isGroup() { return group; }
    public void setGroup(boolean group) { this.group = group; }

    public boolean isCanModerate() { return canModerate; }
    public void setCanModerate(boolean canModerate) { this.canModerate = canModerate; }
}
