package com.hibernate.repository;

public interface BlockedUserRepository {

    void blockUser(Long userId, Long blockedUserId);

    void unblockUser(Long userId, Long blockedUserId);

    boolean isBlocked(Long userId, Long blockedUserId);

    boolean isBlockedEitherWay(Long userId, Long otherUserId);
}
