package com.hibernate.repository;

import com.hibernate.entity.CommentReport;
import java.util.List;

public interface CommentReportRepository {
    void save(CommentReport report);
    CommentReport findPendingByCommentAndReporter(Integer commentId, Long reporterId);
    CommentReport findById(Integer id);
    List<CommentReport> findAllPending();
}
