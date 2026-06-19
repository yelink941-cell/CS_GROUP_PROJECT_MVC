package com.hibernate.repository;

import com.hibernate.entity.MessageAttachment;

public interface MessageAttachmentRepository {
    Long insertAttachment(MessageAttachment attachment);
}
