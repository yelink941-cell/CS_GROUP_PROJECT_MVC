package com.hibernate.controller;

import com.hibernate.entity.Post;
import com.hibernate.entity.enums.PostStatus;
import com.hibernate.entity.enums.PostVisibility;
import com.hibernate.repository.PostRepository;
import com.hibernate.service.FileStorageService;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.transaction.annotation.Transactional;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@RestController
public class MediaController {

    private final FileStorageService fileStorageService;
    private final PostRepository postRepository;

    public MediaController(FileStorageService fileStorageService, PostRepository postRepository) {
        this.fileStorageService = fileStorageService;
        this.postRepository = postRepository;
    }

    @GetMapping("/media/chat/{conversationId}/{filename:.+}")
    public ResponseEntity<?> serveChatMedia(@PathVariable Long conversationId,
                                            @PathVariable String filename) {
        try {
            Path filePath = fileStorageService.resolveStoredFile(conversationId, filename);
            if (!Files.exists(filePath)) {
                return ResponseEntity.notFound().build();
            }

            UrlResource resource = new UrlResource(filePath.toUri());
            String contentType = Files.probeContentType(filePath);
            if (contentType == null) {
                contentType = MediaType.APPLICATION_OCTET_STREAM_VALUE;
            }

            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + filename + "\"")
                    .contentType(MediaType.parseMediaType(contentType))
                    .body(resource);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping({
            "/uploads/posts/{postId}/{filename:.+}",
            "/uploads/posts/{postId}/sections/{filename:.+}"
    })
    @Transactional(readOnly = true)
    public ResponseEntity<?> servePostUpload(
            @PathVariable Integer postId,
            @PathVariable String filename,
            HttpServletRequest request) {
        try {
            Post post = postRepository.findById(postId).orElse(null);
            if (post == null || post.getDeletedAt() != null) {
                return ResponseEntity.notFound().build();
            }

            if (!canAccessPostUpload(post, request.getSession(false))) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
            }

            Path uploadDirectory = Paths.get(
                            System.getProperty("user.home"),
                            "cheatsheet-uploads",
                            "posts",
                            postId.toString(),
                            request.getRequestURI().contains("/sections/") ? "sections" : "")
                    .toAbsolutePath()
                    .normalize();
            Path filePath = uploadDirectory.resolve(Paths.get(filename).getFileName().toString()).normalize();

            if (!filePath.startsWith(uploadDirectory) || !Files.exists(filePath) || !Files.isRegularFile(filePath)) {
                return ResponseEntity.notFound().build();
            }

            UrlResource resource = new UrlResource(filePath.toUri());
            String contentType = Files.probeContentType(filePath);
            if (contentType == null) {
                contentType = MediaType.APPLICATION_OCTET_STREAM_VALUE;
            }

            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + filePath.getFileName() + "\"")
                    .contentType(MediaType.parseMediaType(contentType))
                    .body(resource);
        } catch (Exception exception) {
            return ResponseEntity.notFound().build();
        }
    }

    private boolean canAccessPostUpload(Post post, HttpSession session) {
        if (PostVisibility.PUBLIC.equals(post.getVisibility()) && PostStatus.PUBLISHED.equals(post.getStatus())) {
            return true;
        }

        if (session == null) {
            return false;
        }

        Long userId = (Long) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        return "ADMIN".equals(role)
                || (userId != null && post.getAuthor() != null && userId.equals(post.getAuthor().getId()));
    }
}
