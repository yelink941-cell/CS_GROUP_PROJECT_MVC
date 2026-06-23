package com.hibernate.service;

import com.hibernate.entity.Post;
import com.hibernate.entity.PostContent;
import com.hibernate.entity.enums.ContentType;
import com.hibernate.repository.PostContentRepository;
import com.hibernate.repository.PostRepository;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class PostContentServiceImpl implements PostContentService {
    private final PostContentRepository postContentRepository;
    private final PostRepository postRepository;

    @Override
    @Transactional(readOnly = true)
    public boolean isPostOwner(Integer postId, Long userId) {
        if (userId == null) {
            return false;
        }

        return postRepository.findById(postId)
                .filter(post -> post.getDeletedAt() == null)
                .map(Post::getAuthor)
                .map(author -> userId.equals(author.getId()))
                .orElse(false);
    }

    @Override
    @Transactional(readOnly = true)
    public List<PostContent> getContentsByPostId(Integer postId) {
        return postContentRepository.findByPostId(postId);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<PostContent> getContent(Integer postId, Integer contentId) {
        return postContentRepository.findByIdAndPostId(contentId, postId);
    }

    @Override
    public PostContent addContent(Integer postId, PostContent postContent) {
        postContent.setPost(getActivePost(postId));
        normalize(postContent);
        return postContentRepository.save(postContent);
    }

    @Override
    public PostContent updateContent(Integer postId, Integer contentId, PostContent postContent) {
        PostContent existingContent = postContentRepository.findByIdAndPostId(contentId, postId)
                .orElseThrow(() -> new IllegalArgumentException("Content section not found."));

        normalize(postContent);
        existingContent.setSubtitle(postContent.getSubtitle());
        existingContent.setContentType(postContent.getContentType());
        existingContent.setContentData(postContent.getContentData());
        existingContent.setSortOrder(postContent.getSortOrder());
        return postContentRepository.update(existingContent);
    }

    @Override
    public void deleteContent(Integer postId, Integer contentId) {
        PostContent postContent = postContentRepository.findByIdAndPostId(contentId, postId)
                .orElseThrow(() -> new IllegalArgumentException("Content section not found."));
        postContentRepository.delete(postContent);
    }

    private Post getActivePost(Integer postId) {
        return postRepository.findById(postId)
                .filter(post -> post.getDeletedAt() == null)
                .orElseThrow(() -> new IllegalArgumentException("Post not found."));
    }

    private void normalize(PostContent postContent) {
        if (postContent.getContentType() == null) {
            postContent.setContentType(ContentType.TEXT);
        }

        if (postContent.getContentData() == null || postContent.getContentData().trim().isEmpty()) {
            throw new IllegalArgumentException("Content data is required.");
        }

        postContent.setSubtitle(trimToNull(postContent.getSubtitle()));

        if (postContent.getSortOrder() == null) {
            postContent.setSortOrder(0);
        }
    }

    private String trimToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        return value.trim();
    }
}
