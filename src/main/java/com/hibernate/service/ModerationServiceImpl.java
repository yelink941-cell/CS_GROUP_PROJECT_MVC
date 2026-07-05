package com.hibernate.service;

import com.hibernate.entity.Comment;
import com.hibernate.entity.ModerationLog;
import com.hibernate.entity.Post;
import com.hibernate.entity.User;
import com.hibernate.entity.enums.ModerationAction;
import com.hibernate.entity.enums.Role;
import com.hibernate.entity.enums.UserStatus;
import com.hibernate.repository.ModerationLogRepository;
import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

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
    public void banUser(Long requesterAdminId, Long targetUserId, String reason, String duration) {
        User requester = getUser(requesterAdminId);
        if (requester == null || !requester.isAdmin()) {
            throw new SecurityException("Unauthorized: Requester must be an Admin.");
        }

        User target = getUser(targetUserId);
        if (target == null) {
            throw new IllegalArgumentException("Target user not found.");
        }

        if (target.isAdmin() && requester.getRole() != Role.SUPER_ADMIN) {
            throw new SecurityException("Unauthorized: Admins can only be banned by Super Admins.");
        }

        LocalDateTime expiresAt = null;
        String durationText = "Permanent (ထာဝရ)";
        if ("1_WEEK".equalsIgnoreCase(duration)) {
            expiresAt = LocalDateTime.now().plusWeeks(1);
            durationText = "1 Week (၁ ပတ်)";
        } else if ("1_MONTH".equalsIgnoreCase(duration)) {
            expiresAt = LocalDateTime.now().plusMonths(1);
            durationText = "1 Month (၁ လ)";
        } else if ("1_YEAR".equalsIgnoreCase(duration)) {
            expiresAt = LocalDateTime.now().plusYears(1);
            durationText = "1 Year (၁ နှစ်)";
        }

        target.setStatus(UserStatus.BANNED);
        target.setBanExpiresAt(expiresAt);
        target.setBanReason(reason);
        sessionFactory.getCurrentSession().merge(target);

        // Audit Logging
        ModerationLog log = new ModerationLog();
        log.setAdminId(requesterAdminId.intValue());
        log.setTargetUserId(targetUserId.intValue());
        log.setAction(ModerationAction.BAN);
        log.setReason("Duration: " + durationText + " | Reason: " + reason);
        moderationLogRepository.save(log);

        notificationService.createNotification(
                targetUserId,
                "BAN",
                "Account Suspended (" + durationText + ")",
                "Your account has been suspended for " + durationText + ". Reason: " + reason,
                "USER",
                targetUserId.intValue()
        );
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void unbanUser(Long requesterAdminId, Long targetUserId) {
        User requester = getUser(requesterAdminId);
        if (requester == null || !requester.isAdmin()) {
            throw new SecurityException("Unauthorized: Requester must be an Admin.");
        }

        User target = getUser(targetUserId);
        if (target == null) {
            throw new IllegalArgumentException("Target user not found.");
        }

        target.setStatus(UserStatus.ACTIVE);
        target.setBanExpiresAt(null);
        target.setBanReason(null);
        sessionFactory.getCurrentSession().merge(target);

        // Audit Logging
        ModerationLog log = new ModerationLog();
        log.setAdminId(requesterAdminId.intValue());
        log.setTargetUserId(targetUserId.intValue());
        log.setAction(ModerationAction.UNBAN);
        log.setReason("Admin restored user account (Pardon / ကင်းလွှတ်ခွင့်)");
        moderationLogRepository.save(log);

        notificationService.createNotification(
                targetUserId,
                "UNBAN",
                "Account Restored 🎉",
                "Your account has been unbanned. You may now post and comment again.",
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
        if (target.isCurrentlyBanned()) {
            return false;
        }
        return !target.isAdmin() || requester.getRole() == Role.SUPER_ADMIN;
    }
}
