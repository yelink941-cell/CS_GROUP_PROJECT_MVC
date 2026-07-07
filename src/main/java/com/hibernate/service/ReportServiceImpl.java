package com.hibernate.service;

import com.hibernate.entity.*;
import com.hibernate.entity.enums.ReportReason;
import com.hibernate.entity.enums.ReportStatus;
import com.hibernate.repository.*;
import lombok.RequiredArgsConstructor;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hibernate.dto.GroupedCommentReportDto;
import com.hibernate.dto.GroupedPostReportDto;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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

        // Auto-delete / hide content if reported by 10 or more users
        List<PostReport> pendingReports = postReportRepository.findPendingByPostId(postId);
        if (pendingReports != null && pendingReports.size() >= 10) {
            post.setStatus(com.hibernate.entity.enums.PostStatus.BANNED);
            post.setIsDeleted(true);
            post.setDeletedAt(java.time.LocalDateTime.now());
            post.setRemovalReason("Auto-deleted: Received " + pendingReports.size() + " user reports (Threshold >= 10).");
            sessionFactory.getCurrentSession().merge(post);
        }
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

        // Auto-delete / hide content if reported by 10 or more users
        List<CommentReport> pendingReports = commentReportRepository.findPendingByCommentId(commentId);
        if (pendingReports != null && pendingReports.size() >= 10) {
            comment.setIsDeleted(true);
            comment.setDeletedAt(java.time.LocalDateTime.now());
            comment.setReportReason("Auto-deleted: Received " + pendingReports.size() + " user reports (Threshold >= 10).");
            sessionFactory.getCurrentSession().merge(comment);
        }
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
                // Soft delete / ban ONLY the target post
                moderationService.softDeletePost(adminId, post.getId(),
                        "Resolved report " + reportId + ": " + reason);
                if (post.getAuthor() != null) {
                    moderationService.banUser(adminId, post.getAuthor().getId(), reason, "1_WEEK", "POST_ONLY");
                }
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
                // Soft delete / ban ONLY the target comment
                moderationService.softDeleteComment(adminId, comment.getId(), "Resolved report " + reportId + ": " + reason);
                if (comment.getUser() != null) {
                    moderationService.banUser(adminId, comment.getUser().getId(), reason, "1_WEEK", "COMMENT_ONLY");
                }
            }
        }
    }

    @Override
    @Transactional
    public void dismissAllPostReportsByPostId(Long adminId, Integer postId) {
        List<PostReport> pendingList = postReportRepository.findPendingByPostId(postId);
        for (PostReport report : pendingList) {
            report.setStatus(ReportStatus.DISMISSED);
            postReportRepository.save(report);
        }
    }

    @Override
    @Transactional
    public void resolveAllPostReportsByPostId(Long adminId, Integer postId, String reason) {
        resolveAllPostReportsByPostId(adminId, postId, reason, "1_WEEK", "POST_ONLY");
    }

    @Override
    @Transactional
    public void resolveAllPostReportsByPostId(Long adminId, Integer postId, String reason, String duration, String banType) {
        List<PostReport> pendingList = postReportRepository.findPendingByPostId(postId);
        if (pendingList.isEmpty()) {
            return;
        }
        for (PostReport report : pendingList) {
            report.setStatus(ReportStatus.RESOLVED);
            postReportRepository.save(report);
        }

        Post post = pendingList.get(0).getPost();
        if (post != null) {
            // Soft delete / ban target post
            moderationService.softDeletePost(adminId, post.getId(),
                    "Resolved all pending reports (" + pendingList.size() + "): " + reason);
            
            // Ban the post author
            if (post.getAuthor() != null) {
                moderationService.banUser(adminId, post.getAuthor().getId(), reason, duration, banType);
            }
        }
    }

    @Override
    @Transactional
    public void dismissAllCommentReportsByCommentId(Long adminId, Integer commentId) {
        List<CommentReport> pendingList = commentReportRepository.findPendingByCommentId(commentId);
        for (CommentReport report : pendingList) {
            report.setStatus(ReportStatus.DISMISSED);
            commentReportRepository.save(report);
        }
    }

    @Override
    @Transactional
    public void resolveAllCommentReportsByCommentId(Long adminId, Integer commentId, String reason) {
        resolveAllCommentReportsByCommentId(adminId, commentId, reason, "1_WEEK", "COMMENT_ONLY");
    }

    @Override
    @Transactional
    public void resolveAllCommentReportsByCommentId(Long adminId, Integer commentId, String reason, String duration, String banType) {
        List<CommentReport> pendingList = commentReportRepository.findPendingByCommentId(commentId);
        if (pendingList.isEmpty()) {
            return;
        }
        for (CommentReport report : pendingList) {
            report.setStatus(ReportStatus.RESOLVED);
            commentReportRepository.save(report);
        }

        Comment comment = pendingList.get(0).getComment();
        if (comment != null) {
            // Soft delete / ban target comment
            moderationService.softDeleteComment(adminId, comment.getId(),
                    "Resolved all pending reports (" + pendingList.size() + "): " + reason);
            
            // Ban the commenter
            if (comment.getUser() != null) {
                moderationService.banUser(adminId, comment.getUser().getId(), reason, duration, banType);
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
    public List<GroupedPostReportDto> getGroupedPendingPostReports() {
        List<PostReport> pendingList = postReportRepository.findAllPending();
        Map<Integer, GroupedPostReportDto> map = new LinkedHashMap<>();
        for (PostReport r : pendingList) {
            if (r.getPost() == null) continue;
            Integer postId = r.getPost().getId();
            GroupedPostReportDto dto = map.computeIfAbsent(postId, id -> new GroupedPostReportDto(r.getPost()));
            dto.addReport(r);
        }
        return new ArrayList<>(map.values());
    }

    @Override
    @Transactional(readOnly = true)
    public List<GroupedCommentReportDto> getGroupedPendingCommentReports() {
        List<CommentReport> pendingList = commentReportRepository.findAllPending();
        Map<Integer, GroupedCommentReportDto> map = new LinkedHashMap<>();
        for (CommentReport r : pendingList) {
            if (r.getComment() == null) continue;
            Integer commentId = r.getComment().getId();
            GroupedCommentReportDto dto = map.computeIfAbsent(commentId, id -> new GroupedCommentReportDto(r.getComment()));
            dto.addReport(r);
        }
        return new ArrayList<>(map.values());
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
