package com.hibernate.repository;

import com.hibernate.entity.MessageSeenStatus;
import java.util.List;

public interface MessageSeenStatusRepository {

    Long insertSeenStatus(MessageSeenStatus seenStatus);

    List<MessageSeenStatus> findByMessageId(Long messageId);

    boolean existsByMessageIdAndUserId(Long messageId, Long userId);

    int markConversationReadUpTo(Long conversationId, Long userId, Long upToMessageId);

    long countUnreadMessages(Long conversationId, Long userId);

    long countTotalUnreadMessages(Long userId);
}
