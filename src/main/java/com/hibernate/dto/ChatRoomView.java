package com.hibernate.dto;

public class ChatRoomView {

    private Long conversationId;
    private String title;
    private String partnerRole;
    private boolean group;

    public Long getConversationId() { return conversationId; }
    public void setConversationId(Long conversationId) { this.conversationId = conversationId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getPartnerRole() { return partnerRole; }
    public void setPartnerRole(String partnerRole) { this.partnerRole = partnerRole; }

    public boolean isGroup() { return group; }
    public void setGroup(boolean group) { this.group = group; }
}
