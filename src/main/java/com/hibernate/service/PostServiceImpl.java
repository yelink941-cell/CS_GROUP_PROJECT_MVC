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
import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Optional;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
@Transactional
public class PostServiceImpl implements PostService {
    private static final long MAX_SECTION_IMAGE_SIZE = 5L * 1024 * 1024;
    private static final Map<String, String> ALLOWED_SECTION_IMAGE_TYPES = Map.of(
            "png", "image/png",
            "jpg", "image/jpeg",
            "jpeg", "image/jpeg",
            "webp", "image/webp");

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
            List<MultipartFile> contentImageFiles) {
        post.setAuthor(getUser(userId));
        post.setCategory(getCategory(categoryId));
        post.setTags(getTags(tagIds));
        post.setVisibility(visibility);
        post.setStatus(getStatusForVisibility(visibility));
        post.setSlug(generateUniqueSlug(post.getTitle()));
        post.setRejectionReason(null);
        Post savedPost = postRepository.save(post);
        savePostContents(
                savedPost,
                sectionSubtitles,
                contentTypes,
                contentDataList,
                contentImageFiles);
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
    public List<Post> getPopularPublishedPublicPosts(int limit) {
        return postRepository.findPopularPublishedPublicPosts(limit);
    }

    @Override
    public List<Post> getTrendingPublishedPublicPosts(int limit, int days) {
        return postRepository.findTrendingPublishedPublicPosts(limit, LocalDateTime.now().minusDays(days));
    }

    @Override
    public List<Post> getNewestPublishedPublicPosts() {
        return postRepository.findPublishedPublicPosts();
    }

    @Override
    public List<Post> getNewestPublishedPublicPosts(int limit) {
        return postRepository.findNewestPublishedPublicPosts(limit);
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

        if (tagIds == null || tagIds.isEmpty()) {
            return tags;
        }

        Set<Integer> uniqueTagIds = new LinkedHashSet<>(tagIds);

        for (Integer tagId : uniqueTagIds) {
            if (tagId == null) {
                continue;
            }

            Tag tag = tagRepository.findById(tagId)
                    .orElseThrow(() -> new IllegalArgumentException("Invalid tag selected."));
            tags.add(tag);
        }

        return tags;
    }

    private String generateUniqueSlug(String title) {
        String baseSlug = slugify(title);
        String uniqueSlug = baseSlug;
        int suffix = 2;

        while (postRepository.existsBySlug(uniqueSlug)) {
            uniqueSlug = baseSlug + "-" + suffix;
            suffix++;
        }

        return uniqueSlug;
    }

    private String slugify(String title) {
        if (title == null) {
            return "post";
        }

        String slug = title
                .toLowerCase(Locale.ENGLISH)
                .replaceAll("[^a-z0-9\\s-]", "")
                .replaceAll("\\s+", "-")
                .replaceAll("-+", "-")
                .replaceAll("^-|-$", "");

        return slug.isBlank() ? "post" : slug;
    }

    private void savePostContents(
            Post post,
            List<String> sectionSubtitles,
            List<ContentType> contentTypes,
            List<String> contentDataList,
            List<MultipartFile> contentImageFiles) {
        int sectionCount = getMaxSize(sectionSubtitles, contentTypes, contentDataList, contentImageFiles);
        if (sectionCount == 0) {
            return;
        }

        for (int index = 0; index < sectionCount; index++) {
            ContentType contentType = getContentType(contentTypes, index);
            String contentData = getValue(contentDataList, index);
            String subtitle = getValue(sectionSubtitles, index);
            MultipartFile imageFile = getValue(contentImageFiles, index);

            if (ContentType.IMAGE.equals(contentType)) {
                if ((imageFile == null || imageFile.isEmpty()) && isBlank(subtitle)) {
                    continue;
                }

                contentData = storeSectionImage(post.getId(), imageFile);
            } else {
                if (isBlank(contentData) && isBlank(subtitle)) {
                    continue;
                }

                if (isBlank(contentData)) {
                    throw new IllegalArgumentException("Content data is required for every section.");
                }

                contentData = contentData.trim();
            }

            validateSupportedContentType(contentType);

            if (isBlank(contentData)) {
                continue;
            }

            PostContent postContent = new PostContent();
            postContent.setPost(post);
            postContent.setSubtitle(isBlank(subtitle) ? null : subtitle.trim());
            postContent.setContentType(contentType);
            postContent.setContentData(contentData);
            postContentRepository.save(postContent);
        }
    }

    @SafeVarargs
    private final int getMaxSize(List<?>... lists) {
        int maxSize = 0;

        for (List<?> list : lists) {
            if (list != null && list.size() > maxSize) {
                maxSize = list.size();
            }
        }

        return maxSize;
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

    private void validateSupportedContentType(ContentType contentType) {
        if (!ContentType.TEXT.equals(contentType)
                && !ContentType.CODE.equals(contentType)
                && !ContentType.IMAGE.equals(contentType)) {
            throw new IllegalArgumentException("Only TEXT, CODE, and IMAGE sections are allowed.");
        }
    }

    private String storeSectionImage(Integer postId, MultipartFile imageFile) {
        try {
            validateSectionImage(imageFile);

            String originalFileName = sanitizeFileName(imageFile.getOriginalFilename());
            String extension = getExtension(originalFileName);
            String storedFileName = UUID.randomUUID() + "." + extension;
            Path uploadDirectory = getSectionUploadDirectory(postId);
            Path targetFile = uploadDirectory.resolve(storedFileName).normalize();

            if (!targetFile.startsWith(uploadDirectory)) {
                throw new IllegalArgumentException("Invalid image file name.");
            }

            Files.createDirectories(uploadDirectory);
            Files.copy(imageFile.getInputStream(), targetFile, StandardCopyOption.REPLACE_EXISTING);

            return "/uploads/posts/" + postId + "/sections/" + storedFileName;
        } catch (IOException exception) {
            throw new IllegalStateException("Unable to upload section image.");
        }
    }

    private void validateSectionImage(MultipartFile imageFile) throws IOException {
        if (imageFile == null || imageFile.isEmpty()) {
            throw new IllegalArgumentException("Please upload an image file for IMAGE sections.");
        }

        if (imageFile.getSize() > MAX_SECTION_IMAGE_SIZE) {
            throw new IllegalArgumentException("Image size must not exceed 5MB.");
        }

        String fileName = sanitizeFileName(imageFile.getOriginalFilename());
        String extension = getExtension(fileName);
        String expectedContentType = ALLOWED_SECTION_IMAGE_TYPES.get(extension);

        if (expectedContentType == null) {
            throw new IllegalArgumentException("Only JPG, JPEG, PNG, and WEBP images are allowed.");
        }

        String contentType = imageFile.getContentType();
        if (contentType == null || !expectedContentType.equalsIgnoreCase(contentType)) {
            throw new IllegalArgumentException("The uploaded image content does not match its extension.");
        }

        if (!hasValidImageSignature(imageFile, extension)) {
            throw new IllegalArgumentException("The uploaded image content is invalid.");
        }
    }

    private String sanitizeFileName(String originalFileName) {
        if (originalFileName == null || originalFileName.isBlank()) {
            throw new IllegalArgumentException("Invalid image file name.");
        }

        String fileName = Paths.get(originalFileName).getFileName().toString();
        if (fileName.length() > 255) {
            throw new IllegalArgumentException("Image file name must not exceed 255 characters.");
        }

        return fileName;
    }

    private String getExtension(String fileName) {
        int extensionIndex = fileName.lastIndexOf('.');
        if (extensionIndex < 0 || extensionIndex == fileName.length() - 1) {
            return "";
        }

        return fileName.substring(extensionIndex + 1).toLowerCase(Locale.ROOT);
    }

    private boolean hasValidImageSignature(MultipartFile imageFile, String extension) throws IOException {
        byte[] header = new byte[12];
        int bytesRead;

        try (InputStream inputStream = imageFile.getInputStream()) {
            bytesRead = inputStream.read(header);
        }

        if ("png".equals(extension)) {
            byte[] pngSignature = {(byte) 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A};
            if (bytesRead < pngSignature.length) {
                return false;
            }

            for (int index = 0; index < pngSignature.length; index++) {
                if (header[index] != pngSignature[index]) {
                    return false;
                }
            }

            return true;
        }

        if ("webp".equals(extension)) {
            return bytesRead >= 12
                    && header[0] == 'R'
                    && header[1] == 'I'
                    && header[2] == 'F'
                    && header[3] == 'F'
                    && header[8] == 'W'
                    && header[9] == 'E'
                    && header[10] == 'B'
                    && header[11] == 'P';
        }

        return bytesRead >= 3
                && header[0] == (byte) 0xFF
                && header[1] == (byte) 0xD8
                && header[2] == (byte) 0xFF;
    }

    private Path getSectionUploadDirectory(Integer postId) {
        return Paths.get(System.getProperty("user.home"), "cheatsheet-uploads", "posts", postId.toString(), "sections")
                .toAbsolutePath()
                .normalize();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    @Override
    public void toggleLike(Integer postId, Long userId) {
        // 🟢 PostLikeService ထဲရှိ toggleLike(Integer, Long) သို့ တိုက်ရိုက် လွှဲပေးခြင်း
        postLikeService.toggleLike(postId, userId);
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
}
