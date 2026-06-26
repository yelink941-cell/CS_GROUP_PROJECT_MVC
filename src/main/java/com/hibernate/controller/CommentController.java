package com.hibernate.controller;

import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.hibernate.entity.Comment;
import com.hibernate.entity.Post;
import com.hibernate.entity.User;
import com.hibernate.repository.CommentRepository;
import com.hibernate.repository.UserRepository;
import com.hibernate.service.CommentService;
import com.hibernate.service.PostService;

@Controller
@RequestMapping("/comments")
public class CommentController {

    @Autowired
    private PostService postService;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private CommentRepository commentRepository; 
    
    @Autowired
    private CommentService commentService; 

    // 🔴 AJAX ဖြင့် အလုပ်လုပ်ရန် ResponseEntity သုံးပြီး ပြင်ဆင်ထားသည် 🔴
    @PostMapping("/add")
    public ResponseEntity<String> addComment(@RequestParam("postId") Integer postId,
                                             @RequestParam("commentText") String content, // ➔ JSP ထဲရှိ name="commentText" နှင့် ကိုက်ညီစေရန် ပြောင်းသည်
                                             HttpSession session) {

        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Login ဝင်ရန်လိုအပ်ပါသည်။");
        }

        if (content == null || content.trim().isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Comment အလွတ်ဖြစ်နေပါသည်။");
        }

        Post post = postService.getPostById(postId).orElse(null);
        if (post == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Post မရှိတော့ပါ။");
        }

        User dbUser = userRepository.findById(userId).orElse(null);
        if (dbUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User မတွေ့ပါ။");
        }

        Comment comment = new Comment();
        comment.setContent(content);
        comment.setUser(dbUser);
        comment.setPost(post);

        commentService.saveComment(comment);

        // ➔ Page reload မဖြစ်စေရန် အောင်မြင်ကြောင်း JSON / String တန်ဖိုး တိုက်ရိုက်ပြန်သည်
        return ResponseEntity.ok("Comment added successfully");
    }
    
    @PostMapping("/reply")
    public ResponseEntity<String> addReply(@RequestParam("postId") Integer postId,
                                           @RequestParam(value = "parentId", required = false) Integer parentId, 
                                           @RequestParam("content") String replyContent, 
                                           HttpSession session) {

        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Login ဝင်ရန်လိုအပ်ပါသည်။");
        }

        if (replyContent == null || replyContent.trim().isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Reply အလွတ်ဖြစ်နေပါသည်။");
        }

        Post post = postService.getPostById(postId).orElse(null);
        if (post == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Post မတွေ့ပါ။");
        }
        
        Comment parent = null;
        if (parentId != null) {
            parent = commentRepository.findById(parentId).orElse(null); 
        }

        User dbUser = userRepository.findById(userId).orElse(null);
        if (dbUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User မတွေ့ပါ။");
        }

        Comment reply = new Comment();
        reply.setContent(replyContent); 
        reply.setPost(post);
        reply.setUser(dbUser); 
        reply.setParent(parent); 

        commentService.saveComment(reply);

        // AJAX ဖြင့် အလုပ်လုပ်ရန် Page Reload မလုပ်ဘဲ အောင်မြင်ကြောင်း string ပြန်သည်
        return ResponseEntity.ok("Reply added successfully");
    }
    
    @PostMapping("/delete/{id}")
    public ResponseEntity<String> deleteComment(@PathVariable("id") Integer id, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized");
        }
        
        Comment comment = commentRepository.findById(id).orElse(null);
        // User ID တူညီမှသာ ဖျက်ခွင့်ပေးသည်
        if (comment != null && comment.getUser().getId().equals(userId)) {
            commentService.deleteComment(id);
            return ResponseEntity.ok("Deleted successfully");
        }
        
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Forbidden");
    }
   
 // 🟢 User ဘက်မှ Comment တစ်ခုကို Report နှိပ်လိုက်သောအခါ အလုပ်လုပ်မည့် API
    @PostMapping("/report/{id}")
    public ResponseEntity<String> reportComment(@PathVariable("id") Integer id, 
                                                @RequestParam("reason") String reason, 
                                                HttpSession session) {
        
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Login ဝင်ရန်လိုအပ်ပါသည်။");
        }
        
        // Comment ကို ID ဖြင့် ရှာဖွေခြင်း
        Comment comment = commentRepository.findById(id).orElse(null);
        if (comment != null) {
            // Report အခြေအနေနှင့် အကြောင်းရင်းကို သတ်မှတ်ခြင်း
            comment.setIsReported(true);
            comment.setReportReason(reason); 
            
            // Database တွင် အပ်ဒိတ်လုပ် သိမ်းဆည်းခြင်း
            commentService.saveComment(comment); 
            
            return ResponseEntity.ok("Comment reported successfully");
        }
        
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Comment မတွေ့ပါ။");
    }
}