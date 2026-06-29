package com.hibernate.controller;

import com.hibernate.entity.Post;
import com.hibernate.entity.PostFile;
import com.hibernate.entity.User;
import com.hibernate.entity.enums.PostStatus;
import com.hibernate.entity.enums.PostVisibility;
import com.hibernate.entity.enums.Role;
import com.hibernate.service.PostFileService;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/posts/files")
public class PostFileDownloadController {
    private final PostFileService postFileService;

    @GetMapping("/{fileId}/download")
    public ResponseEntity<Resource> downloadFile(
            @PathVariable("fileId") Integer fileId,
            HttpServletRequest request) {
        PostFile postFile = postFileService.getById(fileId).orElse(null);
        if (postFile == null) {
            return ResponseEntity.notFound().build();
        }

        Post post = postFile.getPost();
        User currentUser = getCurrentUser(request);
        if (!canDownload(post, currentUser, request)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        try {
            Path filePath = postFileService.resolveFile(postFile);
            if (!Files.exists(filePath) || !Files.isRegularFile(filePath)) {
                return ResponseEntity.notFound().build();
            }

            Resource resource = new UrlResource(filePath.toUri());
            ContentDisposition disposition = ContentDisposition.attachment()
                    .filename(postFile.getFileName(), StandardCharsets.UTF_8)
                    .build();

            return ResponseEntity.ok()
                    .contentType(getMediaType(postFile))
                    .header(HttpHeaders.CONTENT_DISPOSITION, disposition.toString())
                    .body(resource);
        } catch (IllegalArgumentException exception) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        } catch (Exception exception) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    private boolean canDownload(Post post, User currentUser, HttpServletRequest request) {
        if (post == null) {
            return false;
        }

        if (isPublishedPublicPost(post)) {
            return true;
        }

        if (currentUser != null) {
            return isPostOwner(post, currentUser.getId()) || Role.ADMIN.equals(currentUser.getRole());
        }

        Long sessionUserId = getSessionUserId(request);
        return sessionUserId != null && isPostOwner(post, sessionUserId) || isAdminRole(request);
    }

    private boolean isPublishedPublicPost(Post post) {
        return PostVisibility.PUBLIC.equals(post.getVisibility())
                && PostStatus.PUBLISHED.equals(post.getStatus())
                && post.getDeletedAt() == null;
    }

    private boolean isPostOwner(Post post, Long userId) {
        return userId != null
                && post.getAuthor() != null
                && userId.equals(post.getAuthor().getId());
    }

    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }

        Object user = session.getAttribute("user");
        if (user instanceof User) {
            return (User) user;
        }

        Object currentUser = session.getAttribute("currentUser");
        return currentUser instanceof User ? (User) currentUser : null;
    }

    private Long getSessionUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }

        Object userId = session.getAttribute("userId");
        return userId instanceof Number ? ((Number) userId).longValue() : null;
    }

    private boolean isAdminRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        Object role = session.getAttribute("role");
        return role != null && Role.ADMIN.name().equals(role.toString());
    }

    private MediaType getMediaType(PostFile postFile) {
        try {
            if (postFile.getFileType() != null && !postFile.getFileType().isBlank()) {
                return MediaType.parseMediaType(postFile.getFileType());
            }
        } catch (Exception exception) {
            return MediaType.APPLICATION_OCTET_STREAM;
        }

        return MediaType.APPLICATION_OCTET_STREAM;
    }
}
