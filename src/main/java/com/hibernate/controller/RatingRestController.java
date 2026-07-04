package com.hibernate.controller;

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

    @PostMapping("/api/toggle-rating")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleRating(
            @RequestParam("postId") Integer postId,
            @RequestParam("rating") Integer ratingValue,
            HttpSession session) {
        
        // 🟢 User ID အမျိုးအစား Long ဖြင့် တသမတ်တည်း ထုတ်ယူခြင်း
        Long userId = (Long) session.getAttribute("userId");
        Map<String, Object> response = new HashMap<>();
        
        if (userId == null) {
            response.put("status", "error");
            response.put("message", "Login လိုအပ်ပါသည်။");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
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