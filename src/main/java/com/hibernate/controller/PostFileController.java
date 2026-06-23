package com.hibernate.controller;

import com.hibernate.entity.PostFile;
import com.hibernate.service.PostFileService;
import java.net.URI;
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
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
@RequestMapping("/user/posts")
public class PostFileController {
    private final PostFileService postFileService;

    @GetMapping("/{postId}/files")
    public String listFiles(
            @PathVariable Integer postId,
            HttpSession session,
            Model model) {
        Long userId = (Long) session.getAttribute("userId");

        if (userId == null) {
            return "redirect:/login";
        }

        if (!postFileService.isPostOwner(postId, userId)) {
            return "redirect:/user/posts";
        }

        model.addAttribute("postId", postId);
        model.addAttribute("postFiles", postFileService.getFilesByPostId(postId));
        return "user/post/files";
    }

    @PostMapping("/{postId}/files/upload")
    public String uploadFile(
            @PathVariable Integer postId,
            @RequestParam("file") MultipartFile file,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");

        if (userId == null) {
            return "redirect:/login";
        }

        if (!postFileService.isPostOwner(postId, userId)) {
            return "redirect:/user/posts";
        }

        try {
            postFileService.uploadFile(postId, file);
            redirectAttributes.addFlashAttribute("successMessage", "File uploaded successfully.");
        } catch (IllegalArgumentException | IllegalStateException exception) {
            redirectAttributes.addFlashAttribute("errorMessage", exception.getMessage());
        } catch (Exception exception) {
            redirectAttributes.addFlashAttribute("errorMessage", "Unable to upload the file.");
        }

        return "redirect:/user/posts/" + postId + "/files";
    }

    @GetMapping("/{postId}/files/{fileId}")
    public ResponseEntity<?> viewFile(
            @PathVariable Integer postId,
            @PathVariable Integer fileId,
            HttpSession session,
            HttpServletRequest request) {
        Long userId = (Long) session.getAttribute("userId");

        if (userId == null) {
            return redirect(request, "/login");
        }

        if (!postFileService.isPostOwner(postId, userId)) {
            return redirect(request, "/user/posts");
        }

        PostFile postFile = postFileService.getFile(postId, fileId).orElse(null);
        if (postFile == null) {
            return ResponseEntity.notFound().build();
        }

        try {
            Path filePath = postFileService.resolveFile(postFile);
            if (!Files.exists(filePath) || !Files.isRegularFile(filePath)) {
                return ResponseEntity.notFound().build();
            }

            Resource resource = new UrlResource(filePath.toUri());
            MediaType mediaType = MediaType.parseMediaType(postFile.getFileType());
            ContentDisposition disposition = ContentDisposition.inline()
                    .filename(postFile.getFileName(), StandardCharsets.UTF_8)
                    .build();

            return ResponseEntity.ok()
                    .contentType(mediaType)
                    .header(HttpHeaders.CONTENT_DISPOSITION, disposition.toString())
                    .body(resource);
        } catch (Exception exception) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    private ResponseEntity<Void> redirect(HttpServletRequest request, String path) {
        return ResponseEntity.status(HttpStatus.FOUND)
                .location(URI.create(request.getContextPath() + path))
                .build();
    }
}
