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
    private final com.hibernate.repository.MessageSeenStatusRepository seenStatusRepository;
    private final com.hibernate.repository.UserRepository userRepository;

    @ModelAttribute
    public void addUnreadNotificationCount(HttpSession session, org.springframework.ui.Model model) {
        Object userIdObj = session.getAttribute("userId");
        Long userId = null;
        if (userIdObj instanceof Number) {
            userId = ((Number) userIdObj).longValue();
        }

        if (userId != null) {
            User dbUser = userRepository.findById(userId).orElse(null);
            if (dbUser != null) {
                // If the user has been fully banned, log them out instantly
                if (dbUser.isFullBanned()) {
                    session.invalidate();
                    org.springframework.security.core.context.SecurityContextHolder.clearContext();
                    return;
                }

                // Update session and model attributes with the fresh database state
                session.setAttribute("currentUser", dbUser);
                model.addAttribute("dbUser", dbUser);

                long totalUnread = seenStatusRepository.countTotalUnreadMessages(userId);
                model.addAttribute("totalUnreadChatCount", totalUnread);
                model.addAttribute("unreadNotificationCount", notificationService.getUnreadCount(userId));
            }
        }
    }
}
