package com.hibernate.controller;

import com.hibernate.entity.Comment;
import com.hibernate.entity.Post;
import com.hibernate.entity.User;
import com.hibernate.repository.CommentRepository;
import com.hibernate.repository.UserRepository;
import com.hibernate.service.CommentService;
import com.hibernate.service.NotificationService;
import com.hibernate.service.PostService;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/comments")
@RequiredArgsConstructor
public class CommentController {

    @Autowired
    private PostService postService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CommentRepository commentRepository;

    @Autowired
    private CommentService commentService;

    @Autowired(required = false)
    private NotificationService notificationService;

    private User getAuthenticatedUser(HttpSession session) {
        // 1. Session attribute userId
        Object sessionUserId = session.getAttribute("userId");
        if (sessionUserId instanceof Number) {
            Long id = ((Number) sessionUserId).longValue();
            User u = userRepository.findById(id).orElse(null);
            if (u != null) return u;
        } else if (sessionUserId != null) {
            try {
                Long id = Long.valueOf(sessionUserId.toString());
                User u = userRepository.findById(id).orElse(null);
                if (u != null) return u;
            } catch (NumberFormatException ignored) {}
        }

        // 2. Session attributes user / currentUser
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null) {
            sessionUser = (User) session.getAttribute("currentUser");
        }
        if (sessionUser != null && sessionUser.getId() != null) {
            User u = userRepository.findById(sessionUser.getId()).orElse(null);
            if (u != null) return u;
        }

        // 3. Spring Security Context
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getName())) {
            String name = auth.getName();
            User u = userRepository.findByEmail(name).orElse(null);
            if (u == null) {
                u = userRepository.findByUsername(name).orElse(null);
            }
            if (u != null) {
                session.setAttribute("userId", u.getId());
                session.setAttribute("currentUser", u);
                return u;
            }
        }

        return null;
    }

    @PostMapping({"/add", "/comment"})
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addComment(@RequestParam("postId") Integer postId,
                                                          @RequestParam("commentText") String content,
                                                          HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        User dbUser = getAuthenticatedUser(session);
        if (dbUser == null) {
            response.put("status", "error");
            response.put("message", "Login ဝင်ရန်လိုအပ်ပါသည်။");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        if (dbUser.isCurrentlyBanned()) {
            response.put("status", "error");
            response.put("message", "သင်သည် အကောင့် ပိတ်ပင် (Ban) ခံထားရသောကြောင့် Comment ရေးသားခွင့် မရှိပါ။ (" + dbUser.getBanRemainingText() + ")");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
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

        try {
            Comment comment = new Comment();
            comment.setContent(content);
            comment.setUser(dbUser);
            comment.setPost(post);

            commentService.saveComment(comment);

            // Notify post author if different user
            if (notificationService != null && post.getAuthor() != null && dbUser.getId() != null && !dbUser.getId().equals(post.getAuthor().getId())) {
                try {
                    notificationService.createNotification(
                            post.getAuthor().getId(),
                            "COMMENT",
                            "💬 New comment on your post",
                            dbUser.getUsername() + " commented: \"" + content + "\"",
                            "POST",
                            post.getId()
                    );
                } catch (Exception notiEx) {
                    System.err.println("Failed to send comment notification: " + notiEx.getMessage());
                }
            }

            response.put("status", "success");
            response.put("message", "Comment added successfully");
            response.put("commentId", comment.getId());
            response.put("username", dbUser.getUsername());
            response.put("content", comment.getContent());
            response.put("createdAt", comment.getCreatedAt() != null ? comment.getCreatedAt().toString() : "just now");
            response.put("isOwner", true);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Comment မအောင်မြင်ပါ: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @PostMapping("/reply")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addReply(@RequestParam("postId") Integer postId,
                                                        @RequestParam(value = "parentId", required = false) Integer parentId,
                                                        @RequestParam("content") String replyContent,
                                                        HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        User dbUser = getAuthenticatedUser(session);
        if (dbUser == null) {
            response.put("status", "error");
            response.put("message", "Login ဝင်ရန်လိုအပ်ပါသည်။");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        if (dbUser.isCurrentlyBanned()) {
            response.put("status", "error");
            response.put("message", "သင်သည် အကောင့် ပိတ်ပင် (Ban) ခံထားရသောကြောင့် Reply ရေးသားခွင့် မရှိပါ။ (" + dbUser.getBanRemainingText() + ")");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
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

        try {
            Comment reply = new Comment();
            reply.setContent(replyContent);
            reply.setPost(post);
            reply.setUser(dbUser);
            reply.setParent(parent);

            commentService.saveComment(reply);

            // Notify parent comment author if different user
            if (notificationService != null && parent != null && parent.getUser() != null && dbUser.getId() != null && !dbUser.getId().equals(parent.getUser().getId())) {
                try {
                    notificationService.createNotification(
                            parent.getUser().getId(),
                            "COMMENT_REPLY",
                            "💬 New reply to your comment",
                            dbUser.getUsername() + " replied: \"" + replyContent + "\"",
                            "POST",
                            postId
                    );
                } catch (Exception notiEx) {
                    System.err.println("Failed to send reply notification: " + notiEx.getMessage());
                }
            }

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
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Reply မအောင်မြင်ပါ: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @PostMapping("/delete/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteComment(@PathVariable("id") Integer id, HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        User dbUser = getAuthenticatedUser(session);
        if (dbUser == null) {
            response.put("status", "error");
            response.put("message", "Unauthorized - Please login first.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        Comment comment = commentRepository.findById(id).orElse(null);
        if (comment == null) {
            response.put("status", "error");
            response.put("message", "Comment not found.");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }

        boolean isCommentOwner = comment.getUser() != null && comment.getUser().getId() != null && comment.getUser().getId().equals(dbUser.getId());
        boolean isPostOwner = comment.getPost() != null && comment.getPost().getAuthor() != null && comment.getPost().getAuthor().getId() != null && comment.getPost().getAuthor().getId().equals(dbUser.getId());
        boolean isAdmin = dbUser.isAdmin();

        if (isCommentOwner || isPostOwner || isAdmin) {
            try {
                commentService.deleteComment(id);
                response.put("status", "success");
                response.put("message", "Deleted successfully");
                return ResponseEntity.ok(response);
            } catch (Exception e) {
                e.printStackTrace();
                response.put("status", "error");
                response.put("message", "Failed to delete: " + e.getMessage());
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
            }
        }

        response.put("status", "error");
        response.put("message", "You do not have permission to delete this comment.");
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
    }

    @PostMapping("/report-comment/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> reportComment(@PathVariable("id") Integer id,
                                                            @RequestParam("reason") String reason,
                                                            HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        User dbUser = getAuthenticatedUser(session);
        if (dbUser == null) {
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