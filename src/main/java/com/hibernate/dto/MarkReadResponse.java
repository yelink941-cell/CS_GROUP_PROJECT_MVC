package com.hibernate.dto;

import java.util.List;

public class MarkReadResponse {
    private Long conversationId;
    private Long upToMessageId;
    private int markedCount;
    private List<Long> readByUserIds;

    public MarkReadResponse() {}

    public MarkReadResponse(Long conversationId, Long upToMessageId, int markedCount, List<Long> readByUserIds) {
        this.conversationId = conversationId;
        this.upToMessageId = upToMessageId;
        this.markedCount = markedCount;
        this.readByUserIds = readByUserIds;
    }

    public Long getConversationId() { return conversationId; }
    public void setConversationId(Long conversationId) { this.conversationId = conversationId; }

    public Long getUpToMessageId() { return upToMessageId; }
    public void setUpToMessageId(Long upToMessageId) { this.upToMessageId = upToMessageId; }

    public int getMarkedCount() { return markedCount; }
    public void setMarkedCount(int markedCount) { this.markedCount = markedCount; }

    public List<Long> getReadByUserIds() { return readByUserIds; }
    public void setReadByUserIds(List<Long> readByUserIds) { this.readByUserIds = readByUserIds; }
}
