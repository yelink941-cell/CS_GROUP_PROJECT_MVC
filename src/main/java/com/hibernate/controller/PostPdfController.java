package com.hibernate.controller;

import com.hibernate.entity.Post;
import com.hibernate.entity.User;
import com.hibernate.entity.enums.PostStatus;
import com.hibernate.entity.enums.PostVisibility;
import com.hibernate.entity.enums.Role;
import com.hibernate.service.PostPdfService;
import com.hibernate.service.PostService;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
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
@RequestMapping("/posts")
public class PostPdfController {
    private final PostService postService;
    private final PostPdfService postPdfService;

    @GetMapping("/{slug}/download-pdf")
    public ResponseEntity<byte[]> downloadPostPdf(
            @PathVariable("slug") String slug,
            HttpServletRequest request) {
        Post post = postService.getActivePostBySlug(slug).orElse(null);
        if (post == null) {
            return ResponseEntity.notFound().build();
        }

        if (!canDownload(post, request)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        byte[] pdfBytes = postPdfService.generatePostPdf(post);
        String fileName = buildFileName(post);

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .contentLength(pdfBytes.length)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
                .header("X-Content-Type-Options", "nosniff")
                .body(pdfBytes);
    }

    private boolean canDownload(Post post, HttpServletRequest request) {
        if (isPublishedPublicPost(post)) {
            return true;
        }

        User currentUser = getCurrentUser(request);
        if (currentUser != null) {
            return isPostOwner(post, currentUser.getId()) || Role.ADMIN.equals(currentUser.getRole());
        }

        Long userId = getSessionUserId(request);
        return (userId != null && isPostOwner(post, userId)) || isAdminRole(request);
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

    private String buildFileName(Post post) {
        String slug = post.getSlug() == null || post.getSlug().isBlank()
                ? "cheatsheet"
                : post.getSlug();
        return slug.replaceAll("[^a-zA-Z0-9._-]", "-") + "-cheatsheet.pdf";
    }
}
