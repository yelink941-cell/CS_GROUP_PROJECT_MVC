package com.hibernate.service;

import com.hibernate.dto.GroupedCommentReportDto;
import com.hibernate.dto.GroupedPostReportDto;
import com.hibernate.entity.CommentReport;
import com.hibernate.entity.PostReport;
import java.util.List;

public interface ReportService {
    void reportPost(Long reporterId, Integer postId, String reasonStr, String description);
    void reportComment(Long reporterId, Integer commentId, String reasonStr, String description);
    
    void dismissPostReport(Long adminId, Integer reportId);
    void dismissCommentReport(Long adminId, Integer reportId);
    
    void resolvePostReport(Long adminId, Integer reportId, String reason);
    void resolveCommentReport(Long adminId, Integer reportId, String reason);

    void dismissAllPostReportsByPostId(Long adminId, Integer postId);
    void resolveAllPostReportsByPostId(Long adminId, Integer postId, String reason);
    void resolveAllPostReportsByPostId(Long adminId, Integer postId, String reason, String duration, String banType);

    void dismissAllCommentReportsByCommentId(Long adminId, Integer commentId);
    void resolveAllCommentReportsByCommentId(Long adminId, Integer commentId, String reason);
    void resolveAllCommentReportsByCommentId(Long adminId, Integer commentId, String reason, String duration, String banType);

    List<PostReport> getAllPendingPostReports();
    List<CommentReport> getAllPendingCommentReports();

    List<GroupedPostReportDto> getGroupedPendingPostReports();
    List<GroupedCommentReportDto> getGroupedPendingCommentReports();

    List<PostReport> getAllPostReportHistory();
    List<CommentReport> getAllCommentReportHistory();
}
