package com.hibernate.dto;

public class MarkReadRequest {
    private Long conversationId;
    private Long upToMessageId;

    public MarkReadRequest() {}

    public Long getConversationId() { return conversationId; }
    public void setConversationId(Long conversationId) { this.conversationId = conversationId; }

    public Long getUpToMessageId() { return upToMessageId; }
    public void setUpToMessageId(Long upToMessageId) { this.upToMessageId = upToMessageId; }
}
