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
import com.hibernate.dto.EditMessageRequest;
import com.hibernate.dto.MarkReadRequest;
import com.hibernate.dto.MarkReadResponse;
import com.hibernate.dto.MessageReportRequest;
import com.hibernate.dto.MessageRequest;
import com.hibernate.dto.MessageResponse;
import com.hibernate.dto.ReactionRequest;
import com.hibernate.dto.ChatRoomView;
import com.hibernate.entity.Conversation;
import com.hibernate.entity.Message;
import com.hibernate.entity.User;
import com.hibernate.service.ChatService;
import com.hibernate.websocket.ChatEventBroadcaster;


@RestController
@RequestMapping("/api/chat")
public class ChatController {
    private final ChatService chatService;
    private final ChatEventBroadcaster broadcaster;
    
    public ChatController(ChatService chatService,
    						ChatEventBroadcaster broadcaster) {
        this.chatService = chatService;
        this.broadcaster = broadcaster;
    	}

    @PostMapping("/messages/{messageId}/reactions")
    public ResponseEntity<?> toggleReaction(
            @PathVariable Long messageId,
            @RequestBody ReactionRequest request,
            HttpSession session) {
        
                User currentUser = requireUser(session);
        if (currentUser == null) {
            return unauthorized();
        }
        try {
            MessageResponse response = chatService.toggleReaction(messageId, currentUser.getId(), request.getEmoji());
            broadcaster.broadcastReaction(response);
            return ResponseEntity.ok(response);
        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
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
                    request.getText(),
                    request.getParentMessageId()
            );
            MessageResponse response = chatService.toMessageResponse(message);
            broadcaster.broadcastNewMessage(response);
            return ResponseEntity.ok(response);
        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
    @PutMapping("/messages/{messageId}")
    public ResponseEntity<?> editMessage(
            @PathVariable Long messageId,
            @RequestBody EditMessageRequest request,
            HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) {
            return unauthorized();
        }
        try {
            Message message = chatService.editMessage(messageId, currentUser.getId(), request.getText());
            MessageResponse response = chatService.toMessageResponse(message);
            broadcaster.broadcastEditedMessage(response);
            return ResponseEntity.ok(response);
        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
    @PostMapping("/messages/read")
    public ResponseEntity<?> markMessagesAsRead(@RequestBody MarkReadRequest request, HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) {
            return unauthorized();
        }
        try {
            MarkReadResponse response = chatService.markMessagesAsRead(
                    request.getConversationId(),
                    currentUser.getId(),
                    request.getUpToMessageId()
            );
            if (response.getMarkedCount() > 0) {
                broadcaster.broadcastReadReceipt(response);
            }
            return ResponseEntity.ok(response);
        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
    @PostMapping("/messages/{messageId}/report")
    public ResponseEntity<?> reportMessage(
            @PathVariable Long messageId,
            @RequestBody MessageReportRequest request,
           HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) {
            return unauthorized();
        }
        try {
            chatService.reportMessage(
                    messageId,
                    currentUser.getId(),
                    request.getReason(),
                    request.getDescription()
            );
            Map<String, Object> body = new HashMap<>();
            body.put("messageId", messageId);
            body.put("status", "PENDING");
            return ResponseEntity.status(HttpStatus.CREATED).body(body);
        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
    @DeleteMapping("/conversations/{conversationId}")
    public ResponseEntity<?> deleteConversation(
            @PathVariable Long conversationId,
            HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) {
            return unauthorized();
        }
        try {
            chatService.deleteConversationForUser(conversationId, currentUser.getId());
            broadcaster.broadcastConversationCleared(conversationId);
            Map<String, Object> body = new HashMap<>();
            body.put("conversationId", conversationId);
            body.put("status", "deleted");
            return ResponseEntity.ok(body);
        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
    @PostMapping("/users/{userId}/block")
    public ResponseEntity<?> blockUser(
            @PathVariable Long userId,
            HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) {
            return unauthorized();
        }
       try {
            chatService.blockUser(currentUser.getId(), userId);
            Map<String, Object> body = new HashMap<>();
            body.put("userId", userId);
            body.put("status", "blocked");
            return ResponseEntity.ok(body);
        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @PostMapping("/users/{userId}/unblock")
    public ResponseEntity<?> unblockUser(
            @PathVariable Long userId,
            HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) {
            return unauthorized();
        }
        try {
            chatService.unblockUser(currentUser.getId(), userId);
            Map<String, Object> body = new HashMap<>();
            body.put("userId", userId);
            body.put("status", "unblocked");
            return ResponseEntity.ok(body);
        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
    @DeleteMapping("/messages/{messageId}")

    public ResponseEntity<?> deleteMessage(
            @PathVariable Long messageId,
            HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) {
            return unauthorized();
        }
        try {

            Long conversationId = chatService.deleteMessage(messageId, currentUser.getId());

            Map<String, Object> body = new HashMap<>();

            body.put("messageId", messageId);

            body.put("conversationId", conversationId);

            broadcaster.broadcastDeletedMessage(conversationId, messageId);

            return ResponseEntity.ok(body);

        } catch (SecurityException e) {

            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());

        } catch (IllegalArgumentException e) {

            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());

        } catch (Exception e) {

            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());

        }

    }
    @PostMapping("/messages/media")

    public ResponseEntity<?> sendMediaMessage(

            @RequestParam Long conversationId,

            @RequestParam(required = false) String caption,

            @RequestParam("files") List<MultipartFile> files,

            HttpSession session) {



        User currentUser = requireUser(session);

        if (currentUser == null) {

            return unauthorized();

        }
        try {

            Message message = chatService.sendMediaMessage(

                    conversationId,

                    currentUser.getId(),

                    files,

                    caption

            );

            MessageResponse response = chatService.toMessageResponse(message);

            broadcaster.broadcastNewMessage(response);

            return ResponseEntity.ok(response);

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

                    .map(chatService::toMessageResponse)

                    .collect(Collectors.toList());



            if (!responses.isEmpty()) {

                Long latestId = responses.get(0).getId();

                chatService.markMessagesAsRead(conversationId, currentUser.getId(), latestId);

            }



            return ResponseEntity.ok(responses);

        } catch (SecurityException e) {

            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());

        } catch (Exception e) {

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());

        }

    }

    @GetMapping("/room/details")
    public ResponseEntity<?> getRoomDetails(@RequestParam Long conversationId, HttpSession session) {
        User currentUser = requireUser(session);
        if (currentUser == null) {
            return unauthorized();
        }
        try {
            ChatRoomView roomView = chatService.getRoomView(conversationId, currentUser.getId());
            if (roomView == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Conversation not found");
            }
            return ResponseEntity.ok(roomView);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
    }


    private User requireUser(HttpSession session) {
        return (User) session.getAttribute("currentUser");
    }



    private ResponseEntity<?> unauthorized() {

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(" Enter Login ");

    }

}

