package com.hibernate.controller;

import com.hibernate.entity.User;
import com.hibernate.service.ReportService;
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
@RequestMapping("/admin/reports")
public class AdminReportController {

    private final ReportService reportService;

    private boolean isAuthorizedAdmin(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        return currentUser != null && currentUser.isAdmin();
    }

    @GetMapping
    public String viewReports(Model model, HttpSession session) {
        if (!isAuthorizedAdmin(session)) {
            return "redirect:/login";
        }

        model.addAttribute("postReports", reportService.getAllPendingPostReports());
        model.addAttribute("commentReports", reportService.getAllPendingCommentReports());
        model.addAttribute("activeTab", "reports");
        return "admin/reports";
    }

    @PostMapping("/posts/{id}/dismiss")
    public String dismissPostReport(@PathVariable("id") Integer id, HttpSession session) {
        if (!isAuthorizedAdmin(session)) {
            return "redirect:/login";
        }

        User admin = (User) session.getAttribute("currentUser");
        reportService.dismissPostReport(admin.getId(), id);
        return "redirect:/admin/reports";
    }

    @PostMapping("/posts/{id}/resolve")
    public String resolvePostReport(@PathVariable("id") Integer id,
                                    @RequestParam(value = "reason", required = false, defaultValue = "Violated terms") String reason,
                                    HttpSession session) {
        if (!isAuthorizedAdmin(session)) {
            return "redirect:/login";
        }

        User admin = (User) session.getAttribute("currentUser");
        reportService.resolvePostReport(admin.getId(), id, reason);
        return "redirect:/admin/reports";
    }

    @PostMapping("/comments/{id}/dismiss")
    public String dismissCommentReport(@PathVariable("id") Integer id, HttpSession session) {
        if (!isAuthorizedAdmin(session)) {
            return "redirect:/login";
        }

        User admin = (User) session.getAttribute("currentUser");
        reportService.dismissCommentReport(admin.getId(), id);
        return "redirect:/admin/reports";
    }

    @PostMapping("/comments/{id}/resolve")
    public String resolveCommentReport(@PathVariable("id") Integer id,
                                       @RequestParam(value = "reason", required = false, defaultValue = "Violated terms") String reason,
                                       HttpSession session) {
        if (!isAuthorizedAdmin(session)) {
            return "redirect:/login";
        }

        User admin = (User) session.getAttribute("currentUser");
        reportService.resolveCommentReport(admin.getId(), id, reason);
        return "redirect:/admin/reports";
    }
}
