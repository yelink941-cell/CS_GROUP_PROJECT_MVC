package com.hibernate.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.hibernate.entity.PostLike;
import com.hibernate.entity.Post;
import com.hibernate.entity.User;
import com.hibernate.repository.PostLikeRepository;
import com.hibernate.repository.PostRepository;
import com.hibernate.repository.UserRepository;

@RestController
public class LikeRestController {

    @Autowired
    private PostLikeRepository postLikeRepository;

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/api/toggle-like")
    @ResponseBody
    @Transactional
    public Map<String, Object> toggleLike(@RequestParam Integer postId, HttpSession session) { // 🟢 Integer သို့ ပြောင်းလဲခြင်း
        Long userId = (Long) session.getAttribute("userId");
        Map<String, Object> response = new HashMap<>();
        
        if (userId == null) {
            response.put("status", "error");
            response.put("message", "Login လိုအပ်ပါသည်။");
            return response;
        }

        // Integer ဖြစ်သွားပြီဖြစ်သောကြောင့် .intValue() ထပ်ထည့်ရန် မလိုတော့ပါ
        boolean hasLiked = postLikeRepository.existsByPostIdAndUserId(postId, userId);
                
        if (hasLiked) {
            Optional<PostLike> existingLike = postLikeRepository.findByPostIdAndUserId(postId, userId);
            existingLike.ifPresent(postLike -> postLikeRepository.delete(postLike));
            response.put("isLiked", false);
        } else {
            Post post = postRepository.findById(postId).orElse(null);
            
            User user = userRepository.getUserById(userId); 
            
            PostLike newLike = new PostLike();
            newLike.setPost(post);
            newLike.setUser(user);
            
            postLikeRepository.save(newLike);
            response.put("isLiked", true);
        }
        
        long totalLikes = postLikeRepository.countByPostId(postId);
        response.put("status", "success");
        response.put("totalLikes", totalLikes);

        return response;
    }
}