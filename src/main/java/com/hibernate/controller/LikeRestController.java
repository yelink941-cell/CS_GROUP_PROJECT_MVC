package com.hibernate.controller;

import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.hibernate.entity.User;
import com.hibernate.repository.PostLikeRepository;
import com.hibernate.repository.PostRepository;
import com.hibernate.repository.UserRepository;
import com.hibernate.service.PostLikeService;

@RestController
public class LikeRestController {

    @Autowired
    private PostLikeRepository postLikeRepository;

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PostLikeService postLikeService;

    @PostMapping("/api/toggle-like")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleLike(@RequestParam("postId") Integer postId, HttpSession session) {

    	System.out.println("🪲 Debug - Session User ID: " + session.getAttribute("userId"));
	Object sessionUserId = session.getAttribute("userId");
        Long userId = null;
        if (sessionUserId instanceof Number) {
            userId = ((Number) sessionUserId).longValue();
        } else if (sessionUserId != null) {
            userId = Long.valueOf(sessionUserId.toString());
        }

        // 🟢 userId null ဖြစ်နေလျှင် session ထဲမှ user object ကို အမှီလိုက်ရှာပြီး ပြန်ထုတ်ပေးခြင်း
        if (userId == null) {
            User sessionUser = (User) session.getAttribute("user");
            if (sessionUser == null) {
                sessionUser = (User) session.getAttribute("currentUser");
            }

            if (sessionUser != null) {
                userId = Long.valueOf(sessionUser.getId());
                session.setAttribute("userId", userId);
            }
        }

        Map<String, Object> response = new HashMap<>();

        if (userId == null) {
            response.put("status", "error");
            response.put("message", "Login လိုအပ်ပါသည်။");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        // Service layer မှာ @Transactional + flush/clear ပါ၊ return value က isLiked
        boolean isLiked = postLikeService.toggleLike(postId, userId);
        long totalLikes = postLikeService.getLikeCount(postId);

        response.put("status", "success");
        response.put("isLiked", isLiked);
        response.put("totalLikes", totalLikes);

        return ResponseEntity.ok(response);
    }
}
