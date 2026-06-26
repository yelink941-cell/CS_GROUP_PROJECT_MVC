package com.hibernate.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.hibernate.dto.ChatRoomView;
import com.hibernate.entity.Conversation;
import com.hibernate.entity.User;
import com.hibernate.repository.UserRepository;
import com.hibernate.service.ChatService;

@Controller
@RequestMapping("/chat")
public class ChatPageController {

    private final ChatService chatService;
    private final UserRepository userRepository;

    public ChatPageController(ChatService chatService, UserRepository userRepository) {
        this.chatService = chatService;
        this.userRepository = userRepository;
    }

    @GetMapping
    public String showChatDashboard(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        model.addAttribute("inboxItems", chatService.getInbox(currentUser.getId()));
        model.addAttribute("currentUser", currentUser);
        return "chat/chat";
    }

    @GetMapping("/room")
    public String showChatRoom(@RequestParam("id") Long conversationId, HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        ChatRoomView roomView = chatService.getRoomView(conversationId, currentUser.getId());
        if (roomView == null) {
            return "redirect:/chat";
        }

        model.addAttribute("conversationId", roomView.getConversationId());
        model.addAttribute("conversationTitle", roomView.getTitle());
        model.addAttribute("partnerRole", roomView.getPartnerRole());
        model.addAttribute("isGroup", roomView.isGroup());
        model.addAttribute("currentUser", currentUser);
        return "chat/room";
    }

    @GetMapping("/create-group")
    public String showCreateGroupForm(HttpSession session) {
        if (session.getAttribute("currentUser") == null) {
            return "redirect:/login";
        }
        return "chat/create-group";
    }

    @PostMapping("/create-group")
    public String createGroupChat(@RequestParam("title") String title,
                                  @RequestParam("usernames") String usernames,
                                  HttpSession session,
                                  Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        String groupTitle = title.trim();
        if (groupTitle.isEmpty()) {
            model.addAttribute("error", "Group အမည် ထည့်ပေးပါ။");
            return "chat/create-group";
        }

        List<String> usernameList = Arrays.stream(usernames.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .distinct()
                .collect(Collectors.toList());

        if (usernameList.isEmpty()) {
            model.addAttribute("error", "အနည်းဆုံး member username တစ်ယောက်ထည့်ပါ။");
            return "chat/create-group";
        }

        List<Long> memberIds = new ArrayList<>();
        for (String name : usernameList) {
            Optional<User> user = userRepository.findByUsername(name);
            if (user.isEmpty()) {
                model.addAttribute("error", "Username '" + name + "' ကို ရှာမတွေ့ပါ။");
                return "chat/create-group";
            }
            if (!user.get().getId().equals(currentUser.getId())) {
                memberIds.add(user.get().getId());
            }
        }

        if (memberIds.isEmpty()) {
            model.addAttribute("error", "Group တွင် အခြား member အနည်းဆုံး ၁ ယောက် လိုအပ်ပါသည်။");
            return "chat/create-group";
        }

        Conversation group = chatService.createConversation(
                groupTitle,
                true,
                memberIds,
                currentUser.getId()
        );

        return "redirect:/chat/room?id=" + group.getId();
    }
}
