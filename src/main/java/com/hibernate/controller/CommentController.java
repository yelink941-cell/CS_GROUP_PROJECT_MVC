package com.hibernate.controller;

import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hibernate.entity.Comment;
import com.hibernate.entity.Post;
import com.hibernate.entity.User;
import com.hibernate.repository.CommentRepository;
import com.hibernate.repository.UserRepository;
import com.hibernate.service.CommentService;
import com.hibernate.service.PostService;

@Controller
@RequestMapping("/comments")
@RequiredArgsConstructor
public class CommentController {

    private final PostService postService;
    private final UserRepository userRepository;
    private final CommentRepository commentRepository;
    private final CommentService commentService;

    @PostMapping({"/add", "/comment"})
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addComment(@RequestParam("postId") Integer postId,
                                                          @RequestParam("commentText") String content,
                                                          HttpSession session) {

        Object sessionUserId = session.getAttribute("userId");
        Long userId = null;
        if (sessionUserId instanceof Number) {
            userId = ((Number) sessionUserId).longValue();
        } else if (sessionUserId != null) {
            userId = Long.valueOf(sessionUserId.toString());
        }

        // Fallback Logic
        if (userId == null) {
            com.hibernate.entity.User sessionUser = (com.hibernate.entity.User) session.getAttribute("user");
            if (sessionUser == null) {
                sessionUser = (com.hibernate.entity.User) session.getAttribute("currentUser");
            }
            if (sessionUser != null) {
                userId = Long.valueOf(sessionUser.getId());
                session.setAttribute("userId", userId);
            }
        }

        Map<String, Object> response = new HashMap<>();

        if (userId == null) {
            response.put("status", "error");
            response.put("message", "Login ဝင်ရန်လိုအပ်ပါသည်။");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        if (content == null || content.trim().isEmpty()) {
            response.put("status", "error");
            response.put("message", "Comment အလွတ်ဖြစ်နေပါသည်။");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }

        Post post = postService.getPostById(postId).orElse(null);
        if (post == null) {
            response.put("status", "error");
            response.put("message", "Post မရှိတော့ပါ။");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }

        User dbUser = userRepository.findById(userId).orElse(null);
        if (dbUser == null) {
            response.put("status", "error");
            response.put("message", "User မတွေ့ပါ။");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        Comment comment = new Comment();
        comment.setContent(content);
        comment.setUser(dbUser);
        comment.setPost(post);

        commentService.saveComment(comment);

        response.put("status", "success");
        response.put("message", "Comment added successfully");
        response.put("commentId", comment.getId());
        response.put("username", dbUser.getUsername());
        response.put("content", comment.getContent());
        response.put("createdAt", comment.getCreatedAt() != null ? comment.getCreatedAt().toString() : "just now");
        response.put("isOwner", true);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/reply")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addReply(@RequestParam("postId") Integer postId,
                                                        @RequestParam(value = "parentId", required = false) Integer parentId,
                                                        @RequestParam("content") String replyContent,
                                                        HttpSession session) {

        Object sessionUserId = session.getAttribute("userId");
        Long userId = null;
        if (sessionUserId instanceof Number) {
            userId = ((Number) sessionUserId).longValue();
        } else if (sessionUserId != null) {
            userId = Long.valueOf(sessionUserId.toString());
        }
        if (userId == null) {
            com.hibernate.entity.User sessionUser = (com.hibernate.entity.User) session.getAttribute("user");
            if (sessionUser == null) {
                sessionUser = (com.hibernate.entity.User) session.getAttribute("currentUser");
            }
            if (sessionUser != null) {
                userId = Long.valueOf(sessionUser.getId());
                session.setAttribute("userId", userId);
            }
        }
        Map<String, Object> response = new HashMap<>();

        if (userId == null) {
            response.put("status", "error");
            response.put("message", "Login ဝင်ရန်လိုအပ်ပါသည်။");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        if (replyContent == null || replyContent.trim().isEmpty()) {
            response.put("status", "error");
            response.put("message", "Reply အလွတ်ဖြစ်နေပါသည်။");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }

        Post post = postService.getPostById(postId).orElse(null);
        if (post == null) {
            response.put("status", "error");
            response.put("message", "Post မတွေ့ပါ။");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }

        Comment parent = null;
        if (parentId != null) {
            parent = commentRepository.findById(parentId).orElse(null);
        }

        User dbUser = userRepository.findById(userId).orElse(null);
        if (dbUser == null) {
            response.put("status", "error");
            response.put("message", "User မတွေ့ပါ။");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        Comment reply = new Comment();
        reply.setContent(replyContent);
        reply.setPost(post);
        reply.setUser(dbUser);
        reply.setParent(parent);

        commentService.saveComment(reply);

        response.put("status", "success");
        response.put("message", "Reply added successfully");
        response.put("replyId", reply.getId());
        response.put("parentId", parentId);
        response.put("parentType", parentId != null ? "c" : null);
        response.put("username", dbUser.getUsername());
        response.put("content", reply.getContent());
        response.put("createdAt", reply.getCreatedAt() != null ? reply.getCreatedAt().toString() : "just now");
        response.put("isOwner", true);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/delete/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteComment(@PathVariable("id") Integer id, HttpSession session) {
        Object sessionUserId = session.getAttribute("userId");
        Long userId = null;
        if (sessionUserId instanceof Number) {
            userId = ((Number) sessionUserId).longValue();
        } else if (sessionUserId != null) {
            userId = Long.valueOf(sessionUserId.toString());
        }
        Map<String, Object> response = new HashMap<>();

        if (userId == null) {
            response.put("status", "error");
            response.put("message", "Unauthorized");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        Comment comment = commentRepository.findById(id).orElse(null);
        if (comment != null && comment.getUser().getId().equals(userId)) {
            commentService.deleteComment(id);
            response.put("status", "success");
            response.put("message", "Deleted successfully");
            return ResponseEntity.ok(response);
        }

        response.put("status", "error");
        response.put("message", "Forbidden");
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
    }

    @PostMapping("/report/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> reportComment(@PathVariable("id") Integer id,
                                                            @RequestParam("reason") String reason,
                                                            HttpSession session) {

        Object sessionUserId = session.getAttribute("userId");
        Long userId = null;
        if (sessionUserId instanceof Number) {
            userId = ((Number) sessionUserId).longValue();
        } else if (sessionUserId != null) {
            userId = Long.valueOf(sessionUserId.toString());
        }
        Map<String, Object> response = new HashMap<>();

        if (userId == null) {
            response.put("status", "error");
            response.put("message", "Login ဝင်ရန်လိုအပ်ပါသည်။");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        Comment comment = commentRepository.findById(id).orElse(null);
        if (comment != null) {
            comment.setIsReported(true);
            comment.setReportReason(reason);

            commentService.saveComment(comment);

            response.put("status", "success");
            response.put("message", "Comment reported successfully");
            return ResponseEntity.ok(response);
        }

        response.put("status", "error");
        response.put("message", "Comment မတွေ့ပါ။");
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
    }
}