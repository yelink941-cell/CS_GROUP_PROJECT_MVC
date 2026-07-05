package com.hibernate.dto;

import com.hibernate.entity.Comment;
import com.hibernate.entity.CommentReport;
import com.hibernate.entity.enums.ReportReason;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
public class GroupedCommentReportDto {

    private Comment comment;
    private int reportCount;
    private LocalDateTime latestReportedAt;
    private List<CommentReport> reports = new ArrayList<>();
    private Map<ReportReason, Integer> reasonCounts = new LinkedHashMap<>();

    public GroupedCommentReportDto(Comment comment) {
        this.comment = comment;
    }

    public void addReport(CommentReport report) {
        this.reports.add(report);
        this.reportCount = this.reports.size();

        if (report.getCreatedAt() != null) {
            if (this.latestReportedAt == null || report.getCreatedAt().isAfter(this.latestReportedAt)) {
                this.latestReportedAt = report.getCreatedAt();
            }
        }

        ReportReason reason = report.getReason();
        if (reason != null) {
            this.reasonCounts.put(reason, this.reasonCounts.getOrDefault(reason, 0) + 1);
        }
    }
}
