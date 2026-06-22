package com.hibernate.controller;

import javax.servlet.http.HttpSession;
import com.hibernate.repository.PostLikeRepository;
import com.hibernate.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import com.hibernate.repository.PostRepository;
import com.hibernate.entity.Post;
import java.util.List;
import com.hibernate.entity.Comment;
import com.hibernate.service.CommentService;

@Controller
@RequestMapping("/post")
public class PostController {

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private CommentService commentService; 
    
    @Autowired
    private PostLikeRepository postLikeRepository;

    @GetMapping("/details/{id}")
    public String getPostDetails(@PathVariable("id") Integer postId, Model model, HttpSession session) {
        System.out.println("========== DEBUG START ==========");
        Post post = postRepository.findById(postId).orElse(null);
        
        int totalCommentCount = commentService.getTotalActiveComments(postId);
        System.out.println("TOTAL COMMENT COUNT = " + totalCommentCount);
        // 🌟 ပြင်ဆင်ချက် - Parent သက်သက်မဟုတ်ဘဲ Reply/Sub-replies အားလုံးပါဝင်သော အဆင့်ဆင့်စစ်ထုတ်ပြီး Comment List ကို ရယူခြင်း 🌟
        List<Comment> activeComments = commentService.getCommentsByPostId(postId);
        
        long totalLikes = 0;
        boolean isLiked = false;

        if (post != null) {
            totalLikes = postLikeRepository.countByPostId(postId);
            User sessionUser = (User) session.getAttribute("user");
            if (sessionUser != null) {
                isLiked = postLikeRepository.existsByPostIdAndUserId(postId, sessionUser.getId());
            }
        }

        model.addAttribute("totalLikes", totalLikes);
        model.addAttribute("isLiked", isLiked);
        model.addAttribute("post", post);
        model.addAttribute("totalCommentCount", totalCommentCount);
        // 🌟 ပြင်ဆင်ချက် - JSP သို့ Comment အားလုံး (Parent + Replies) ပို့ပေးခြင်း 🌟
        model.addAttribute("comments", activeComments);

        return "postDetails";
    }
}