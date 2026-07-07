package com.hibernate.controller;

import com.hibernate.entity.Category;
import com.hibernate.entity.Post;
import com.hibernate.entity.Tag;
import com.hibernate.service.BookmarkService;
import com.hibernate.service.CategoryService;
import com.hibernate.service.CollectionService; // 🎯 Added import for CollectionService
import com.hibernate.service.CommentService;
import com.hibernate.service.PostContentService;
import com.hibernate.service.PostLikeService;
import com.hibernate.service.PostService;
import com.hibernate.service.PostViewService;
import com.hibernate.service.RatingService;
import com.hibernate.service.TagService;
import com.hibernate.service.UserService;

import java.util.List;
 // 🎯 Added import for HttpSession
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
@RequestMapping("/posts")
public class PublicPostController {
    private final PostService postService;
    private final CategoryService categoryService;
    private final TagService tagService;
    private final CollectionService collectionService; // 🎯 Injected CollectionService
    private final PostContentService postContentService;
    private final PostViewService postViewService;
    private final UserService userService;
    private final PostLikeService postLikeService;
    private final BookmarkService bookmarkService;
    private final RatingService ratingService;
    private final CommentService commentService;
    private final com.hibernate.repository.BlockedUserRepository blockedUserRepository;

    @GetMapping("/public")
    public String allPublicPosts(Model model, HttpSession session) {
        // 1. Fetch the list of posts once
        List<Post> posts = postService.getPublishedPublicPosts();
        
        Long userId = (Long) session.getAttribute("userId");
        if (userId != null) {
            List<Long> blockedIds = blockedUserRepository.getBlockedAndBlockerUserIds(userId);
            if (!blockedIds.isEmpty()) {
                posts = posts.stream()
                        .filter(p -> p.getAuthor() == null || !blockedIds.contains(p.getAuthor().getId()))
                        .collect(java.util.stream.Collectors.toList());
            }

            for (Post post : posts) {
                if (post.getAuthor() != null) {
                    boolean followed = userService.isFollowing(userId, post.getAuthor().getId());
                    post.setFollowedByCurrentUser(followed);
                }
            }
            model.addAttribute("userId", userId);
        }
        
        return showPosts(
                model,
                posts, 
                "All Public Posts",
                "Browse every public cheat sheet approved for publication.",
                "No public posts are available yet.");
    }

    @GetMapping("/categories")
    public String categories(Model model) {
        model.addAttribute(
                "categorySummaries",
                postService.getPublishedPublicPostCountsByCategory());
        return "public/post/categories";
    }

    @GetMapping("/categories/{categoryId}")
    public String postsByCategory(@PathVariable("categoryId") Integer categoryId, Model model) {
        Category category = categoryService.getCategoryById(categoryId).orElse(null);
        if (category == null) {
            return "redirect:/posts/categories";
        }

        return showPosts(
                model,
                postService.getPostsByCategoryId(categoryId),
                category.getName(),
                "Public cheat sheets in this category.",
                "No public posts are available in this category.");
    }

    @GetMapping("/tags")
    public String tags(Model model) {
        model.addAttribute("tagSummaries", postService.getPublishedPublicPostCountsByTag());
        return "public/post/tags";
    }

    @GetMapping("/tags/{tagId}")
    public String postsByTag(@PathVariable("tagId") Integer tagId, Model model) {
        Tag tag = tagService.getTagById(tagId).orElse(null);
        if (tag == null) {
            return "redirect:/posts/tags";
        }

        return showPosts(
                model,
                postService.getPublishedPublicPostsByTagId(tagId),
                "Tag: " + tag.getName(),
                "Public cheat sheets using this tag.",
                "No public posts are available for this tag.");
    }

    @GetMapping("/popular")
    public String popularPosts(Model model) {
        model.addAttribute("posts", postService.getPopularPublishedPublicPosts());
        return "public/post/popular";
    }

    @GetMapping("/trending")
    public String trendingPosts(Model model) {
        model.addAttribute("trendingPosts", postViewService.getTrendingPublishedPublicPosts());
        return "public/post/trending";
    }

    @GetMapping("/new")
    public String newestPosts(Model model) {
        return showPosts(
                model,
                postService.getNewestPublishedPublicPosts(),
                "New Cheat Sheets",
                "Discover the latest public cheat sheets.",
                "No new posts are available yet.");
    }

    @GetMapping("/posts/public/details-v2")
    public String legacyPublicPostDetails(
            @RequestParam("slug") String slug,
            Model model,
            HttpServletRequest request,
            HttpServletResponse response) {
        return publicPostDetails(slug, model, request, response);
    }

    @GetMapping("/public/posts/{slug}")

    public String publicPostDetails(
            @PathVariable("slug") String slug,
            Model model,
            HttpServletRequest request,
            HttpServletResponse response) {
        Long viewerUserId = getViewerUserId(request);

        return postService.getPostBySlug(slug)
                .map(post -> {
                    postViewService.recordView(post, viewerUserId, request, response);
                    model.addAttribute("post", post);
                    model.addAttribute("contents", postContentService.getContentsByPostId(post.getId()));

                    // 🟢 login ဖြစ်နေလျှင် like/bookmark/rating အခြေအနေများ ပို့ပေးပါ
                    if (viewerUserId != null) {
                        model.addAttribute("collections", collectionService.getCollectionsByUserId(viewerUserId));
                        model.addAttribute("hasUserLiked", postLikeService.hasUserLiked(post.getId(), viewerUserId));
                        model.addAttribute("hasUserBookmarked", bookmarkService.hasUserBookmarked(viewerUserId, post.getId()));

                        // 🟢 Rating data ပို့ပေးပါ
                        model.addAttribute("userRating", ratingService.getUserRating(post.getId(), viewerUserId));
                        model.addAttribute("hasUserRated", ratingService.hasUserRated(post.getId(), viewerUserId));
                    }

                    // 🟢 Count များ (login ဖြစ်ဖြစ် မဖြစ်ဖြစ် ပေါ်လာစေရန်)
                    model.addAttribute("likeCount", postLikeService.getLikeCount(post.getId()));
                    model.addAttribute("comments", commentService.getActiveParentComments(post.getId()));
                    model.addAttribute("totalComments", commentService.getTotalActiveComments(post.getId()));
                    model.addAttribute("totalBookmarks", bookmarkService.getBookmarkCount(post.getId()));

                    // 🟢 Rating count/average (login မရှိဘူးလည်း ပေးပါ)
                    model.addAttribute("averageRating", ratingService.getAverageRating(post.getId()));
                    model.addAttribute("totalRatings", ratingService.getRatingCount(post.getId()));

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

    private String showPosts(
            Model model,
            List<Post> posts,
            String pageTitle,
            String pageDescription,
            String emptyMessage) {
        model.addAttribute("posts", posts);
        model.addAttribute("pageTitle", pageTitle);
        model.addAttribute("pageDescription", pageDescription);
        model.addAttribute("emptyMessage", emptyMessage);
        return "public/post/list";
    }
}
