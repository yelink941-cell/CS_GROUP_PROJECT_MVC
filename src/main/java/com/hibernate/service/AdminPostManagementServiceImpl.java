package com.hibernate.service;

import com.hibernate.entity.AdminPostAuditLog;
import com.hibernate.entity.Post;
import com.hibernate.entity.User;
import com.hibernate.entity.enums.PostStatus;
import com.hibernate.repository.AdminPostAuditLogRepository;
import com.hibernate.repository.AdminPostManagementRepository;
import com.hibernate.repository.PostRepository;
import java.time.LocalDateTime;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class AdminPostManagementServiceImpl implements AdminPostManagementService {
    private final AdminPostManagementRepository adminPostManagementRepository;
    private final AdminPostAuditLogRepository adminPostAuditLogRepository;
    private final PostRepository postRepository;

    @Override
    @Transactional(readOnly = true)
    public List<Post> getAllPosts() {
        return adminPostManagementRepository.findAllForManagement();
    }

    @Override
    @Transactional(readOnly = true)
    public Post getPostDetail(Integer id) {
        return getPost(id);
    }

    @Override
    public void archivePost(Integer id, User admin) {
        Post post = getPost(id);

        if (PostStatus.REMOVED.equals(post.getStatus()) || PostStatus.USER_DELETED.equals(post.getStatus())) {
            throw new IllegalStateException("Removed or user-deleted posts cannot be archived.");
        }

        if (!PostStatus.ARCHIVED.equals(post.getStatus())) {
            post.setStatusBeforeArchive(post.getStatus());
            post.setStatus(PostStatus.ARCHIVED);
            post.setArchivedAt(LocalDateTime.now());
            adminPostManagementRepository.update(post);
            saveAudit(admin, post, "ARCHIVED", null);
        }
    }

    @Override
    public void restorePost(Integer id, User admin) {
        Post post = getPost(id);

        if (PostStatus.USER_DELETED.equals(post.getStatus())) {
            throw new IllegalStateException("User-deleted posts cannot be restored.");
        }

        if (PostStatus.ARCHIVED.equals(post.getStatus())) {
            PostStatus restoredStatus = post.getStatusBeforeArchive() == null
                    ? PostStatus.PUBLISHED
                    : post.getStatusBeforeArchive();
            post.setStatus(restoredStatus);
            post.setStatusBeforeArchive(null);
            post.setArchivedAt(null);
            adminPostManagementRepository.update(post);
            saveAudit(admin, post, "RESTORED", null);
        }
    }

    @Override
    public void removePost(Integer id, String removalReason, User admin) {
        if (removalReason == null || removalReason.trim().isEmpty()) {
            throw new IllegalArgumentException("Removal reason is required.");
        }

        Post post = getPost(id);

        if (PostStatus.USER_DELETED.equals(post.getStatus())) {
            throw new IllegalStateException("User-deleted posts cannot be removed. Use Permanent Delete instead.");
        }

        post.setStatus(PostStatus.REMOVED);
        post.setRemovalReason(removalReason.trim());
        post.setRemovedAt(LocalDateTime.now());
        post.setArchivedAt(null);
        post.setStatusBeforeArchive(null);
        adminPostManagementRepository.update(post);
        saveAudit(admin, post, "REMOVED", removalReason.trim());
    }

    @Override
    public void permanentlyDeleteUserDeletedPost(Integer id, User admin) {
        Post post = getPost(id);

        if (!PostStatus.USER_DELETED.equals(post.getStatus())) {
            throw new IllegalStateException("Only USER_DELETED posts can be permanently deleted.");
        }

        saveAudit(admin, post, "PERMANENTLY_DELETED", "User-deleted post permanently deleted by admin.");
        postRepository.deletePermanently(id);
    }

    private Post getPost(Integer id) {
        return adminPostManagementRepository.findByIdForManagement(id)
                .orElseThrow(() -> new IllegalArgumentException("Post not found."));
    }

    private void saveAudit(User admin, Post post, String action, String reason) {
        AdminPostAuditLog auditLog = new AdminPostAuditLog();
        auditLog.setAdminId(admin == null ? null : admin.getId());
        auditLog.setAdminName(admin == null ? "Unknown Admin" : admin.getUsername());
        auditLog.setAction(action);
        auditLog.setPostId(post.getId());
        auditLog.setPostTitle(post.getTitle());
        auditLog.setReason(reason);
        adminPostAuditLogRepository.save(auditLog);
    }
}
