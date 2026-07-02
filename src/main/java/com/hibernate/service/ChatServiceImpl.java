package com.hibernate.service;

import com.hibernate.entity.Conversation;
import com.hibernate.entity.ConversationParticipant;
import com.hibernate.entity.Message;
import com.hibernate.entity.MessageAttachment;
import com.hibernate.entity.User;
import com.hibernate.entity.enums.MessageType;
import com.hibernate.entity.enums.ParticipantRole;
import com.hibernate.entity.enums.Role;
import com.hibernate.dto.ChatInboxItem;
import com.hibernate.dto.ChatRoomView;
import com.hibernate.dto.MessageResponse;
import com.hibernate.dto.UserSearchResult;
import com.hibernate.dto.MarkReadResponse;
import com.hibernate.entity.MessageReport;
import com.hibernate.entity.enums.ReportReason;
import com.hibernate.repository.BlockedUserRepository;
import com.hibernate.repository.ConversationRepository;
import com.hibernate.repository.ConversationParticipantRepository;
import com.hibernate.repository.MessageAttachmentRepository;
import com.hibernate.repository.MessageReportRepository;
import com.hibernate.repository.MessageRepository;
import com.hibernate.repository.MessageSeenStatusRepository;
import com.hibernate.repository.UserRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class ChatServiceImpl implements ChatService {

    private final ConversationRepository conversationRepository;
    private final MessageRepository messageRepository;
    private final ConversationParticipantRepository participantRepository;
    private final MessageAttachmentRepository attachmentRepository;
    private final MessageSeenStatusRepository seenStatusRepository;
    private final MessageReportRepository messageReportRepository;
    private final FileStorageService fileStorageService;
    private final UserRepository userRepository;
    private final BlockedUserRepository blockedUserRepository;

    @Override
    public Conversation createConversation(String title, boolean isGroup, List<Long> userIds, Long creatorId) {

        if (!isGroup && userIds.size() == 1) {
            Long receiverId = userIds.get(0);
            Long existingConversationId = 
            		participantRepository.findDirectConversationIdBetweenUsers(creatorId, receiverId);
            if (existingConversationId != null) {
                Conversation existing = 
                		conversationRepository.getById(existingConversationId);
                if (existing != null) {
                    return existing;
                }
            }
        }

        Conversation conversation = new Conversation();
        conversation.setTitle(title);
        conversation.setGroup(isGroup);

        Long chatId = conversationRepository.insertConversation(conversation);
        conversation.setId(chatId);

        List<ConversationParticipant> participants = new ArrayList<>();

        ConversationParticipant creator = new ConversationParticipant();
        creator.setConversation(conversation);
        creator.setUserId(creatorId);
        creator.setRole(isGroup ? ParticipantRole.ADMIN : ParticipantRole.MEMBER);
        participantRepository.insertParticipant(creator);
        participants.add(creator);

        for (Long userId : userIds) {
            if (!userId.equals(creatorId)) {
                ConversationParticipant participant = new ConversationParticipant();
                participant.setConversation(conversation);
                participant.setUserId(userId);
                participant.setRole(ParticipantRole.MEMBER);
                participantRepository.insertParticipant(participant);
                participants.add(participant);
            }
        }

        conversation.setParticipants(participants);
        return conversation;
    }

    @Override
    public Conversation startDirectChat(Long currentUserId, Long targetUserId) {
        if (currentUserId.equals(targetUserId)) {
            throw new IllegalArgumentException("You can't start a chat with myself.");
        }

        if (blockedUserRepository.isBlockedEitherWay(currentUserId, targetUserId)) {
            throw new SecurityException("Unable to start chat with this user.");
        }

        User target = userRepository.findById(targetUserId)
                .orElseThrow(() -> new IllegalArgumentException("User is not fသund"));

        return createConversation(resolveDisplayName(target), false, List.of(targetUserId), currentUserId);
    }

    @Override
    public List<ChatInboxItem> getInbox(Long currentUserId) {
        List<Conversation> conversations = conversationRepository.getAllConversationsByUserId(currentUserId);
        List<ChatInboxItem> inbox = new ArrayList<>();

        for (Conversation conversation : conversations) {
            ChatInboxItem item = new ChatInboxItem();
            item.setConversationId(conversation.getId());
            item.setGroup(conversation.isGroup());

            if (conversation.isGroup()) {
                item.setDisplayName(getConversationTitle(conversation, "Group Chat"));
            } else {
                PartnerInfo partner = getPartnerInfo(conversation.getId(), currentUserId);
                if (partner != null) {
                    item.setPartnerUserId(partner.userId);
                    item.setDisplayName(partner.displayName);
                    item.setDisplayRole(partner.role);
                } else {
                    item.setDisplayName(getConversationTitle(conversation, "Chat"));
                }
            }

            messageRepository.findLatestByConversationId(conversation.getId()).ifPresent(message -> {
                item.setLastMessageAt(message.getCreatedAt());
                item.setLastMessagePreview(buildPreview(message));
            });

            inbox.add(item);
        }

        return inbox;
    }

    @Override
    public ChatRoomView getRoomView(Long conversationId, Long currentUserId) {
        if (!participantRepository.isUserParticipant(conversationId, currentUserId)) {
            return null;
        }

        participantRepository.restoreConversationForUser(conversationId, currentUserId);

        Conversation conversation = conversationRepository.getByIdWithParticipants(conversationId);
        if (conversation == null) {
            return null;
        }

        ChatRoomView view = new ChatRoomView();
        view.setConversationId(conversationId);
        view.setGroup(conversation.isGroup());
        view.setCanModerate(canModerateMessagesInternal(conversationId, currentUserId));

        if (conversation.isGroup()) {
            view.setTitle(getConversationTitle(conversation, "Group Chat"));
            return view;
        }

        PartnerInfo partner = getPartnerInfo(conversationId, currentUserId);
        if (partner != null) {
            view.setTitle(partner.displayName);
            view.setPartnerUserId(partner.userId);
            view.setPartnerRole(partner.role);
            return view;
        }

        view.setTitle(getConversationTitle(conversation, "Chat"));
        return view;
    }

    @Override
    public boolean canModerateMessages(Long conversationId, Long userId) {
        return canModerateMessagesInternal(conversationId, userId);
    }

    @Override
    public List<UserSearchResult> searchUsers(String keyword, Long currentUserId) {
        if (keyword == null || keyword.trim().length() < 1) {
            return List.of();
        }

        return userRepository.searchByUsername(keyword.trim(), currentUserId, 10).stream()
                .filter(user -> !blockedUserRepository.isBlockedEitherWay(currentUserId, user.getId()))
                .map(user -> new UserSearchResult(
                        user.getId(),
                        user.getUsername(),
                        resolveDisplayName(user),
                        getUserRoleName(user)))
                .collect(Collectors.toList());
    }

    @Override
    public Message sendMessage(Long conversationId, Long senderId, String text, Long parentMessageId) {
        validateParticipant(conversationId, senderId);
        assertNotBlockedInConversation(conversationId, senderId);
        participantRepository.restoreConversationForUser(conversationId, senderId);

        if (text == null || text.isBlank()) {
            throw new IllegalArgumentException("Enter text.");
        }

        Conversation conversation = conversationRepository.getById(conversationId);
        if (conversation == null) {
            throw new RuntimeException("Conversation #" + conversationId + " not found.");
        }

        Message message = new Message();
        message.setConversation(conversation);
        message.setSenderId(senderId);
        message.setMessageText(text.trim());
        message.setMessageType(MessageType.TEXT);

        if (parentMessageId != null) {
            Message parent = messageRepository.getById(parentMessageId);
            if (parent == null || parent.getConversation() == null
                    || !parent.getConversation().getId().equals(conversationId)) {
                throw new IllegalArgumentException("The message to reply is invalid.");
            }
            message.setParentMessage(parent);
        }

        Long messageId = messageRepository.insertMessage(message);
        message.setId(messageId);

        conversation.setUpdatedAt(message.getCreatedAt());
        conversationRepository.updateConversation(conversation);

        return message;
    }

    @Override
    public Message editMessage(Long messageId, Long senderId, String newText) {
        if (newText == null || newText.isBlank()) {
            throw new IllegalArgumentException("Enter text");
        }

        Message message = messageRepository.findByIdAndSenderId(messageId, senderId)
                .orElseThrow(() -> new SecurityException("You do not have permission to edit this message."));

        validateParticipant(message.getConversation().getId(), senderId);

        message.setMessageText(newText.trim());
        message.setEdited(true);
        message.setUpdatedAt(now());
        messageRepository.updateMessage(message);

        return messageRepository.getByIdWithDetails(messageId);
    }

    @Override
    public Long deleteMessage(Long messageId, Long userId) {
        Message message = messageRepository.getById(messageId);
        if (message == null || message.getDeletedAt() != null) {
            throw new IllegalArgumentException("Message is not found!");
        }

        Long conversationId = message.getConversation().getId();
        validateParticipant(conversationId, userId);

        boolean isOwner = message.getSenderId().equals(userId);
        if (!isOwner && !canModerateMessagesInternal(conversationId, userId)) {
            throw new SecurityException("You do not have permission to delete this message.");
        }

        message.setDeletedAt(now());
        messageRepository.updateMessage(message);
        return conversationId;
    }

    @Override
    public void deleteConversationForUser(Long conversationId, Long userId) {
        validateParticipant(conversationId, userId);

        ConversationParticipant participant = participantRepository.findParticipant(conversationId, userId)
                .orElseThrow(() -> new SecurityException("You are not authorized to participate in this conversation."));

        java.time.LocalDateTime currentTime = now();
        messageRepository.softDeleteAllByConversationId(conversationId, currentTime);
        participant.setHiddenAt(currentTime);
        participantRepository.updateParticipant(participant);
    }

    @Override
    public void blockUser(Long currentUserId, Long targetUserId) {
        if (currentUserId.equals(targetUserId)) {
            throw new IllegalArgumentException("You can't block yourself.");
        }

        userRepository.findById(targetUserId)
                .orElseThrow(() -> new IllegalArgumentException("User not found."));

        blockedUserRepository.blockUser(currentUserId, targetUserId);

        Long conversationId = participantRepository.findDirectConversationIdBetweenUsers(currentUserId, targetUserId);
        if (conversationId != null) {
            participantRepository.findParticipant(conversationId, currentUserId).ifPresent(participant -> {
                participant.setHiddenAt(now());
                participantRepository.updateParticipant(participant);
            });
        }
    }

    @Override
    public MarkReadResponse markMessagesAsRead(Long conversationId, Long userId, Long upToMessageId) {
        validateParticipant(conversationId, userId);

        Long effectiveUpTo = upToMessageId;
        if (effectiveUpTo == null) {
            effectiveUpTo = messageRepository.findLatestByConversationId(conversationId)
                    .map(Message::getId)
                    .orElse(null);
        }
        if (effectiveUpTo == null) {
            return new MarkReadResponse(conversationId, null, 0, List.of(userId));
        }

        int markedCount = seenStatusRepository.markConversationReadUpTo(conversationId, userId, effectiveUpTo);
        return new MarkReadResponse(conversationId, effectiveUpTo, markedCount, List.of(userId));
    }

    @Override
    public void reportMessage(Long messageId, Long reporterId, ReportReason reason, String description) {
        Message message = messageRepository.getById(messageId);
        if (message == null || message.getConversation() == null) {
            throw new IllegalArgumentException("Message not found");
        }

        validateParticipant(message.getConversation().getId(), reporterId);

        if (message.getSenderId().equals(reporterId)) {
            throw new IllegalArgumentException("You cannot report your own message.");
        }
        if (reason == null) {
            throw new IllegalArgumentException("Choose report reason ");
        }

        User reporter = userRepository.findById(reporterId)
                .orElseThrow(() -> new IllegalArgumentException("User Not Found"));

        MessageReport report = new MessageReport();
        report.setMessage(message);
        report.setReporter(reporter);
        report.setReason(reason);
        report.setDescription(description);
        messageReportRepository.insertReport(report);
    }

    @Override
    public Message sendMediaMessage(Long conversationId, Long senderId, List<MultipartFile> files, String caption) {
        validateParticipant(conversationId, senderId);
        assertNotBlockedInConversation(conversationId, senderId);
        participantRepository.restoreConversationForUser(conversationId, senderId);

        Conversation conversation = conversationRepository.getById(conversationId);
        if (conversation == null) {
            throw new RuntimeException("Conversation #" + conversationId + " not found.");
        }

        // 1. Create Message Object first (ID not included yet)
        Message message = new Message();
        message.setConversation(conversation);
        message.setSenderId(senderId);
        message.setMessageText(caption != null && !caption.isBlank() ? caption.trim() : null);

        MessageType finalType = MessageType.IMAGE;
        List<MessageAttachment> attachmentsToSave = new ArrayList<>();

        // 2. Loop through files, store in Storage and create Attachment Objects
        for (MultipartFile file : files) {
            if (file == null || file.isEmpty()) continue;

            String fileUrl;
            try {
                // Store each file in Storage
                fileUrl = fileStorageService.storeChatFile(conversationId, file);
            } catch (Exception e) {
                throw new RuntimeException("Error occurred while storing file: " + e.getMessage(), e);
            }

            String contentType = file.getContentType();
            if (fileStorageService.isVideo(contentType, fileUrl)) {
                finalType = MessageType.VIDEO;
            }

            // Create a 'new' Attachment Object each loop iteration
            MessageAttachment attachment = new MessageAttachment();
            attachment.setFileUrl(fileUrl);
            attachment.setFileType(contentType != null ? contentType : "application/octet-stream");
            attachment.setFileSize((int) file.getSize());

            attachmentsToSave.add(attachment);
        }

        if (attachmentsToSave.isEmpty()) {
            throw new IllegalArgumentException("Please select at least 1 file to send.");
        }

        // 3. Insert Message into DB and get ID
        message.setMessageType(finalType);
        Long messageId = messageRepository.insertMessage(message);
        message.setId(messageId); // Put the obtained ID back into Message Object

        // 4. Use the obtained Message ID to insert Attachments into DB
        message.setAttachments(new ArrayList<>());
        for (MessageAttachment att : attachmentsToSave) {
            att.setMessage(message); // To allow Database Foreign Key (message_id) to enter
            attachmentRepository.insertAttachment(att); // Insert into DB
            message.getAttachments().add(att); // Put back into List to show immediately in UI
        }

        // 5. Update Conversation's Updated time
        conversation.setUpdatedAt(message.getCreatedAt());
        conversationRepository.updateConversation(conversation);

        return message;
    }
    @Override
    public List<Message> getChatHistory(Long conversationId, Long currentUserId, Long lastMessageId) {
        validateParticipant(conversationId, currentUserId);
        return messageRepository.getChatHistory(conversationId, lastMessageId, 20);
    }

    @Override
    public MessageResponse toMessageResponse(Message message) {
        MessageResponse response = MessageMapper.toResponse(message);
        response.setSenderDisplayName(resolveDisplayName(message.getSenderId()));
        return response;
    }

    @Override
    public boolean isParticipant(Long conversationId, Long userId) {
        return participantRepository.isUserParticipant(conversationId, userId);
    }

    private void validateParticipant(Long conversationId, Long userId) {
        if (!participantRepository.isUserParticipant(conversationId, userId)) {
            throw new SecurityException("You don't have permission because you're not a participant in this conversation.");
        }
    }

    private void assertNotBlockedInConversation(Long conversationId, Long userId) {
        Conversation conversation = conversationRepository.getById(conversationId);
        if (conversation == null || conversation.isGroup()) {
            return;
        }

        Long otherUserId = findOtherParticipantId(conversationId, userId);
        if (otherUserId != null && blockedUserRepository.isBlockedEitherWay(userId, otherUserId)) {
            throw new SecurityException("Cannot send message with blocked user.");
        }
    }

    private boolean canModerateMessagesInternal(Long conversationId, Long userId) {
        User user = userRepository.findById(userId).orElse(null);
        if (user != null && user.getRole() == Role.ADMIN) {
            return true;
        }
        return participantRepository.findParticipantRole(conversationId, userId)
                .map(role -> role == ParticipantRole.ADMIN)
                .orElse(false);
    }

    private Long findOtherParticipantId(Long conversationId, Long currentUserId) {
        return participantRepository.findOtherParticipantUserId(conversationId, currentUserId);
    }

    private PartnerInfo getPartnerInfo(Long conversationId, Long currentUserId) {
        Long otherUserId = findOtherParticipantId(conversationId, currentUserId);
        if (otherUserId == null) {
            return null;
        }
        if (blockedUserRepository.isBlockedEitherWay(currentUserId, otherUserId)) {
            return null;
        }
        Optional<User> partner = userRepository.findById(otherUserId);
        if (partner.isEmpty()) {
            return null;
        }
        User user = partner.get();
        return new PartnerInfo(
            otherUserId,
            resolveDisplayName(user),
            getUserRoleName(user)
        );
    }

    private static class PartnerInfo {
        final Long userId;
        final String displayName;
        final String role;

        PartnerInfo(Long userId, String displayName, String role) {
            this.userId = userId;
            this.displayName = displayName;
            this.role = role;
        }
    }

    private String getConversationTitle(Conversation conversation, String defaultTitle) {
        return conversation.getTitle() != null ? conversation.getTitle() : defaultTitle;
    }

    private String getUserRoleName(User user) {
        return user.getRole() != null ? user.getRole().name() : "USER";
    }

    private java.time.LocalDateTime now() {
        return java.time.LocalDateTime.now();
    }

    private String resolveDisplayName(User user) {
        if (user == null) {
            return "Unknown User";
        }
        return userRepository.findFullNameByUserId(user.getId())
                .orElse(user.getUsername());
    }

    @Override
    public String resolveDisplayName(Long userId) {
        if (userId == null) {
            return "Unknown User";
        }
        return userRepository.findById(userId)
                .map(this::resolveDisplayName)
                .orElse("Unknown User");
    }

    private String buildPreview(Message message) {
        if (message.getMessageText() != null && !message.getMessageText().isBlank()) {
            return message.getMessageText();
        }
        if (message.getMessageType() == MessageType.IMAGE) {
            return "📷 Photo";
        }
        if (message.getMessageType() == MessageType.VIDEO) {
            return "🎬 Video";
        }
        if (message.getAttachments() != null && !message.getAttachments().isEmpty()) {
            MessageAttachment attachment = message.getAttachments().get(0);
            if (fileStorageService.isVideo(attachment.getFileType(), attachment.getFileUrl())) {
                return "🎬 Video";
            }
            return "📷 Photo";
        }
        return "Message";
    }
}
