package com.hibernate.dto;

import com.hibernate.entity.enums.ReportReason;

public class MessageReportRequest {
    private ReportReason reason;
    private String description;

    public MessageReportRequest() {}

    public ReportReason getReason() { return reason; }
    public void setReason(ReportReason reason) { this.reason = reason; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
