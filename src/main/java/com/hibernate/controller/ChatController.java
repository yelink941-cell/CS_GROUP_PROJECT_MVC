package com.hibernate.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.hibernate.dto.ConversationRequest;
import com.hibernate.dto.MessageRequest;
import com.hibernate.dto.MessageResponse;
import com.hibernate.entity.Conversation;
import com.hibernate.entity.Message;
import com.hibernate.entity.User;
import com.hibernate.service.ChatService;
import com.hibernate.service.MessageMapper;

@RestController
@RequestMapping("/api/chat") //ki
public class ChatController {

    private final ChatService chatService;

    public ChatController(ChatService chatService) {
        this.chatService = chatService;
    }

    @GetMapping("/inbox")
    public ResponseEntity<?> getInbox(HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) {
            return unauthorized();
        }
        return ResponseEntity.ok(chatService.getInbox(currentUser.getId()));
    }

    @GetMapping("/users/search")
    public ResponseEntity<?> searchUsers(@RequestParam("q") String keyword, HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) {
            return unauthorized();
        }
        return ResponseEntity.ok(chatService.searchUsers(keyword, currentUser.getId()));
    }

    @PostMapping("/start")
    public ResponseEntity<?> startDirectChat(@RequestParam Long userId, HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) {
            return unauthorized();
        }

        try {
            Conversation conversation = chatService.startDirectChat(currentUser.getId(), userId);
            Map<String, Object> body = new HashMap<>();
            body.put("conversationId", conversation.getId());
            return ResponseEntity.ok(body);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @PostMapping("/conversations")
    public ResponseEntity<?> createConversation(@RequestBody ConversationRequest request, HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) {
            return unauthorized();
        }

        try {
            Conversation conversation = chatService.createConversation(
                    request.getTitle(),
                    request.isGroup(),
                    request.getUserIds(),
                    currentUser.getId()
            );
            return ResponseEntity.status(HttpStatus.CREATED).body(conversation);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @PostMapping("/messages")
    public ResponseEntity<?> sendMessage(@RequestBody MessageRequest request, HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) {
            return unauthorized();
        }

        try {
            Message message = chatService.sendMessage(
                    request.getConversationId(),
                    currentUser.getId(),
                    request.getText()
            );
            return ResponseEntity.ok(MessageMapper.toResponse(message));
        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @PostMapping("/messages/media")
    public ResponseEntity<?> sendMediaMessage(
            @RequestParam Long conversationId,
            @RequestParam(required = false) String caption,
            @RequestParam("file") MultipartFile file,
            HttpSession session) {

        User currentUser = requireUser(session);
        if (currentUser == null) {
            return unauthorized();
        }

        try {
            Message message = chatService.sendMediaMessage(
                    conversationId,
                    currentUser.getId(),
                    file,
                    caption
            );
            return ResponseEntity.ok(MessageMapper.toResponse(message));
        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @GetMapping("/history")
    public ResponseEntity<?> getChatHistory(
            @RequestParam Long conversationId,
            @RequestParam(required = false, defaultValue = "9223372036854775807") Long lastMessageId,
            HttpSession session) {

        User currentUser = requireUser(session);
        if (currentUser == null) {
            return unauthorized();
        }

        try {
            List<Message> history = chatService.getChatHistory(conversationId, currentUser.getId(), lastMessageId);
            List<MessageResponse> responses = history.stream()
                    .map(MessageMapper::toResponse)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(responses);
        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
    }

    private User requireUser(HttpSession session) {
        return (User) session.getAttribute("currentUser");
    }

    private ResponseEntity<?> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Login ဝင်ပါ။");
    }
}
