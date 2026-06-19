package com.hibernate.dto;

public class MessageRequest {
    private Long conversationId;
    private String text;

    // Default Constructor (Jackson အတွက် မဖြစ်မနေလိုအပ်ပါသည်)
    public MessageRequest() {}

    // Getters and Setters
    public Long getConversationId() { return conversationId; }
    public void setConversationId(Long conversationId) { this.conversationId = conversationId; }
    public String getText() { return text; }
    public void setText(String text) { this.text = text; }
}