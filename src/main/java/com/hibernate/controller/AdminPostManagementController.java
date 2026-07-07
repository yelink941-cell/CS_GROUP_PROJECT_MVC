package com.hibernate.controller;

import com.hibernate.entity.Post;
import com.hibernate.entity.User;
import com.hibernate.entity.enums.Role;
import com.hibernate.service.AdminPostManagementService;
import com.hibernate.service.PostContentService;
import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/posts")
public class AdminPostManagementController {
    private final AdminPostManagementService adminPostManagementService;
    private final PostContentService postContentService;
    private final com.hibernate.service.CommentService commentService;
    private final com.hibernate.service.PostLikeService postLikeService;
    private final com.hibernate.service.BookmarkService bookmarkService;
    private final com.hibernate.service.RatingService ratingService;

    @GetMapping
    public String listPosts(Model model, HttpSession session) {
        User admin = getAdminUser(session);
        if (admin == null) {
            return redirectForUnauthorized(session);
        }

        model.addAttribute("posts", adminPostManagementService.getAllPosts());
        return "admin/posts/manage-list";
    }

    @GetMapping("/view/{id}")
    public String viewPost(@PathVariable Integer id, Model model, HttpSession session) {
        User admin = getAdminUser(session);
        if (admin == null) {
            return redirectForUnauthorized(session);
        }

        Post post = adminPostManagementService.getPostDetail(id);
        model.addAttribute("post", post);
        model.addAttribute("contents", postContentService.getContentsByPostId(id));

        // Populate rating, like, and comment stats for the preview page
        double avgRating = ratingService.getAverageRating(id);
        model.addAttribute("averageRating", Math.round(avgRating * 10.0) / 10.0);
        model.addAttribute("totalRatings", ratingService.getRatingCount(id));
        model.addAttribute("likeCount", postLikeService.getLikeCount(id));
        model.addAttribute("totalBookmarks", bookmarkService.getBookmarkCount(id));
        model.addAttribute("comments", commentService.getActiveParentComments(id));
        model.addAttribute("totalComments", commentService.getTotalActiveComments(id));

        return "admin/posts/detail-preview";
    }

    @PostMapping("/{id}/archive")
    public String archivePost(@PathVariable Integer id, HttpSession session, RedirectAttributes redirectAttributes) {
        User admin = getAdminUser(session);
        if (admin == null) {
            return redirectForUnauthorized(session);
        }

        try {
            adminPostManagementService.archivePost(id, admin);
            redirectAttributes.addFlashAttribute("successMessage", "Post archived successfully.");
        } catch (IllegalStateException exception) {
            redirectAttributes.addFlashAttribute("errorMessage", exception.getMessage());
        }
        return "redirect:/admin/posts";
    }

    @PostMapping("/{id}/restore")
    public String restorePost(@PathVariable Integer id, HttpSession session, RedirectAttributes redirectAttributes) {
        User admin = getAdminUser(session);
        if (admin == null) {
            return redirectForUnauthorized(session);
        }

        try {
            adminPostManagementService.restorePost(id, admin);
            redirectAttributes.addFlashAttribute("successMessage", "Post restored successfully.");
        } catch (IllegalStateException exception) {
            redirectAttributes.addFlashAttribute("errorMessage", exception.getMessage());
        }
        return "redirect:/admin/posts";
    }

    @PostMapping("/{id}/remove")
    public String removePost(
            @PathVariable Integer id,
            @RequestParam("reason") String reason,
            @RequestParam(value = "customReason", required = false) String customReason,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        User admin = getAdminUser(session);
        if (admin == null) {
            return redirectForUnauthorized(session);
        }

        String finalReason = "Other".equals(reason) ? customReason : reason;
        try {
            adminPostManagementService.removePost(id, finalReason, admin);
            redirectAttributes.addFlashAttribute("successMessage", "Post removed successfully.");
        } catch (IllegalStateException | IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("errorMessage", exception.getMessage());
        }

        return "redirect:/admin/posts";
    }

    @PostMapping("/{id}/permanent-delete")
    public String permanentlyDeletePost(
            @PathVariable Integer id,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        User admin = getAdminUser(session);
        if (admin == null) {
            return redirectForUnauthorized(session);
        }

        try {
            adminPostManagementService.permanentlyDeleteUserDeletedPost(id, admin);
            redirectAttributes.addFlashAttribute("successMessage", "Post permanently deleted successfully.");
        } catch (IllegalStateException | IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("errorMessage", exception.getMessage());
        }

        return "redirect:/admin/posts";
    }

    private User getAdminUser(HttpSession session) {
        User user = getCurrentUser(session);
        if (user == null) {
            return null;
        }

        return Role.ADMIN.equals(user.getRole()) || Role.SUPER_ADMIN.equals(user.getRole()) ? user : null;
    }

    private User getCurrentUser(HttpSession session) {
        Object currentUser = session.getAttribute("currentUser");
        if (currentUser instanceof User) {
            return (User) currentUser;
        }

        Object user = session.getAttribute("user");
        return user instanceof User ? (User) user : null;
    }

    private String redirectForUnauthorized(HttpSession session) {
        return getCurrentUser(session) == null ? "redirect:/login" : "redirect:/";
    }
}
