package com.hibernate.controller;

import com.hibernate.entity.Announcement;
import com.hibernate.entity.User;
import com.hibernate.service.AnnouncementService;
import java.util.List;
import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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
@RequestMapping("/admin/announcements")
public class AdminAnnouncementController {

    private final AnnouncementService announcementService;

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

    @GetMapping
    public String viewAnnouncements(Model model, HttpSession session) {
        User admin = getAuthorizedAdmin(session);
        if (admin == null) {
            return "redirect:/login";
        }

        List<Announcement> announcements = announcementService.getAllAnnouncements();
        model.addAttribute("announcements", announcements);
        model.addAttribute("activeTab", "announcements");
        return "admin/announcements";
    }

    @PostMapping("/broadcast")
    public String broadcastAnnouncement(
            @RequestParam("title") String title,
            @RequestParam(value = "type", defaultValue = "EVENT") String type,
            @RequestParam("content") String content,
            @RequestParam(value = "eventDate", required = false) String eventDate,
            @RequestParam(value = "actionUrl", required = false) String actionUrl,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User admin = getAuthorizedAdmin(session);
        if (admin == null) {
            return "redirect:/login";
        }

        try {
            announcementService.createAndBroadcastAnnouncement(
                    admin.getId(), title, type, content, eventDate, actionUrl);
            redirectAttributes.addFlashAttribute("successMessage", "🎉 Event Announcement broadcast successfully to all users!");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to broadcast announcement: " + e.getMessage());
        }

        return "redirect:/admin/announcements";
    }

    @PostMapping("/{id}/delete")
    public String deleteAnnouncement(
            @PathVariable("id") Integer id,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User admin = getAuthorizedAdmin(session);
        if (admin == null) {
            return "redirect:/login";
        }

        announcementService.deleteAnnouncement(id);
        redirectAttributes.addFlashAttribute("successMessage", "Announcement record deleted.");
        return "redirect:/admin/announcements";
    }
}
