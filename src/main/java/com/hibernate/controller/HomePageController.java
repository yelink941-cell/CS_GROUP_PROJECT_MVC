package com.hibernate.controller;

import com.hibernate.entity.Post;
import com.hibernate.entity.PostFile;
import com.hibernate.service.BookmarkService;
import com.hibernate.service.CollectionService;
import com.hibernate.service.CommentService;
import com.hibernate.service.PostContentService;
import com.hibernate.service.PostFileService;
import com.hibernate.service.PostLikeService;
import com.hibernate.service.PostService;
import com.hibernate.service.RatingService;
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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.ui.Model;

@Controller
@RequiredArgsConstructor
public class HomePageController {
    private final PostService postService;
    private final PostFileService postFileService;
    private final CollectionService collectionService; 
    private final PostContentService postContentService;
    private final CommentService commentService;
    private final PostLikeService postLikeService;
    private final BookmarkService bookmarkService;
    private final RatingService ratingService;

    @GetMapping("/")
    public String homePage(Model model, HttpSession session) {
        model.addAttribute("posts", postService.getPublishedPublicPosts());

        Object currentUser = session.getAttribute("currentUser");
        if (currentUser == null) {
            currentUser = session.getAttribute("user");
        }
        if (currentUser != null) {
            model.addAttribute("currentUser", currentUser);
            model.addAttribute("user", currentUser);
        }
        return "index";
    }

    @GetMapping("/posts/public/details")
    public String publicPostDetails(@RequestParam("slug") String slug, Model model, HttpSession session) {
        return publicPostDetailsBySlug(slug, model, session);
    }

    @GetMapping("/posts/{slug}")
    public String publicPostDetailsBySlug(@PathVariable String slug, Model model, HttpSession session) {
        return postService.getPostBySlug(slug)
                .map(post -> {
                    model.addAttribute("post", post);
                 // PostContentService (စာလုံးအကြီး) နေရာတွင် postContentService (စာလုံးအသေး) ကို သုံးပါ
                    model.addAttribute("contents", postContentService.getContentsByPostId(post.getId()));
                    model.addAttribute("postFiles", postFileService.getFilesByPostId(post.getId()));

                    model.addAttribute("currentPostSlug", slug);

                    // 🟢 userId ကို session ထဲကနေ ထုတ်ယူပြီး fallback လုပ်ပေးခြင်း
                    Long userId = (Long) session.getAttribute("userId");

                    if (userId == null) {
                        com.hibernate.entity.User sessionUser = (com.hibernate.entity.User) session.getAttribute("user");
                        if (sessionUser == null) {
                            sessionUser = (com.hibernate.entity.User) session.getAttribute("currentUser");
                        }

                        if (sessionUser != null) {
                            userId = Long.valueOf(sessionUser.getId());
                            session.setAttribute("userId", userId);
                        }
                    }

                    // 🟢 Comments (parent + nested replies) - comment box ပေါ်ရန် လိုအပ်ပါသည်
                    model.addAttribute("comments", commentService.getActiveParentComments(post.getId()));
                    model.addAttribute("totalComments", commentService.getTotalActiveComments(post.getId()));

                    // 🟢 Like count
                    model.addAttribute("likeCount", postLikeService.getLikeCount(post.getId()));

                    // 🟢 Rating data
                    model.addAttribute("averageRating", ratingService.getAverageRating(post.getId()));
                    model.addAttribute("totalRatings", ratingService.getRatingCount(post.getId()));

                    if (userId != null) {
                        // 🟢 Logged-in user ၏ state များ - comment box / rating stars / button color အတွက်
                        model.addAttribute("userLoggedIn", userId);
                        model.addAttribute("collections", collectionService.getCollectionsByUserId(userId));
                        model.addAttribute("hasUserLiked", postLikeService.hasUserLiked(post.getId(), userId));
                        model.addAttribute("hasUserBookmarked", bookmarkService.hasUserBookmarked(userId, post.getId()));
                        model.addAttribute("userRating", ratingService.getUserRating(post.getId(), userId));
                    }

                    return "public/post/details";
                })
                .orElse("redirect:/posts/public");
    }

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