package com.hibernate.service;

import com.hibernate.entity.*;
import com.hibernate.entity.enums.ReportReason;
import com.hibernate.entity.enums.ReportStatus;
import com.hibernate.repository.*;
import lombok.RequiredArgsConstructor;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ReportServiceImpl implements ReportService {

    private final SessionFactory sessionFactory;
    private final PostReportRepository postReportRepository;
    private final CommentReportRepository commentReportRepository;
    private final ModerationService moderationService;

    private User getUser(Long id) {
        return sessionFactory.getCurrentSession().get(User.class, id);
    }

    private Post getPost(Integer id) {
        return sessionFactory.getCurrentSession().get(Post.class, id);
    }

    private Comment getComment(Integer id) {
        return sessionFactory.getCurrentSession().get(Comment.class, id);
    }

    @Override
    @Transactional
    public void reportPost(Long reporterId, Integer postId, String reasonStr, String description) {
        User reporter = getUser(reporterId);
        if (reporter == null) {
            throw new SecurityException("Login required.");
        }

        Post post = getPost(postId);
        if (post == null) {
            throw new IllegalArgumentException("Post not found.");
        }

        // Ownership Check: Prevent user from reporting their own content
        if (post.getAuthor().getId().equals(reporterId)) {
            throw new IllegalArgumentException("You cannot report your own post.");
        }

        // Duplicate Check (Anti-Spam): Does a pending report already exist?
        PostReport existing = postReportRepository.findPendingByPostAndReporter(postId, reporterId);
        if (existing != null) {
            throw new IllegalStateException("You have already reported this.");
        }

        // Creation
        PostReport report = new PostReport();
        report.setPost(post);
        report.setReporter(reporter);
        
        ReportReason reason = ReportReason.TEXT;
        try {
            reason = ReportReason.valueOf(reasonStr.toUpperCase());
        } catch (Exception e) {
            // default to TEXT
        }
        report.setReason(reason);
        report.setDescription(description);
        report.setStatus(ReportStatus.PENDING);

        postReportRepository.save(report);
    }

    @Override
    @Transactional
    public void reportComment(Long reporterId, Integer commentId, String reasonStr, String description) {
        User reporter = getUser(reporterId);
        if (reporter == null) {
            throw new SecurityException("Login required.");
        }

        Comment comment = getComment(commentId);
        if (comment == null) {
            throw new IllegalArgumentException("Comment not found.");
        }

        // Ownership Check: Prevent user from reporting their own content
        if (comment.getUser().getId().equals(reporterId)) {
            throw new IllegalArgumentException("You cannot report your own comment.");
        }

        // Duplicate Check (Anti-Spam): Does a pending report already exist?
        CommentReport existing = commentReportRepository.findPendingByCommentAndReporter(commentId, reporterId);
        if (existing != null) {
            throw new IllegalStateException("You have already reported this.");
        }

        // Creation
        CommentReport report = new CommentReport();
        report.setComment(comment);
        report.setReporter(reporter);
        
        ReportReason reason = ReportReason.TEXT;
        try {
            reason = ReportReason.valueOf(reasonStr.toUpperCase());
        } catch (Exception e) {
            // default to TEXT
        }
        report.setReason(reason);
        report.setDescription(description);
        report.setStatus(ReportStatus.PENDING);

        commentReportRepository.save(report);
    }

    @Override
    @Transactional
    public void dismissPostReport(Long adminId, Integer reportId) {
        PostReport report = postReportRepository.findById(reportId);
        if (report != null) {
            report.setStatus(ReportStatus.DISMISSED);
            postReportRepository.save(report);
        }
    }

    @Override
    @Transactional
    public void dismissCommentReport(Long adminId, Integer reportId) {
        CommentReport report = commentReportRepository.findById(reportId);
        if (report != null) {
            report.setStatus(ReportStatus.DISMISSED);
            commentReportRepository.save(report);
        }
    }

    @Override
    @Transactional
    public void resolvePostReport(Long adminId, Integer reportId, String reason) {
        PostReport report = postReportRepository.findById(reportId);
        if (report != null) {
            report.setStatus(ReportStatus.RESOLVED);
            postReportRepository.save(report);

            Post post = report.getPost();
            if (post != null) {
                moderationService.softDeletePost(adminId, post.getId(),
                        "Resolved report " + reportId + ": " + reason);
            }
        }
    }

    @Override
    @Transactional
    public void resolveCommentReport(Long adminId, Integer reportId, String reason) {
        CommentReport report = commentReportRepository.findById(reportId);
        if (report != null) {
            report.setStatus(ReportStatus.RESOLVED);
            commentReportRepository.save(report);

            Comment comment = report.getComment();
            if (comment != null) {
                // Soft delete comment
                moderationService.softDeleteComment(adminId, comment.getId(), "Resolved report " + reportId + ": " + reason);

                // Ban author when allowed (skip admins unless super admin is resolving)
                User author = comment.getUser();
                User admin = getUser(adminId);
                if (author != null && admin != null && moderationService.canBanUser(admin, author)) {
                    moderationService.banUser(adminId, author.getId(),
                            "Banned due to resolved comment report " + reportId + ": " + reason);
                }
            }
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<PostReport> getAllPendingPostReports() {
        return postReportRepository.findAllPending();
    }

    @Override
    @Transactional(readOnly = true)
    public List<CommentReport> getAllPendingCommentReports() {
        return commentReportRepository.findAllPending();
    }

    @Override
    @Transactional(readOnly = true)
    public List<PostReport> getAllPostReportHistory() {
        return postReportRepository.findAllHistory();
    }

    @Override
    @Transactional(readOnly = true)
    public List<CommentReport> getAllCommentReportHistory() {
        return commentReportRepository.findAllHistory();
    }
}
