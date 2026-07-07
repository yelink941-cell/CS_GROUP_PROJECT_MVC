package com.hibernate.controller;

import com.hibernate.entity.User;
import com.hibernate.entity.enums.Role;
import com.hibernate.service.ChatService;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin/chat")
public class AdminChatController {

    private final ChatService chatService;

    public AdminChatController(ChatService chatService) {
        this.chatService = chatService;
    }

    @GetMapping
    public String showAdminChat(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != Role.ADMIN) {
            return "redirect:/login";
        }

        model.addAttribute("inboxItems", chatService.getInbox(currentUser.getId()));
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("activeTab", "chat");
        return "admin/chat";
    }
}
