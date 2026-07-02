package com.hibernate.controller;

import com.hibernate.service.AdminCommentService; // 🟢 အမှန်ပြင်ဆင်ထားသော import
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.servlet.http.HttpSession;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminCommentController {

    private final AdminCommentService adminCommentService; // 🟢 Type အမှန်

    @GetMapping("/comments")
    public String manageComments(Model model, HttpSession session) {
        // Admin Role စစ်ဆေးခြင်း
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            return "redirect:/login";
        }

        // 🟢 Method အမှန်ကို လှမ်းခေါ်ခြင်း
        model.addAttribute("comments", adminCommentService.getAllComments());
        model.addAttribute("activeTab", "comments");
        return "admin/posts/moderation-panel";
    }

    @GetMapping("/comments/delete/{id}")
    public String deleteComment(@PathVariable Integer id, HttpSession session) {
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            return "redirect:/login";
        }

        adminCommentService.deleteComment(id);
        return "redirect:/admin/comments";
    }
    
    
}