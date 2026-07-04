package com.hibernate.dto;

public class EditMessageRequest {
    private String text;

    public EditMessageRequest() {}

    public String getText() { return text; }
    public void setText(String text) { this.text = text; }
}
