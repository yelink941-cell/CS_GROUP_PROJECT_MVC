package com.hibernate.controller;

import com.hibernate.entity.Notification;
import com.hibernate.entity.User;
import com.hibernate.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/notifications")
public class NotificationController {

    private final NotificationService notificationService;

    private User getCurrentUser(HttpSession session) {
        return (User) session.getAttribute("currentUser");
    }

    @GetMapping
    public String listNotifications(HttpSession session, Model model) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            return "redirect:/login";
        }

        List<Notification> notifications = notificationService.getNotificationsForUser(currentUser.getId());
        model.addAttribute("notifications", notifications);
        model.addAttribute("unreadCount", notificationService.getUnreadCount(currentUser.getId()));
        return "notifications/notifications";
    }

    @PostMapping("/{id}/read")
    public String markAsRead(@PathVariable("id") Integer id, HttpSession session) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            return "redirect:/login";
        }

        notificationService.markAsRead(id, currentUser.getId());
        return "redirect:/notifications";
    }

    @PostMapping("/read-all")
    public String markAllAsRead(HttpSession session) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            return "redirect:/login";
        }

        notificationService.markAllAsRead(currentUser.getId());
        return "redirect:/notifications";
    }

    @PostMapping("/{id}/delete")
    public String deleteNotification(@PathVariable("id") Integer id, HttpSession session) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            return "redirect:/login";
        }

        notificationService.deleteNotification(id, currentUser.getId());
        return "redirect:/notifications";
    }
}
