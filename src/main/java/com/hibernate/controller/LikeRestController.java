package com.hibernate.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus; // 🟢 ထည့်သွင်းပါ
import org.springframework.http.ResponseEntity; // 🟢 ထည့်သွင်းပါ
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
    // 🟢 Return type ကို ResponseEntity<Map<String, Object>> သို့ ပြောင်းပါ
    public ResponseEntity<Map<String, Object>> toggleLike(@RequestParam Integer postId, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        Map<String, Object> response = new HashMap<>();
        
        // 🟢 User မရှိ/Login မဝင်ထားလျှင် 401 Status ကုဒ်နှင့်တကွ ပြန်ပို့ခြင်း
        if (userId == null) {
            response.put("status", "error");
            response.put("message", "Login လိုအပ်ပါသည်။");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

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

        // 🟢 အောင်မြင်သည့်အခါ 200 OK ဖြင့် ပြန်ပို့ခြင်း
        return ResponseEntity.ok(response);
    }
}