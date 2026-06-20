package com.hibernate.service;

import com.hibernate.entity.Post;
import com.hibernate.entity.PostFile;
import com.hibernate.repository.PostFileRepository;
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
import javax.servlet.ServletContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
@Transactional
public class PostFileServiceImpl implements PostFileService {
    private static final long MAX_FILE_SIZE = 5L * 1024 * 1024;
    private static final Map<String, String> ALLOWED_FILE_TYPES = Map.of(
            "pdf", "application/pdf",
            "png", "image/png",
            "jpg", "image/jpeg",
            "jpeg", "image/jpeg");

    private final PostFileRepository postFileRepository;
    private final PostRepository postRepository;
    private final ServletContext servletContext;

    @Override
    @Transactional(readOnly = true)
    public boolean isPostOwner(Integer postId, Long userId) {
        if (userId == null) {
            return false;
        }

        return postRepository.findById(postId)
                .filter(post -> post.getDeletedAt() == null)
                .map(Post::getAuthor)
                .map(author -> author.getId().equals(userId))
                .orElse(false);
    }

    @Override
    @Transactional(readOnly = true)
    public List<PostFile> getFilesByPostId(Integer postId) {
        return postFileRepository.findByPostId(postId);
    }

    @Override
    public PostFile uploadFile(Integer postId, MultipartFile file) throws IOException {
        validateFile(file);

        Post post = postRepository.findById(postId)
                .filter(existingPost -> existingPost.getDeletedAt() == null)
                .orElseThrow(() -> new IllegalArgumentException("Post not found."));

        String originalFileName = sanitizeFileName(file.getOriginalFilename());
        String extension = getExtension(originalFileName);
        String storedFileName = UUID.randomUUID() + "." + extension;
        Path uploadDirectory = getUploadDirectory(postId);
        Path targetFile = uploadDirectory.resolve(storedFileName).normalize();

        if (!targetFile.startsWith(uploadDirectory)) {
            throw new IllegalArgumentException("Invalid file name.");
        }

        Files.createDirectories(uploadDirectory);
        Files.copy(file.getInputStream(), targetFile, StandardCopyOption.REPLACE_EXISTING);

        PostFile postFile = new PostFile();
        postFile.setPost(post);
        postFile.setFileName(originalFileName);
        postFile.setFileUrl("/uploads/posts/" + postId + "/" + storedFileName);
        postFile.setFileType(ALLOWED_FILE_TYPES.get(extension));

        return postFileRepository.save(postFile);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<PostFile> getFile(Integer postId, Integer fileId) {
        return postFileRepository.findByIdAndPostId(fileId, postId);
    }

    @Override
    public Path resolveFile(PostFile postFile) {
        String storedFileName = Paths.get(postFile.getFileUrl()).getFileName().toString();
        Path uploadDirectory = getUploadDirectory(postFile.getPost().getId());
        Path resolvedFile = uploadDirectory.resolve(storedFileName).normalize();

        if (!resolvedFile.startsWith(uploadDirectory)) {
            throw new IllegalArgumentException("Invalid stored file path.");
        }

        return resolvedFile;
    }

    private void validateFile(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("Please select a file.");
        }

        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("File size must not exceed 5MB.");
        }

        String fileName = sanitizeFileName(file.getOriginalFilename());
        String extension = getExtension(fileName);
        String expectedContentType = ALLOWED_FILE_TYPES.get(extension);

        if (expectedContentType == null) {
            throw new IllegalArgumentException("Only PDF, PNG, JPG, and JPEG files are allowed.");
        }

        String contentType = file.getContentType();
        if (contentType == null || !expectedContentType.equalsIgnoreCase(contentType)) {
            throw new IllegalArgumentException("The uploaded file content does not match its extension.");
        }

        if (!hasValidSignature(file, extension)) {
            throw new IllegalArgumentException("The uploaded file content is invalid.");
        }
    }

    private String sanitizeFileName(String originalFileName) {
        if (originalFileName == null || originalFileName.isBlank()) {
            throw new IllegalArgumentException("Invalid file name.");
        }

        String fileName = Paths.get(originalFileName).getFileName().toString();
        if (fileName.length() > 255) {
            throw new IllegalArgumentException("File name must not exceed 255 characters.");
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

    private boolean hasValidSignature(MultipartFile file, String extension) throws IOException {
        byte[] header = new byte[8];
        int bytesRead;

        try (InputStream inputStream = file.getInputStream()) {
            bytesRead = inputStream.read(header);
        }

        if ("pdf".equals(extension)) {
            return bytesRead >= 5
                    && header[0] == '%'
                    && header[1] == 'P'
                    && header[2] == 'D'
                    && header[3] == 'F'
                    && header[4] == '-';
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

        return bytesRead >= 3
                && header[0] == (byte) 0xFF
                && header[1] == (byte) 0xD8
                && header[2] == (byte) 0xFF;
    }

    private Path getUploadDirectory(Integer postId) {
        String webRoot = servletContext.getRealPath("/");
        if (webRoot == null) {
            throw new IllegalStateException("The application upload directory is unavailable.");
        }

        return Paths.get(webRoot, "uploads", "posts", postId.toString())
                .toAbsolutePath()
                .normalize();
    }
}
