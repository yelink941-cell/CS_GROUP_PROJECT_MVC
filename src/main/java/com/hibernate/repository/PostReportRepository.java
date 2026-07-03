package com.hibernate.repository;

import com.hibernate.entity.PostReport;
import java.util.List;

public interface PostReportRepository {
    void save(PostReport report);
    PostReport findPendingByPostAndReporter(Integer postId, Long reporterId);
    PostReport findById(Integer id);
    List<PostReport> findAllPending();
}
