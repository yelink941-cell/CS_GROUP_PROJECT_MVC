package com.hibernate.service;

import com.hibernate.entity.Post;

public interface PostPdfService {
    byte[] generatePostPdf(Post post);
}
