package com.hibernate.service;



import com.hibernate.dto.ChatInboxItem;

import com.hibernate.dto.ChatRoomView;

import com.hibernate.dto.MarkReadResponse;

import com.hibernate.dto.MessageResponse;

import com.hibernate.dto.UserSearchResult;

import com.hibernate.entity.Conversation;

import com.hibernate.entity.Message;

import com.hibernate.entity.enums.ReportReason;

import org.springframework.web.multipart.MultipartFile;



import java.util.List;



public interface ChatService {



    Conversation createConversation(String title, boolean isGroup, List<Long> userIds, Long creatorId);



    Conversation startDirectChat(Long currentUserId, Long targetUserId);



    List<ChatInboxItem> getInbox(Long currentUserId);



    ChatRoomView getRoomView(Long conversationId, Long currentUserId);



    List<UserSearchResult> searchUsers(String keyword, Long currentUserId);



    Message sendMessage(Long conversationId, Long senderId, String text, Long parentMessageId);
    Message sendMediaMessage(Long conversationId, Long senderId, List<MultipartFile> files, String caption);



    Message editMessage(Long messageId, Long senderId, String newText);



    Long deleteMessage(Long messageId, Long userId);



    void deleteConversationForUser(Long conversationId, Long userId);



    void blockUser(Long currentUserId, Long targetUserId);



    MarkReadResponse markMessagesAsRead(Long conversationId, Long userId, Long upToMessageId);



    void reportMessage(Long messageId, Long reporterId, ReportReason reason, String description);



    List<Message> getChatHistory(Long conversationId, Long currentUserId, Long lastMessageId);
    MessageResponse toMessageResponse(Message message);



    boolean isParticipant(Long conversationId, Long userId);



    boolean canModerateMessages(Long conversationId, Long userId);

    String resolveDisplayName(Long userId);

}

