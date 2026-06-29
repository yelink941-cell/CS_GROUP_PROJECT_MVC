package com.hibernate.controller;

import com.hibernate.entity.Post;
import com.hibernate.service.PostService;
import com.hibernate.service.PostViewService;
import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/user/posts")
public class UserPostViewController {
    private final PostService postService;
    private final PostViewService postViewService;

    @GetMapping("/{postId}/views")
    public String postViews(
            @PathVariable Integer postId,
            HttpSession session,
            Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        Post post = postService.getPostById(postId)
                .filter(existingPost -> existingPost.getDeletedAt() == null)
                .orElse(null);

        if (post == null || !userId.equals(post.getAuthor().getId())) {
            return "redirect:/user/posts";
        }

        model.addAttribute("post", post);
        model.addAttribute("postViews", postViewService.getViewsByPostId(postId));
        model.addAttribute("totalViews", postViewService.countViewsByPostId(postId));
        return "user/post/views";
    }
}
