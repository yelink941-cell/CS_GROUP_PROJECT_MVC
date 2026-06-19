package com.hibernate.service;

import com.hibernate.entity.Category;
import com.hibernate.entity.Post;
import com.hibernate.entity.Tag;
import com.hibernate.entity.User;
import com.hibernate.entity.enums.PostStatus;
import com.hibernate.entity.enums.PostVisibility;
import com.hibernate.repository.CategoryRepository;
import com.hibernate.repository.PostRepository;
import com.hibernate.repository.TagRepository;
import com.hibernate.repository.UserRepository;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class PostServiceImpl implements PostService {
    private final PostRepository postRepository;
    private final CategoryRepository categoryRepository;
    private final TagRepository tagRepository;
    private final UserRepository userRepository;

    @Override
    public Post createPost(
            Post post,
            Integer categoryId,
            List<Integer> tagIds,
            Integer userId,
            PostVisibility visibility) {
        post.setAuthor(getUser(userId));
        post.setCategory(getCategory(categoryId));
        post.setTags(getTags(tagIds));
        post.setVisibility(visibility);
        post.setStatus(getStatusForVisibility(visibility));
        post.setRejectionReason(null);
        return postRepository.save(post);
    }

    @Override
    public Post updatePost(
            Integer id,
            Post post,
            Integer categoryId,
            List<Integer> tagIds,
            PostVisibility visibility) {
        Post existingPost = postRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Post not found."));

        existingPost.setTitle(post.getTitle());
        existingPost.setSlug(post.getSlug());
        existingPost.setExcerpt(post.getExcerpt());
        existingPost.setVisibility(visibility);
        existingPost.setStatus(getStatusForVisibility(visibility));
        existingPost.setRejectionReason(null);
        existingPost.setCategory(getCategory(categoryId));
        existingPost.setTags(getTags(tagIds));

        return postRepository.update(existingPost);
    }

    @Override
    public void deletePost(Integer id) {
        postRepository.delete(id);
    }

    @Override
    public Optional<Post> getPostById(Integer id) {
        return postRepository.findById(id);
    }

    @Override
    public List<Post> getAllPosts() {
        return postRepository.findAll();
    }

    @Override
    public List<Post> getPostsByAuthorId(Integer authorId) {
        return postRepository.findByAuthorId(authorId);
    }

    @Override
    public Optional<Post> getPostBySlug(String slug) {
        return postRepository.findBySlug(slug);
    }

    @Override
    public boolean existsBySlug(String slug) {
        return postRepository.existsBySlug(slug);
    }

    @Override
    public List<Post> getPostsByCategoryId(Integer categoryId) {
        return postRepository.findByCategoryId(categoryId);
    }

    @Override
    public List<Post> getPostsByStatus(PostStatus status) {
        return postRepository.findByStatus(status);
    }

    @Override
    public List<Post> getPendingPosts() {
        return postRepository.findPendingPosts();
    }

    @Override
    public List<Post> getPublishedPublicPosts() {
        return postRepository.findPublishedPublicPosts();
    }

    @Override
    public void approvePost(Integer id) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Post not found."));
        post.setStatus(PostStatus.PUBLISHED);
        post.setRejectionReason(null);
        postRepository.update(post);
    }

    @Override
    public void rejectPost(Integer id, String rejectionReason) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Post not found."));
        post.setStatus(PostStatus.REJECTED);
        post.setRejectionReason(rejectionReason);
        postRepository.update(post);
    }

    private Category getCategory(Integer categoryId) {
        return categoryRepository.findById(categoryId)
                .orElseThrow(() -> new IllegalArgumentException("Category not found."));
    }

    private User getUser(Integer userId) {
        User user = userRepository.getUserById(userId);

        if (user == null) {
            throw new IllegalArgumentException("User not found.");
        }

        return user;
    }

    private PostStatus getStatusForVisibility(PostVisibility visibility) {
        if (PostVisibility.PRIVATE.equals(visibility)) {
            return PostStatus.PUBLISHED;
        }

        return PostStatus.PENDING;
    }

    private List<Tag> getTags(List<Integer> tagIds) {
        List<Tag> tags = new ArrayList<>();

        if (tagIds == null) {
            return tags;
        }

        for (Integer tagId : tagIds) {
            Tag tag = tagRepository.findById(tagId)
                    .orElseThrow(() -> new IllegalArgumentException("Tag not found."));
            tags.add(tag);
        }

        return tags;
    }
}
