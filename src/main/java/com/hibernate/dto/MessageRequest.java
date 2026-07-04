package com.hibernate.dto;

public class MessageRequest {
    private Long conversationId;
    private String text;
    private Long parentMessageId;

    public MessageRequest() {}

    public Long getConversationId() { return conversationId; }
    public void setConversationId(Long conversationId) { this.conversationId = conversationId; }

    public String getText() { return text; }
    public void setText(String text) { this.text = text; }

    public Long getParentMessageId() { return parentMessageId; }
    public void setParentMessageId(Long parentMessageId) { this.parentMessageId = parentMessageId; }
}
