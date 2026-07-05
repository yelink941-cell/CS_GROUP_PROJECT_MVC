package com.hibernate.service;

import com.hibernate.entity.Category;
import com.hibernate.entity.Comment;
import com.hibernate.entity.Post;
import com.hibernate.entity.PostContent;
import com.hibernate.entity.Tag;
import com.hibernate.entity.User;
import com.hibernate.entity.enums.ContentType;
import com.hibernate.entity.enums.PostStatus;
import com.hibernate.entity.enums.PostVisibility;
import com.hibernate.repository.CategoryRepository;
import com.hibernate.repository.CommentRepository;
import com.hibernate.repository.PostContentRepository;
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
    private final PostContentRepository postContentRepository;
    private final CategoryRepository categoryRepository;
    private final TagRepository tagRepository;
    private final UserRepository userRepository;
    private final CommentRepository commentRepository;
    private final PostLikeService postLikeService;

    @Override
    public Post createPost(
            Post post,
            Integer categoryId,
            List<Integer> tagIds,
            Long userId,
            PostVisibility visibility,
            List<String> sectionSubtitles,
            List<ContentType> contentTypes,
            List<String> contentDataList,
            List<Integer> sortOrders) {
        post.setAuthor(getUser(userId));
        post.setCategory(getCategory(categoryId));
        post.setTags(getTags(tagIds));
        post.setVisibility(visibility);
        post.setStatus(getStatusForVisibility(visibility));
        post.setRejectionReason(null);
        Post savedPost = postRepository.save(post);
        savePostContents(
                savedPost,
                sectionSubtitles,
                contentTypes,
                contentDataList,
                sortOrders);
        return savedPost;
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
    public List<Post> getPostsByAuthorId(Long authorId) {
        return postRepository.findByAuthorId(authorId);
    }

    @Override
    public Optional<Post> getPostBySlug(String slug) {
        return postRepository.findBySlug(slug);
    }

    @Override
    public Optional<Post> getActivePostBySlug(String slug) {
        return postRepository.findActiveBySlug(slug);
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
    public List<Post> getPublishedPublicPostsByTagId(Integer tagId) {
        return postRepository.findPublishedPublicByTagId(tagId);
    }

    @Override
    public List<Post> getPopularPublishedPublicPosts() {
        return postRepository.findPopularPublishedPublicPosts();
    }

    @Override
    public List<Post> getNewestPublishedPublicPosts() {
        return postRepository.findPublishedPublicPosts();
    }

    @Override
    public List<Object[]> getPublishedPublicPostCountsByCategory() {
        return postRepository.countPublishedPublicPostsByCategory();
    }

    @Override
    public List<Object[]> getPublishedPublicPostCountsByTag() {
        return postRepository.countPublishedPublicPostsByTag();
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

    private User getUser(Long userId) {
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

    private void savePostContents(
            Post post,
            List<String> sectionSubtitles,
            List<ContentType> contentTypes,
            List<String> contentDataList,
            List<Integer> sortOrders) {
        if (contentDataList == null || contentDataList.isEmpty()) {
            return;
        }

        for (int index = 0; index < contentDataList.size(); index++) {
            String contentData = contentDataList.get(index);
            String subtitle = getValue(sectionSubtitles, index);

            if (isBlank(contentData) && isBlank(subtitle)) {
                continue;
            }

            if (isBlank(contentData)) {
                throw new IllegalArgumentException("Content data is required for every section.");
            }

            PostContent postContent = new PostContent();
            postContent.setPost(post);
            postContent.setSubtitle(isBlank(subtitle) ? null : subtitle.trim());
            postContent.setContentType(getContentType(contentTypes, index));
            postContent.setContentData(contentData);
            postContent.setSortOrder(getSortOrder(sortOrders, index));
            postContentRepository.save(postContent);
        }
    }

    private <T> T getValue(List<T> values, int index) {
        if (values == null || index >= values.size()) {
            return null;
        }

        return values.get(index);
    }

    private ContentType getContentType(List<ContentType> contentTypes, int index) {
        ContentType contentType = getValue(contentTypes, index);
        return contentType == null ? ContentType.TEXT : contentType;
    }

    private Integer getSortOrder(List<Integer> sortOrders, int index) {
        Integer sortOrder = getValue(sortOrders, index);
        return sortOrder == null ? index + 1 : sortOrder;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    @Override
    public boolean toggleLike(Integer postId, Long userId) {
        return postLikeService.toggleLike(postId, userId);
    }

    @Override
    public void addComment(Integer postId, Long userId, String text) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Post not found."));
        User user = userRepository.getUserById(userId);
        if (user == null) {
            throw new IllegalArgumentException("User not found.");
        }

        Comment comment = new Comment();
        comment.setPost(post);
        comment.setUser(user);
        
        // Entity ထဲမှ တကယ်ပါဝင်သော content field ၏ setter ကို အသုံးပြုခြင်း
        comment.setContent(text); 
        
        commentRepository.save(comment);
    }

    @Override
    public boolean hasUserLiked(Integer postId, Long userId) {
        // 🟢 လိုအပ်သော Override method အား တိကျစွာ ရေးသားခြင်း
        return postLikeService.hasUserLiked(postId, userId);
    }
    
 // PostServiceImpl.java တွင် ထည့်ရန်
    @Override
    public long countAllPosts() {
        return postRepository.count();
    }

    @Override
    public long countPendingPosts() {
        return postRepository.countByStatus(PostStatus.PENDING); // Repository မှာ ဒီ method ရှိဖို့လိုပါတယ်
    }
    @Override
    public List<Post> getApprovedPosts() {
        return postRepository.findByStatus(PostStatus.PUBLISHED);
    }
    @Override
    public List<Post> getRejectedPosts() {
        return postRepository.findByStatus(PostStatus.REJECTED);
    }

    @Override
    public long countByStatus(PostStatus status) {
        return postRepository.countByStatus(status);
    }

}