package com.hibernate.dto;

public class ReactionRequest {
    private String emoji;

    public ReactionRequest() {}
    public ReactionRequest(String emoji) {
        this.emoji = emoji;
    }

    public String getEmoji() { return emoji; }
    public void setEmoji(String emoji) { this.emoji = emoji; }
}
