package com.hibernate.service;

import com.hibernate.entity.Conversation;
import com.hibernate.entity.ConversationParticipant;
import com.hibernate.entity.Message;
import com.hibernate.entity.MessageAttachment;
import com.hibernate.entity.User;
import com.hibernate.entity.enums.MessageType;
import com.hibernate.entity.enums.ParticipantRole;
import com.hibernate.dto.ChatInboxItem;
import com.hibernate.dto.ChatRoomView;
import com.hibernate.dto.UserSearchResult;
import com.hibernate.repository.ConversationRepository;
import com.hibernate.repository.ConversationParticipantRepository;
import com.hibernate.repository.MessageAttachmentRepository;
import com.hibernate.repository.MessageRepository;
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
    private final FileStorageService fileStorageService;
    private final UserRepository userRepository;

    @Override
    public Conversation createConversation(String title, boolean isGroup, List<Long> userIds, Long creatorId) {

        if (!isGroup && userIds.size() == 1) {
            Long receiverId = userIds.get(0);
            List<Conversation> existingChats = conversationRepository.getAllConversationsByUserId(creatorId);
            for (Conversation chat : existingChats) {
                if (!chat.isGroup()) {
                    for (ConversationParticipant p : chat.getParticipants()) {
                        if (p.getUserId().equals(receiverId)) {
                            return chat;
                        }
                    }
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
            throw new IllegalArgumentException("ကိုယ့်ကိုယ်ကို chat မစတင်နိုင်ပါ။");
        }

        User target = userRepository.findById(targetUserId)
                .orElseThrow(() -> new IllegalArgumentException("User ကို ရှာမတွေ့ပါ။"));

        return createConversation(target.getUsername(), false, List.of(targetUserId), currentUserId);
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
                item.setDisplayName(conversation.getTitle() != null ? conversation.getTitle() : "Group Chat");
            } else {
                Long otherUserId = findOtherParticipantId(conversation, currentUserId);
                if (otherUserId != null) {
                    userRepository.findById(otherUserId).ifPresentOrElse(user -> {
                        item.setDisplayName(user.getUsername());
                        item.setDisplayRole(user.getRole() != null ? user.getRole().name() : "USER");
                    }, () -> item.setDisplayName("Unknown User"));
                } else {
                    item.setDisplayName(conversation.getTitle() != null ? conversation.getTitle() : "Chat");
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

        Conversation conversation = conversationRepository.getByIdWithParticipants(conversationId);
        if (conversation == null) {
            return null;
        }

        ChatRoomView view = new ChatRoomView();
        view.setConversationId(conversationId);
        view.setGroup(conversation.isGroup());

        if (conversation.isGroup()) {
            view.setTitle(conversation.getTitle() != null ? conversation.getTitle() : "Group Chat");
            return view;
        }

        Long otherUserId = findOtherParticipantId(conversation, currentUserId);
        if (otherUserId != null) {
            Optional<User> partner = userRepository.findById(otherUserId);
            if (partner.isPresent()) {
                view.setTitle(partner.get().getUsername());
                view.setPartnerRole(partner.get().getRole() != null ? partner.get().getRole().name() : "USER");
                return view;
            }
        }

        view.setTitle(conversation.getTitle() != null ? conversation.getTitle() : "Chat");
        return view;
    }

    @Override
    public List<UserSearchResult> searchUsers(String keyword, Long currentUserId) {
        if (keyword == null || keyword.trim().length() < 1) {
            return List.of();
        }

        return userRepository.searchByUsername(keyword.trim(), currentUserId, 10).stream()
                .map(user -> new UserSearchResult(
                        user.getId(),
                        user.getUsername(),
                        user.getRole() != null ? user.getRole().name() : "USER"))
                .collect(Collectors.toList());
    }

    @Override
    public Message sendMessage(Long conversationId, Long senderId, String text) {
        validateParticipant(conversationId, senderId);

        Conversation conversation = conversationRepository.getById(conversationId);
        if (conversation == null) {
            throw new RuntimeException("စကားဝိုင်း #" + conversationId + " ကို ရှာမတွေ့ပါ။");
        }

        Message message = new Message();
        message.setConversation(conversation);
        message.setSenderId(senderId);
        message.setMessageText(text);
        message.setMessageType(MessageType.TEXT);

        Long messageId = messageRepository.insertMessage(message);
        message.setId(messageId);

        conversation.setUpdatedAt(message.getCreatedAt());
        conversationRepository.updateConversation(conversation);

        return message;
    }

//    @Override
//    public Message sendMediaMessage(Long conversationId, Long senderId, List<MultipartFile> files, String caption) {
//        validateParticipant(conversationId, senderId);
//
//        Conversation conversation = conversationRepository.getById(conversationId);
//        if (conversation == null) {
//            throw new RuntimeException("စကားဝိုင်း #" + conversationId + " ကို ရှာမတွေ့ပါ။");
//        }
//
//        String fileUrl;
//        try {
//            fileUrl = fileStorageService.storeChatFile(conversationId, files.get(0));
//        } catch (Exception e) {
//            throw new RuntimeException("ဖိုင်သိမ်းဆည်းရာတွင် အမှားဖြစ်ပါသည်: " + e.getMessage(), e);
//        }
//
//        String contentType = files  .get(0).getContentType();
//        MessageType messageType = fileStorageService.isVideo(contentType, fileUrl)
//                ? MessageType.VIDEO : MessageType.IMAGE;
//
//        Message message = new Message();
//        message.setConversation(conversation);
//        message.setSenderId(senderId);
//        message.setMessageText(caption != null && !caption.isBlank() ? caption.trim() : null);
//        message.setMessageType(messageType);
//
//        Long messageId = messageRepository.insertMessage(message);
//        message.setId(messageId);
//
//        MessageAttachment attachment = new MessageAttachment();
//        attachment.setMessage(message);
//        attachment.setFileUrl(fileUrl);
//        attachment.setFileType(contentType != null ? contentType : "application/octet-stream");
//        attachment.setFileSize((int) files.get(0).getSize());
//        attachmentRepository.insertAttachment(attachment);
//
//        message.getAttachments().add(attachment);
//
//        conversation.setUpdatedAt(message.getCreatedAt());
//        conversationRepository.updateConversation(conversation);
//
//        return message;
//    }
    @Override
    public Message sendMediaMessage(Long conversationId, Long senderId, List<MultipartFile> files, String caption) {
        validateParticipant(conversationId, senderId);

        Conversation conversation = conversationRepository.getById(conversationId);
        if (conversation == null) {
            throw new RuntimeException("စကားဝိုင်း #" + conversationId + " ကို ရှာမတွေ့ပါ။");
        }

        // ၁။ Message Object ကို အရင်ဆောက်ပါမည် (ID မပါသေးပါ)
        Message message = new Message();
        message.setConversation(conversation);
        message.setSenderId(senderId);
        message.setMessageText(caption != null && !caption.isBlank() ? caption.trim() : null);

        MessageType finalType = MessageType.IMAGE;
        List<MessageAttachment> attachmentsToSave = new ArrayList<>();

        // ၂။ ဖိုင်များကို Loop ပတ်ပြီး Storage ထဲသိမ်းကာ Attachment Object များ ဆောက်ပါမည်
        for (MultipartFile file : files) {
            if (file == null || file.isEmpty()) continue;

            String fileUrl;
            try {
                // ဖိုင်တစ်ခုချင်းစီကို Storage ထဲ သိမ်းပါသည်
                fileUrl = fileStorageService.storeChatFile(conversationId, file);
            } catch (Exception e) {
                throw new RuntimeException("ဖိုင်သိမ်းဆည်းရာတွင် အမှားဖြစ်ပါသည်: " + e.getMessage(), e);
            }

            String contentType = file.getContentType();
            if (fileStorageService.isVideo(contentType, fileUrl)) {
                finalType = MessageType.VIDEO;
            }

            // Loop တစ်ခါပတ်တိုင်း Attachment Object "အသစ်" ဆောက်ပါသည်
            MessageAttachment attachment = new MessageAttachment();
            attachment.setFileUrl(fileUrl);
            attachment.setFileType(contentType != null ? contentType : "application/octet-stream");
            attachment.setFileSize((int) file.getSize());

            attachmentsToSave.add(attachment);
        }

        if (attachmentsToSave.isEmpty()) {
            throw new IllegalArgumentException("ပေးပို့ရန် ဖိုင်အနည်းဆုံး ၁ ခု ရွေးချယ်ပေးပါ။");
        }

        // ၃။ Message ကို DB ထဲ Insert လုပ်ပြီး ID ကို ယူပါသည်
        message.setMessageType(finalType);
        Long messageId = messageRepository.insertMessage(message);
        message.setId(messageId); // ရလာသော ID ကို Message Object တွင် ပြန်ထည့်သည်

        // ၄။ ရလာသော Message ID ကို အသုံးပြု၍ Attachment များကို DB ထဲ ထည့်ပါသည်
        message.setAttachments(new ArrayList<>());
        for (MessageAttachment att : attachmentsToSave) {
            att.setMessage(message); // Database Foreign Key (message_id) ဝင်စေရန်
            attachmentRepository.insertAttachment(att); // DB ထဲသို့ Insert လုပ်သည်
            message.getAttachments().add(att); // UI တွင် ချက်ချင်းပေါ်စေရန် List ထဲ ပြန်ထည့်သည်
        }

        // ၅။ Conversation ရဲ့ Updated အချိန်ကို ပြင်ဆင်သည်
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
    public boolean isParticipant(Long conversationId, Long userId) {
        return participantRepository.isUserParticipant(conversationId, userId);
    }

    private void validateParticipant(Long conversationId, Long userId) {
        if (!participantRepository.isUserParticipant(conversationId, userId)) {
            throw new SecurityException("ဒီစကားဝိုင်းတွင် ပါဝင်သူမဟုတ်သောကြောင့် ခွင့်ပြုချက်မရှိပါ။");
        }
    }

    private Long findOtherParticipantId(Conversation conversation, Long currentUserId) {
        for (ConversationParticipant participant : conversation.getParticipants()) {
            if (!participant.getUserId().equals(currentUserId)) {
                return participant.getUserId();
            }
        }
        return null;
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
