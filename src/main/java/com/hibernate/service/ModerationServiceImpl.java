package com.hibernate.service;

import com.hibernate.entity.Comment;
import com.hibernate.entity.ModerationLog;
import com.hibernate.entity.Post;
import com.hibernate.entity.User;
import com.hibernate.entity.enums.ModerationAction;
import com.hibernate.entity.enums.Role;
import com.hibernate.entity.enums.UserStatus;
import com.hibernate.repository.ModerationLogRepository;
import lombok.RequiredArgsConstructor;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class ModerationServiceImpl implements ModerationService {

    private final SessionFactory sessionFactory;
    private final ModerationLogRepository moderationLogRepository;
    private final NotificationService notificationService;

    private User getUser(Long id) {
        return sessionFactory.getCurrentSession().get(User.class, id);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void banUser(Long requesterAdminId, Long targetUserId, String reason) {
        User requester = getUser(requesterAdminId);
        if (requester == null || !requester.isAdmin()) {
            throw new SecurityException("Unauthorized: Requester must be an Admin.");
        }

        User target = getUser(targetUserId);
        if (target == null) {
            throw new IllegalArgumentException("Target user not found.");
        }

        // Target Check: Prevent admins from banning other admins (unless they are a Super Admin).
        if (target.isAdmin() && requester.getRole() != Role.SUPER_ADMIN) {
            throw new SecurityException("Unauthorized: Admins can only be banned by Super Admins.");
        }

        // Status Update: Change target user's status from ACTIVE to BANNED
        target.setStatus(UserStatus.BANNED);
        sessionFactory.getCurrentSession().merge(target);

        // Audit Logging: Write to moderation_logs
        ModerationLog log = new ModerationLog();
        log.setAdminId(requesterAdminId.intValue());
        log.setTargetUserId(targetUserId.intValue());
        log.setAction(ModerationAction.BAN);
        log.setReason(reason);
        moderationLogRepository.save(log);

        notificationService.createNotification(
                targetUserId,
                "BAN",
                "Account Suspended",
                "Your account has been suspended. Reason: " + reason,
                "USER",
                targetUserId.intValue()
        );
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void softDeletePost(Long adminId, Integer postId, String reason) {
        User admin = getUser(adminId);
        if (admin == null || !admin.isAdmin()) {
            throw new SecurityException("Unauthorized: Requester must be an Admin.");
        }

        Post post = sessionFactory.getCurrentSession().get(Post.class, postId);
        if (post != null) {
            post.setIsDeleted(true);
            post.setDeletedAt(LocalDateTime.now());
            sessionFactory.getCurrentSession().merge(post);

            // Audit Logging
            ModerationLog log = new ModerationLog();
            log.setAdminId(adminId.intValue());
            log.setPostId(postId);
            log.setAction(ModerationAction.HIDDEN);
            log.setReason(reason);
            moderationLogRepository.save(log);

            if (post.getAuthor() != null) {
                notificationService.createNotification(
                        post.getAuthor().getId(),
                        "POST_BANNED",
                        "Post Banned",
                        "Your post has been banned and removed. Reason: " + reason,
                        "POST",
                        postId
                );
            }
        }
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void softDeleteComment(Long adminId, Integer commentId, String reason) {
        User admin = getUser(adminId);
        if (admin == null || !admin.isAdmin()) {
            throw new SecurityException("Unauthorized: Requester must be an Admin.");
        }

        Comment comment = sessionFactory.getCurrentSession().get(Comment.class, commentId);
        if (comment != null) {
            comment.setIsDeleted(true);
            comment.setDeletedAt(LocalDateTime.now());
            sessionFactory.getCurrentSession().merge(comment);

            // Audit Logging
            ModerationLog log = new ModerationLog();
            log.setAdminId(adminId.intValue());
            log.setCommentId(commentId);
            log.setAction(ModerationAction.HIDDEN);
            log.setReason(reason);
            moderationLogRepository.save(log);

            if (comment.getUser() != null) {
                notificationService.createNotification(
                        comment.getUser().getId(),
                        "CONTENT_REMOVED",
                        "Comment Removed",
                        "Your comment was removed by a moderator. Reason: " + reason,
                        "COMMENT",
                        commentId
                );
            }
        }
    }

    @Override
    public boolean canBanUser(User requester, User target) {
        if (requester == null || target == null) {
            return false;
        }
        if (UserStatus.BANNED.equals(target.getStatus())) {
            return false;
        }
        return !target.isAdmin() || requester.getRole() == Role.SUPER_ADMIN;
    }
}
