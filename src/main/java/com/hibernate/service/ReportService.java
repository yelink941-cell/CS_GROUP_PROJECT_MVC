package com.hibernate.service;

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
    
    List<PostReport> getAllPendingPostReports();
    List<CommentReport> getAllPendingCommentReports();
}
