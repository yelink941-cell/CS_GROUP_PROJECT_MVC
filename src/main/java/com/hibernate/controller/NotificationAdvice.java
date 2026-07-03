package com.hibernate.controller;

import com.hibernate.entity.User;
import com.hibernate.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import javax.servlet.http.HttpSession;

@ControllerAdvice
@RequiredArgsConstructor
public class NotificationAdvice {

    private final NotificationService notificationService;

    @ModelAttribute
    public void addUnreadNotificationCount(HttpSession session, org.springframework.ui.Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user != null) {
            model.addAttribute("unreadNotificationCount", notificationService.getUnreadCount(user.getId()));
        }
    }
}
