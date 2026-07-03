package com.hibernate.controller;

import com.hibernate.entity.User;
import com.hibernate.entity.enums.PostStatus;
import com.hibernate.entity.enums.Role;
import com.hibernate.service.PostService;
import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/posts")
public class AdminPostApprovalController {
    private final PostService postService;

    // =========================================================
    // 1. PENDING POSTS - FIXED (with statistics)
    // =========================================================
    @GetMapping("/pending")
    public String pendingPosts(Model model, HttpSession session) {
        String redirect = validateAdmin(session);

        if (redirect != null) {
            return redirect;
        }

        // Get pending posts
        model.addAttribute("posts", postService.getPendingPosts());
        
        // ✅ Statistics for cards
        model.addAttribute("totalPending", postService.countPendingPosts());
        model.addAttribute("totalPosts", postService.countAllPosts());
        model.addAttribute("totalApproved", postService.countByStatus(PostStatus.PUBLISHED));
        model.addAttribute("totalRejected", postService.countByStatus(PostStatus.REJECTED));
        
        return "admin/posts/pending";
    }

    // =========================================================
    // 2. APPROVE POST
    // =========================================================
    @PostMapping("/approve/{id}")
    public String approvePost(@PathVariable Integer id, HttpSession session) {
        String redirect = validateAdmin(session);

        if (redirect != null) {
            return redirect;
        }

        postService.approvePost(id);
        return "redirect:/admin/posts/pending";
    }

    // =========================================================
    // 3. REJECT POST
    // =========================================================
    @PostMapping("/reject/{id}")
    public String rejectPost(
            @PathVariable Integer id,
            @RequestParam String rejectionReason,
            HttpSession session) {
        String redirect = validateAdmin(session);

        if (redirect != null) {
            return redirect;
        }

        postService.rejectPost(id, rejectionReason);
        return "redirect:/admin/posts/pending";
    }

    // =========================================================
    // 4. VALIDATE ADMIN
    // =========================================================
    private String validateAdmin(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            return "redirect:/login";
        }

        if (!Role.ADMIN.equals(currentUser.getRole())) {
            return "redirect:/";
        }

        return null;
    }
}