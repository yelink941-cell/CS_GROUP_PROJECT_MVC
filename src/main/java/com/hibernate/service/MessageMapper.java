package com.hibernate.service;

import com.hibernate.dto.AttachmentResponse;
import com.hibernate.dto.MessageResponse;
import com.hibernate.entity.Message;
import com.hibernate.entity.MessageAttachment;

import java.util.List;
import java.util.stream.Collectors;

public final class MessageMapper {

    private MessageMapper() {}

    public static MessageResponse toResponse(Message message) {
        MessageResponse response = new MessageResponse();
        response.setId(message.getId());
        response.setSenderId(message.getSenderId());
        response.setMessageText(message.getMessageText());
        response.setMessageType(message.getMessageType());
        response.setCreatedAt(message.getCreatedAt());

        if (message.getAttachments() != null) {
            List<AttachmentResponse> attachments = message.getAttachments().stream()
                    .map(MessageMapper::toAttachmentResponse)
                    .collect(Collectors.toList());
            response.setAttachments(attachments);
        }
        return response;
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
