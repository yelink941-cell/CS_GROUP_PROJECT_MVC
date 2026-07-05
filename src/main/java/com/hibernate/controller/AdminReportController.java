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
    public String viewReports(@RequestParam(value = "type", defaultValue = "posts") String type,
                              @RequestParam(value = "view", defaultValue = "queue") String view,
                              Model model,
                              HttpSession session) {
        if (!isAuthorizedAdmin(session)) {
            return "redirect:/login";
        }

        if (!"comments".equals(type)) {
            type = "posts";
        }

        if ("comments".equals(type)) {
            if ("history".equals(view)) {
                model.addAttribute("commentReports", reportService.getAllCommentReportHistory());
            } else {
                model.addAttribute("groupedCommentReports", reportService.getGroupedPendingCommentReports());
            }
        } else {
            if ("history".equals(view)) {
                model.addAttribute("postReports", reportService.getAllPostReportHistory());
            } else {
                model.addAttribute("groupedPostReports", reportService.getGroupedPendingPostReports());
            }
        }

        model.addAttribute("reportType", type);
        model.addAttribute("reportView", view);
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
        return "redirect:/admin/reports?type=posts&view=queue";
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
        return "redirect:/admin/reports?type=posts&view=queue";
    }

    @PostMapping("/posts/group/{postId}/dismiss")
    public String dismissGroupedPostReport(@PathVariable("postId") Integer postId, HttpSession session) {
        if (!isAuthorizedAdmin(session)) {
            return "redirect:/login";
        }

        User admin = (User) session.getAttribute("currentUser");
        reportService.dismissAllPostReportsByPostId(admin.getId(), postId);
        return "redirect:/admin/reports?type=posts&view=queue";
    }

    @PostMapping("/posts/group/{postId}/resolve")
    public String resolveGroupedPostReport(@PathVariable("postId") Integer postId,
                                           @RequestParam(value = "reason", required = false, defaultValue = "Violated terms") String reason,
                                           @RequestParam(value = "duration", required = false, defaultValue = "1_WEEK") String duration,
                                           @RequestParam(value = "banType", required = false, defaultValue = "POST_ONLY") String banType,
                                           HttpSession session) {
        if (!isAuthorizedAdmin(session)) {
            return "redirect:/login";
        }

        User admin = (User) session.getAttribute("currentUser");
        reportService.resolveAllPostReportsByPostId(admin.getId(), postId, reason, duration, banType);
        return "redirect:/admin/reports?type=posts&view=history";
    }

    @PostMapping("/comments/{id}/dismiss")
    public String dismissCommentReport(@PathVariable("id") Integer id, HttpSession session) {
        if (!isAuthorizedAdmin(session)) {
            return "redirect:/login";
        }

        User admin = (User) session.getAttribute("currentUser");
        reportService.dismissCommentReport(admin.getId(), id);
        return "redirect:/admin/reports?type=comments&view=queue";
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
        return "redirect:/admin/reports?type=comments&view=history";
    }

    @PostMapping("/comments/group/{commentId}/dismiss")
    public String dismissGroupedCommentReport(@PathVariable("commentId") Integer commentId, HttpSession session) {
        if (!isAuthorizedAdmin(session)) {
            return "redirect:/login";
        }

        User admin = (User) session.getAttribute("currentUser");
        reportService.dismissAllCommentReportsByCommentId(admin.getId(), commentId);
        return "redirect:/admin/reports?type=comments&view=queue";
    }

    @PostMapping("/comments/group/{commentId}/resolve")
    public String resolveGroupedCommentReport(@PathVariable("commentId") Integer commentId,
                                              @RequestParam(value = "reason", required = false, defaultValue = "Violated terms") String reason,
                                              @RequestParam(value = "duration", required = false, defaultValue = "1_WEEK") String duration,
                                              @RequestParam(value = "banType", required = false, defaultValue = "COMMENT_ONLY") String banType,
                                              HttpSession session) {
        if (!isAuthorizedAdmin(session)) {
            return "redirect:/login";
        }

        User admin = (User) session.getAttribute("currentUser");
        reportService.resolveAllCommentReportsByCommentId(admin.getId(), commentId, reason, duration, banType);
        return "redirect:/admin/reports?type=comments&view=history";
    }
}
