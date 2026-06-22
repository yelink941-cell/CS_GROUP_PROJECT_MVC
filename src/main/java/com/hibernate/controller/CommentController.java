package com.hibernate.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.hibernate.entity.Comment;
import com.hibernate.entity.Post;
import com.hibernate.entity.User;
import com.hibernate.repository.PostRepository;
import com.hibernate.repository.UserRepository;
import com.hibernate.repository.CommentRepository;

@Controller
@RequestMapping("/comments")
public class CommentController {

    @Autowired
    private PostRepository postRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private CommentRepository commentRepository; 

    @PostMapping("/add")
    public String addComment(@RequestParam("postId") Integer postId,
                             @RequestParam("content") String content,
                             HttpSession session) {

        System.out.println("STEP 1");

        User sessionUser = (User) session.getAttribute("user");
        System.out.println("STEP 2 = " + sessionUser);

        if (sessionUser == null) {
            System.out.println("SESSION USER NULL");
            return "redirect:/login";
        }

        if (content == null || content.trim().isEmpty()) {
            return "redirect:/post/details/" + postId;
        }

        Post post = postRepository.findById(postId).orElse(null);
        System.out.println("STEP 3 = " + post);

        if (post == null) {
            return "redirect:/";
        }

        User dbUser = userRepository.findById(sessionUser.getId()).orElse(null);
        System.out.println("STEP 4 = " + dbUser);

        if (dbUser == null) {
            return "redirect:/login";
        }

        Comment comment = new Comment();
        comment.setContent(content);
        comment.setUser(dbUser);
        comment.setPost(post);

        System.out.println("STEP 5 BEFORE SAVE");

        commentRepository.saveAndFlush(comment);

        System.out.println("STEP 6 AFTER SAVE");

        return "redirect:/post/details/" + postId;
    }
    
    @PostMapping("/reply")
    public String addReply(@RequestParam("postId") Integer postId,
                           @RequestParam(value = "parentId", required = false) Integer parentId, 
                           @RequestParam("content") String replyContent, 
                           HttpSession session) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        // 🌟 အပြောင်းအလဲ - Space အလွတ်သက်သက် (ဥပမာ- "   ") ဝင်ခြင်းမှပါ လုံးဝကာကွယ်ရန် 🌟
        if (replyContent == null || replyContent.trim().isEmpty() || replyContent.trim().length() == 0) {
            return "redirect:/post/details/" + postId;
        }

        Post post = postRepository.findById(postId).orElse(null);
        
        Comment parent = null;
        if (parentId != null) {
            parent = commentRepository.findById(parentId).orElse(null);
        }

        Comment reply = new Comment();
        reply.setContent(replyContent); 
        reply.setPost(post);
        reply.setUser(user);
        reply.setParent(parent); 

        commentRepository.save(reply);

        return "redirect:/post/details/" + postId;
    }
    
    @PostMapping("/delete")
    public String deleteComment(@RequestParam("commentId") Integer commentId,
                                @RequestParam("postId") Integer postId,
                                HttpSession session) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Comment comment = commentRepository.findById(commentId).orElse(null);

        if (comment != null) {
            comment.setDeletedAt(java.time.LocalDateTime.now());
            commentRepository.save(comment);
        }

        return "redirect:/post/details/" + postId;
    }
}