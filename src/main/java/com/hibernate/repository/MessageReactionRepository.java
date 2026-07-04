package com.hibernate.repository;

import com.hibernate.entity.MessageReaction;
import java.util.List;
import java.util.Optional;

public interface MessageReactionRepository {
    MessageReaction save(MessageReaction reaction);
    void delete(MessageReaction reaction);
    Optional<MessageReaction> findByMessageIdAndUserIdAndEmoji(Long messageId, Long userId, String emoji);
    Optional<MessageReaction> findByMessageIdAndUserId(Long messageId, Long userId);
    int deleteByMessageIdAndUserId(Long messageId, Long userId);
    List<MessageReaction> findByMessageId(Long messageId);
}
