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
    private final com.hibernate.repository.UserRepository userRepository;

    @PostMapping({"/api/toggle-bookmark", "/bookmark"})
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleBookmark(
            @RequestParam("postId") Integer postId,
            HttpSession session) {

        Object sessionUserId = session.getAttribute("userId");
        Long userId = null;
        if (sessionUserId instanceof Number) {
            userId = ((Number) sessionUserId).longValue();
        } else if (sessionUserId != null) {
            userId = Long.valueOf(sessionUserId.toString());
        }
        
        if (userId == null) {
            com.hibernate.entity.User sessionUser = (com.hibernate.entity.User) session.getAttribute("user");
            if (sessionUser == null) {
                sessionUser = (com.hibernate.entity.User) session.getAttribute("currentUser");
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
        
        com.hibernate.entity.User currentUser = userRepository.findById(userId).orElse(null);
        if (currentUser != null && currentUser.isCurrentlyBanned()) {
            response.put("status", "error");
            response.put("message", "Your account is restricted (" + currentUser.getBanRemainingText() + ")");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
        }
        
        boolean isBookmarked = bookmarkService.toggleBookmark(userId, postId);
        long totalBookmarks = bookmarkService.getBookmarkCount(postId);
        
        response.put("status", "success");
        response.put("isBookmarked", isBookmarked);
        response.put("totalBookmarks", totalBookmarks);
        
        return ResponseEntity.ok(response);
    }
}