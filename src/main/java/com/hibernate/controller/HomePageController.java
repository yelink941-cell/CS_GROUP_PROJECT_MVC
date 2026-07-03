package com.hibernate.controller;

import com.hibernate.entity.Post;
import com.hibernate.entity.PostFile;
import com.hibernate.service.BookmarkService;
import com.hibernate.service.CollectionService; // 🎯 Added import for CollectionService
import com.hibernate.service.CommentService;
import com.hibernate.service.PostContentService;
import com.hibernate.service.PostFileService;
import com.hibernate.service.PostLikeService;
import com.hibernate.service.PostService;
import com.hibernate.service.UserService;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
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
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
public class HomePageController {
    private final PostService postService;
    private final PostContentService postContentService;
    private final PostFileService postFileService;
    private final CollectionService collectionService; 
    private final PostContentService postContentService;
    private final CommentService commentService;
    private final PostLikeService postLikeService;
    private final BookmarkService bookmarkService;
     private final UserService userService; 

    // =========================================================
    // 1. HOME PAGE (index)
    // =========================================================
    @GetMapping("/")
    public String home(HttpSession session, Model model) {
        // Statistics တွေအတွက်
        long totalPosts = postService.countAllPosts();
        long totalCollections = collectionService.countAllCollections();
        
        // Model ထဲထည့်
        model.addAttribute("totalPosts", totalPosts);
        model.addAttribute("totalCollections", totalCollections);
        
        return "index"; 
    }

    // =========================================================
    // 2. POST DETAILS (by slug)
    // =========================================================
    @GetMapping("/posts/public/details")
    public String publicPostDetails(@RequestParam("slug") String slug, Model model, HttpSession session) {
        return publicPostDetailsBySlug(slug, model, session);
    }

    @GetMapping("/posts/{slug}")
    public String publicPostDetailsBySlug(@PathVariable String slug, Model model, HttpSession session) {
        return postService.getPostBySlug(slug)
                .map(post -> {
                    model.addAttribute("post", post);
                    model.addAttribute("contents", postContentService.getContentsByPostId(post.getId()));
                    model.addAttribute("postFiles", postFileService.getFilesByPostId(post.getId()));
                    model.addAttribute("currentPostSlug", slug); 
                    
                    Long userId = (Long) session.getAttribute("userId");
                    if (userId != null) {
                        model.addAttribute("collections", collectionService.getCollectionsByUserId(userId));
                        model.addAttribute("hasUserLiked", postLikeService.hasUserLiked(post.getId(), userId));
                        model.addAttribute("hasUserBookmarked", bookmarkService.hasUserBookmarked(userId, post.getId()));
                    }

                    model.addAttribute("likeCount", postLikeService.getLikeCount(post.getId()));
                    model.addAttribute("comments", commentService.getActiveParentComments(post.getId()));
                    
                    return "public/post/details";
                })
                .orElse("redirect:/posts/public");
    }

    // =========================================================
    // 3. VIEW FILE
    // =========================================================
    @GetMapping("/posts/{slug}/files/{fileId}")
    public ResponseEntity<?> viewPublicFile(
            @PathVariable String slug,
            @PathVariable Integer fileId) {
        Post post = postService.getPostBySlug(slug).orElse(null);
        if (post == null) {
            return ResponseEntity.notFound().build();
        }

        PostFile postFile = postFileService.getFile(post.getId(), fileId).orElse(null);
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

    
}