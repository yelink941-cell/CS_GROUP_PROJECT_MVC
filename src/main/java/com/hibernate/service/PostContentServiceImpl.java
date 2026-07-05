package com.hibernate.service;

import com.hibernate.entity.Post;
import com.hibernate.entity.PostContent;
import com.hibernate.entity.enums.ContentType;
import com.hibernate.repository.PostContentRepository;
import com.hibernate.repository.PostRepository;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
@Transactional
public class PostContentServiceImpl implements PostContentService {
    private static final long MAX_IMAGE_SIZE = 5L * 1024 * 1024;
    private static final Map<String, String> ALLOWED_IMAGE_TYPES = Map.of(
            "png", "image/png",
            "jpg", "image/jpeg",
            "jpeg", "image/jpeg",
            "webp", "image/webp");

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
    public PostContent addContent(Integer postId, PostContent postContent, MultipartFile imageFile) {
        Post post = getActivePost(postId);
        postContent.setPost(post);
        normalize(postContent, post.getId(), imageFile, null);
        return postContentRepository.save(postContent);
    }

    @Override
    public PostContent updateContent(
            Integer postId,
            Integer contentId,
            PostContent postContent,
            MultipartFile imageFile) {
        PostContent existingContent = postContentRepository.findByIdAndPostId(contentId, postId)
                .orElseThrow(() -> new IllegalArgumentException("Content section not found."));

        String reusableImagePath = ContentType.IMAGE.equals(existingContent.getContentType())
                ? existingContent.getContentData()
                : null;
        normalize(postContent, postId, imageFile, reusableImagePath);
        existingContent.setSubtitle(postContent.getSubtitle());
        existingContent.setContentType(postContent.getContentType());
        existingContent.setContentData(postContent.getContentData());
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

    private void normalize(
            PostContent postContent,
            Integer postId,
            MultipartFile imageFile,
            String existingContentData) {
        if (postContent.getContentType() == null) {
            postContent.setContentType(ContentType.TEXT);
        }

        validateSupportedType(postContent.getContentType());

        if (ContentType.IMAGE.equals(postContent.getContentType())) {
            postContent.setContentData(resolveImageContent(postId, imageFile, existingContentData));
            postContent.setSubtitle(trimToNull(postContent.getSubtitle()));
            return;
        }

        if (postContent.getContentData() == null || postContent.getContentData().trim().isEmpty()) {
            throw new IllegalArgumentException("Content data is required.");
        }

        postContent.setSubtitle(trimToNull(postContent.getSubtitle()));

    }

    private void validateSupportedType(ContentType contentType) {
        if (!ContentType.TEXT.equals(contentType)
                && !ContentType.CODE.equals(contentType)
                && !ContentType.IMAGE.equals(contentType)) {
            throw new IllegalArgumentException("Only TEXT, CODE, and IMAGE sections are allowed.");
        }
    }

    private String resolveImageContent(Integer postId, MultipartFile imageFile, String existingContentData) {
        if (imageFile == null || imageFile.isEmpty()) {
            if (existingContentData != null && !existingContentData.trim().isEmpty()) {
                return existingContentData;
            }

            throw new IllegalArgumentException("Please upload an image file.");
        }

        return storeImage(postId, imageFile);
    }

    private String storeImage(Integer postId, MultipartFile imageFile) {
        try {
            validateImage(imageFile);

            String originalFileName = sanitizeFileName(imageFile.getOriginalFilename());
            String extension = getExtension(originalFileName);
            String storedFileName = UUID.randomUUID() + "." + extension;
            Path uploadDirectory = getUploadDirectory(postId);
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

    private void validateImage(MultipartFile imageFile) throws IOException {
        if (imageFile == null || imageFile.isEmpty()) {
            throw new IllegalArgumentException("Please upload an image file.");
        }

        if (imageFile.getSize() > MAX_IMAGE_SIZE) {
            throw new IllegalArgumentException("Image size must not exceed 5MB.");
        }

        String fileName = sanitizeFileName(imageFile.getOriginalFilename());
        String extension = getExtension(fileName);
        String expectedContentType = ALLOWED_IMAGE_TYPES.get(extension);

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

    private Path getUploadDirectory(Integer postId) {
        return Paths.get(System.getProperty("user.home"), "cheatsheet-uploads", "posts", postId.toString(), "sections")
                .toAbsolutePath()
                .normalize();
    }

    private String trimToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        return value.trim();
    }
}
