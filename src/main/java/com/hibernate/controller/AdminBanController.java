package com.hibernate.controller;

import com.hibernate.entity.User;
import com.hibernate.service.ModerationService;
import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminBanController {

    private final ModerationService moderationService;

    private User getAuthorizedAdmin(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.isAdmin()) {
            return currentUser;
        }

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated()) {
            boolean isAdmin = auth.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equalsIgnoreCase("ROLE_ADMIN")
                            || a.getAuthority().equalsIgnoreCase("ADMIN"));
            if (isAdmin && currentUser != null) {
                return currentUser;
            }
        }
        return null;
    }

    @PostMapping("/users/{id}/ban")
    public String banUser(@PathVariable("id") Long userId,
                          @RequestParam(value = "reason", required = false, defaultValue = "Violated community guidelines") String reason,
                          @RequestParam(value = "duration", required = false, defaultValue = "PERMANENT") String duration,
                          HttpSession session,
                          RedirectAttributes redirectAttributes) {
        User admin = getAuthorizedAdmin(session);
        if (admin == null) return "redirect:/login";

        try {
            moderationService.banUser(admin.getId(), userId, reason, duration);
            redirectAttributes.addFlashAttribute("success", "User has been suspended/banned successfully.");
        } catch (SecurityException | IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to ban user: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }

    @PostMapping("/users/{id}/unban")
    public String unbanUser(@PathVariable("id") Long userId,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        User admin = getAuthorizedAdmin(session);
        if (admin == null) return "redirect:/login";

        try {
            moderationService.unbanUser(admin.getId(), userId);
            redirectAttributes.addFlashAttribute("success", "🎉 User has been unbanned and restored to ACTIVE status!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to unban user: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }

    @PostMapping("/posts/{id}/hide")
    public String hidePost(@PathVariable("id") Integer postId,
                           @RequestParam(value = "reason", required = false, defaultValue = "Content policy violation") String reason,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {
        User admin = getAuthorizedAdmin(session);
        if (admin == null) return "redirect:/login";

        try {
            moderationService.softDeletePost(admin.getId(), postId, reason);
            redirectAttributes.addFlashAttribute("success", "Post has been hidden successfully.");
        } catch (SecurityException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to hide post: " + e.getMessage());
        }
        return "redirect:/admin/reports?type=posts&view=queue";
    }

    @PostMapping("/comments/{id}/hide")
    public String hideComment(@PathVariable("id") Integer commentId,
                              @RequestParam(value = "reason", required = false, defaultValue = "Comment policy violation") String reason,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User admin = getAuthorizedAdmin(session);
        if (admin == null) return "redirect:/login";

        try {
            moderationService.softDeleteComment(admin.getId(), commentId, reason);
            redirectAttributes.addFlashAttribute("success", "Comment has been hidden successfully.");
        } catch (SecurityException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to hide comment: " + e.getMessage());
        }
        return "redirect:/admin/reports?type=comments&view=queue";
    }
}
