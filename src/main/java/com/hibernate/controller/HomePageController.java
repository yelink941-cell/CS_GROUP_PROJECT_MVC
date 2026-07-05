package com.hibernate.controller;

import com.hibernate.entity.Post;
import com.hibernate.entity.User;
import com.hibernate.service.BookmarkService;
import com.hibernate.service.CategoryService;
import com.hibernate.service.CollectionService;
import com.hibernate.service.CommentService;
import com.hibernate.service.PostContentService;
import com.hibernate.service.PostLikeService;
import com.hibernate.service.PostService;
import com.hibernate.service.PostViewService;
import com.hibernate.service.RatingService;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

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
    private final RatingService ratingService;

    @GetMapping("/")
    public String homePage(Model model, HttpSession session) {
        model.addAttribute("categorySummaries", postService.getPublishedPublicPostCountsByCategory());
        model.addAttribute("popularPosts", postService.getPopularPublishedPublicPosts(HOME_POST_LIMIT));
        model.addAttribute("trendingPosts", postService.getTrendingPublishedPublicPosts(HOME_POST_LIMIT, TRENDING_DAYS));
        model.addAttribute("newPosts", postService.getNewestPublishedPublicPosts(HOME_POST_LIMIT));

        User currentUser = getCurrentUser(session);
        if (currentUser != null) {
            model.addAttribute("currentUser", currentUser);
            model.addAttribute("user", currentUser);
        }

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
                    postViewService.recordView(post, userId, request, response);

                    model.addAttribute("post", post);
                    model.addAttribute("contents", postContentService.getContentsByPostId(post.getId()));
                    model.addAttribute("currentPostSlug", slug);
                    model.addAttribute("comments", commentService.getActiveParentComments(post.getId()));
                    model.addAttribute("totalComments", commentService.getTotalActiveComments(post.getId()));
                    model.addAttribute("likeCount", postLikeService.getLikeCount(post.getId()));
                    model.addAttribute("averageRating", ratingService.getAverageRating(post.getId()));
                    model.addAttribute("totalRatings", ratingService.getRatingCount(post.getId()));

                    if (userId != null) {
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

    private Long getViewerUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }

        Object userId = session.getAttribute("userId");
        if (userId instanceof Number) {
            return ((Number) userId).longValue();
        }

        User currentUser = getCurrentUser(session);
        if (currentUser != null) {
            session.setAttribute("userId", currentUser.getId());
            return currentUser.getId();
        }

        return null;
    }

    private User getCurrentUser(HttpSession session) {
        if (session == null) {
            return null;
        }

        Object currentUser = session.getAttribute("currentUser");
        if (currentUser instanceof User) {
            return (User) currentUser;
        }

        Object user = session.getAttribute("user");
        return user instanceof User ? (User) user : null;
    }
}
