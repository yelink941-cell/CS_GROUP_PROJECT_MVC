package com.hibernate.service;

import com.hibernate.entity.User;

public interface ModerationService {
    void banUser(Long requesterAdminId, Long targetUserId, String reason, String duration, String banType);
    void unbanUser(Long requesterAdminId, Long targetUserId);
    boolean canBanUser(User requester, User target);
    void softDeletePost(Long adminId, Integer postId, String reason);
    void softDeleteComment(Long adminId, Integer commentId, String reason);
}
