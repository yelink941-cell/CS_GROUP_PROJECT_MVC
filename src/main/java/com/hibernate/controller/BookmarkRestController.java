package com.hibernate.controller;

import com.hibernate.service.BookmarkService;
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
public class BookmarkRestController {

    private final BookmarkService bookmarkService;

    @PostMapping("/api/toggle-bookmark")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleBookmark(
            @RequestParam("postId") Integer postId,
            HttpSession session) {
        
        Long userId = (Long) session.getAttribute("userId");
        Map<String, Object> response = new HashMap<>();
        
        if (userId == null) {
            response.put("status", "error");
            response.put("message", "Login လိုအပ်ပါသည်။");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }
        
        boolean isBookmarked = bookmarkService.toggleBookmark(userId, postId);
        long totalBookmarks = bookmarkService.getBookmarkCount(postId);
        
        response.put("status", "success");
        response.put("isBookmarked", isBookmarked);
        response.put("totalBookmarks", totalBookmarks);
        
        return ResponseEntity.ok(response);
    }
}