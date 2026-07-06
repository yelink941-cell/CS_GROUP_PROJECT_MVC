package com.hibernate.controller;

import com.hibernate.entity.User;
import com.hibernate.service.RatingService;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class RatingRestController {

    private final RatingService ratingService;
    private final com.hibernate.repository.UserRepository userRepository;

    @PostMapping({"/api/toggle-rating", "/rating"})
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleRating(
            @RequestParam("postId") Integer postId,
            @RequestParam("rating") Integer ratingValue,
            HttpSession session) {
        
        Object sessionUserId = session.getAttribute("userId");
        Long userId = null;
        if (sessionUserId instanceof Number) {
            userId = ((Number) sessionUserId).longValue();
        } else if (sessionUserId != null) {
            userId = Long.valueOf(sessionUserId.toString());
        }
        
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
        
        User currentUser = userRepository.findById(userId).orElse(null);
        if (currentUser != null && currentUser.isCurrentlyBanned()) {
            response.put("status", "error");
            response.put("message", "Your account is restricted (" + currentUser.getBanRemainingText() + ")");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
        }
        
        // Rating တန်ဖိုး သတ်မှတ်ချက် (ဥပမာ - ၁ မှ ၅ အတွင်း)
        if (ratingValue < 1 || ratingValue > 5) {
            response.put("status", "error");
            response.put("message", "Invalid rating value.");
            return ResponseEntity.badRequest().body(response);
        }
        
        ratingService.toggleRating(postId, userId, ratingValue);
        
        boolean hasRated = ratingService.hasUserRated(postId, userId);
        double averageRating = ratingService.getAverageRating(postId);
        long totalRatings = ratingService.getRatingCount(postId);
        
        response.put("status", "success");
        response.put("hasRated", hasRated);
        response.put("averageRating", Math.round(averageRating * 10.0) / 10.0); // ဒသမတစ်နေရာထိ ပျမ်းမျှတန်ဖိုးကို ဖြတ်ပေးခြင်း
        response.put("totalRatings", totalRatings);
        
        return ResponseEntity.ok(response);
    }
}