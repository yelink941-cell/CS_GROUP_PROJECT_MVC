package com.hibernate.dto;

import java.util.ArrayList;
import java.util.List;

public class MessageReactionDto {
    private String emoji;
    private int count;
    private List<Long> userIds = new ArrayList<>();

    public MessageReactionDto() {}

    public MessageReactionDto(String emoji, int count, List<Long> userIds) {
        this.emoji = emoji;
        this.count = count;
        this.userIds = userIds;
    }

    public String getEmoji() { return emoji; }
    public void setEmoji(String emoji) { this.emoji = emoji; }

    public int getCount() { return count; }
    public void setCount(int count) { this.count = count; }

    public List<Long> getUserIds() { return userIds; }
    public void setUserIds(List<Long> userIds) { this.userIds = userIds; }
}
