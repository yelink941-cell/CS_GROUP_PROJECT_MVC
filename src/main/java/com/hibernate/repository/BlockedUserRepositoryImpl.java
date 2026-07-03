package com.hibernate.repository;

import com.hibernate.entity.BlockedUser;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
@Transactional
public class BlockedUserRepositoryImpl implements BlockedUserRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public void blockUser(Long userId, Long blockedUserId) {
        if (isBlocked(userId, blockedUserId)) {
            return;
        }

        BlockedUser blocked = new BlockedUser();
        blocked.setUserId(userId);
        blocked.setBlockedUserId(blockedUserId);
        getSession().save(blocked);
    }

    @Override
    public void unblockUser(Long userId, Long blockedUserId) {
        getSession().createQuery(
                "DELETE FROM BlockedUser b " +
                "WHERE b.userId = :userId AND b.blockedUserId = :blockedUserId")
                .setParameter("userId", userId)
                .setParameter("blockedUserId", blockedUserId)
                .executeUpdate();
    }

    @Override
    public boolean isBlocked(Long userId, Long blockedUserId) {
        Long count = getSession().createQuery(
                "SELECT COUNT(b) FROM BlockedUser b " +
                "WHERE b.userId = :userId AND b.blockedUserId = :blockedUserId", Long.class)
                .setParameter("userId", userId)
                .setParameter("blockedUserId", blockedUserId)
                .uniqueResult();

        return count != null && count > 0;
    }

    @Override
    public boolean isBlockedEitherWay(Long userId, Long otherUserId) {
        return isBlocked(userId, otherUserId) || isBlocked(otherUserId, userId);
    }
}
