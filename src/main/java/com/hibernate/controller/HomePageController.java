package com.hibernate.controller;

import com.hibernate.entity.Post;
import com.hibernate.entity.User;
import com.hibernate.service.BookmarkService;
import com.hibernate.service.CategoryService;
import com.hibernate.service.CollectionService; // 🎯 Added import for CollectionService
import com.hibernate.service.CommentService;
import com.hibernate.service.PostContentService;
import com.hibernate.service.PostLikeService;
import com.hibernate.service.PostService;
import com.hibernate.service.PostViewService;
import com.hibernate.service.UserService;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; // 🎯 Session သုံးရန် Import ထည့်ပေးထားသည်
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.ui.Model;

@Controller
@RequiredArgsConstructor
public class HomePageController {
    private static final int HOME_POST_LIMIT = 6;
    private static final int TRENDING_DAYS = 30;

    private final PostService postService;
    private final CategoryService categoryService;
    private final CollectionService collectionService; 
    private final PostContentService postContentService;
    private final CommentService commentService;
    private final PostLikeService postLikeService;
    private final BookmarkService bookmarkService;
    private final PostViewService postViewService;
    private final UserService userService;
    private final com.hibernate.repository.BlockedUserRepository blockedUserRepository;

    @GetMapping("/")
    public String homePage(Model model) {
        model.addAttribute("categorySummaries", postService.getPublishedPublicPostCountsByCategory());
        model.addAttribute("popularPosts", postService.getPopularPublishedPublicPosts(HOME_POST_LIMIT));
        model.addAttribute("trendingPosts", postService.getTrendingPublishedPublicPosts(HOME_POST_LIMIT, TRENDING_DAYS));
        model.addAttribute("newPosts", postService.getNewestPublishedPublicPosts(HOME_POST_LIMIT));
        return "index";
    }

    @GetMapping({"/categories/{categoryId}", "/category/{categoryId}/posts"})
    public String categoryPosts(@PathVariable("categoryId") Integer categoryId, Model model) {
        return categoryService.getCategoryById(categoryId)
                .map(category -> {
                    model.addAttribute("posts", postService.getPostsByCategoryId(categoryId));
                    model.addAttribute("pageTitle", category.getName());
                    model.addAttribute("pageDescription", "Public cheat sheets in " + category.getName() + ".");
                    model.addAttribute("emptyMessage", "No public posts are available in this category.");
                    return "public/post/list";
                })
                .orElse("redirect:/");
    }

    @GetMapping("/posts/public/details")
    public String publicPostDetails(
            @RequestParam("slug") String slug,
            Model model,
            HttpServletRequest request,
            HttpServletResponse response) {
        return publicPostDetailsBySlug(slug, model, request, response);
    }

    @GetMapping("/posts/{slug}")
    public String publicPostDetailsBySlug(
            @PathVariable String slug,
            Model model,
            HttpServletRequest request,
            HttpServletResponse response) {
        return postService.getPostBySlug(slug)
                .map(post -> {
                    Long userId = getViewerUserId(request);
                    HttpSession session = request.getSession(false);
                    User viewer = session != null ? (User) session.getAttribute("currentUser") : null;
                    boolean isAdmin = viewer != null && viewer.isAdmin();
                    boolean isAuthor = viewer != null && post.getAuthor() != null && viewer.getId().equals(post.getAuthor().getId());

                    // If user is blocked either way by the author, hide the post
                    if (userId != null && post.getAuthor() != null && !isAdmin) {
                        if (blockedUserRepository.isBlockedEitherWay(userId, post.getAuthor().getId())) {
                            return "redirect:/posts/public";
                        }
                    }

                    // If post is deleted or banned, block normal public users, but allow admins and authors
                    if (post.isDeleted() || post.getStatus() == com.hibernate.entity.enums.PostStatus.BANNED) {
                        if (!isAdmin && !isAuthor) {
                            return "redirect:/posts/public";
                        }
                        model.addAttribute("isBannedNotice", true);
                    }

                    postViewService.recordView(post, userId, request, response);

                    model.addAttribute("post", post);
                    model.addAttribute("contents", postContentService.getContentsByPostId(post.getId()));
                    model.addAttribute("currentPostSlug", slug); 
                    
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

    private Long getViewerUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }

        Object userId = session.getAttribute("userId");
        return userId instanceof Number ? ((Number) userId).longValue() : null;
    }

}
