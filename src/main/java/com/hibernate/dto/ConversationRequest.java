package com.hibernate.dto;

import java.util.List;

public class ConversationRequest {
    private String title;
    private boolean isGroup;
    private List<Long> userIds;

    // Default Constructor
    public ConversationRequest() {}

    // Getters and Setters
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public boolean isGroup() { return isGroup; }
    public void setGroup(boolean isGroup) { this.isGroup = isGroup; }
    public List<Long> getUserIds() { return userIds; }
    public void setUserIds(List<Long> userIds) { this.userIds = userIds; }
}