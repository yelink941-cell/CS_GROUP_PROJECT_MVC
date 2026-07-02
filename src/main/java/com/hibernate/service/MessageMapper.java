package com.hibernate.service;

import com.hibernate.dto.AttachmentResponse;
import com.hibernate.dto.MessageResponse;
import com.hibernate.entity.Message;
import com.hibernate.entity.MessageAttachment;
import com.hibernate.entity.MessageSeenStatus;

import java.util.List;
import java.util.stream.Collectors;

public final class MessageMapper {

    private MessageMapper() {}

    public static MessageResponse toResponse(Message message) {
        MessageResponse response = new MessageResponse();
        response.setId(message.getId());
        if (message.getConversation() != null) {
            response.setConversationId(message.getConversation().getId());
        }
        response.setSenderId(message.getSenderId());
        response.setMessageText(message.getMessageText());
        response.setMessageType(message.getMessageType());
        response.setEdited(message.isEdited());
        response.setCreatedAt(message.getCreatedAt());
        response.setUpdatedAt(message.getUpdatedAt());

        if (message.getParentMessage() != null) {
            response.setParentMessageId(message.getParentMessage().getId());
            response.setParentMessagePreview(buildPreview(message.getParentMessage()));
        }

        if (message.getAttachments() != null) {
            List<AttachmentResponse> attachments = message.getAttachments().stream()
                    .map(MessageMapper::toAttachmentResponse)
                    .collect(Collectors.toList());
            response.setAttachments(attachments);
        }

        if (message.getSeenStatuses() != null && !message.getSeenStatuses().isEmpty()) {
            List<Long> readerIds = message.getSeenStatuses().stream()
                    .map(MessageSeenStatus::getUserId)
                    .collect(Collectors.toList());
            response.setReadByUserIds(readerIds);
            response.setReadCount(readerIds.size());
        }

        return response;
    }

    private static String buildPreview(Message message) {
        if (message.getMessageText() != null && !message.getMessageText().isBlank()) {
            String text = message.getMessageText().trim();
            return text.length() > 80 ? text.substring(0, 80) + "…" : text;
        }
        if (message.getMessageType() != null) {
            switch (message.getMessageType()) {
                case IMAGE: return "📷 Photo";
                case VIDEO: return "🎬 Video";
                default: break;
            }
        }
        return "Message";
    }

    private static AttachmentResponse toAttachmentResponse(MessageAttachment attachment) {
        AttachmentResponse response = new AttachmentResponse();
        response.setId(attachment.getId());
        response.setFileUrl(attachment.getFileUrl());
        response.setFileType(attachment.getFileType());
        response.setFileSize(attachment.getFileSize());
        return response;
    }
}
