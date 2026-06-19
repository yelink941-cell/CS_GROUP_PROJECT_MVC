package com.hibernate.service;

import com.hibernate.dto.ChatInboxItem;
import com.hibernate.dto.ChatRoomView;
import com.hibernate.dto.UserSearchResult;
import com.hibernate.entity.Conversation;
import com.hibernate.entity.Message;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface ChatService {

    Conversation createConversation(String title, boolean isGroup, List<Long> userIds, Long creatorId);

    Conversation startDirectChat(Long currentUserId, Long targetUserId);

    List<ChatInboxItem> getInbox(Long currentUserId);

    ChatRoomView getRoomView(Long conversationId, Long currentUserId);

    List<UserSearchResult> searchUsers(String keyword, Long currentUserId);

    Message sendMessage(Long conversationId, Long senderId, String text);

    Message sendMediaMessage(Long conversationId, Long senderId, MultipartFile file, String caption);

    List<Message> getChatHistory(Long conversationId, Long currentUserId, Long lastMessageId);

    boolean isParticipant(Long conversationId, Long userId);
}
