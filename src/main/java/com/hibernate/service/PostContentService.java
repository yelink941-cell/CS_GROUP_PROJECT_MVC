package com.hibernate.service;

import com.hibernate.entity.PostContent;
import java.util.List;
import java.util.Optional;
import org.springframework.web.multipart.MultipartFile;

public interface PostContentService {
    boolean isPostOwner(Integer postId, Long userId);

    List<PostContent> getContentsByPostId(Integer postId);

    Optional<PostContent> getContent(Integer postId, Integer contentId);

    PostContent addContent(Integer postId, PostContent postContent, MultipartFile imageFile);

    PostContent updateContent(Integer postId, Integer contentId, PostContent postContent, MultipartFile imageFile);

    void deleteContent(Integer postId, Integer contentId);
}
