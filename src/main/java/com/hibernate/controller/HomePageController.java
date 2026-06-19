package com.hibernate.controller;

import com.hibernate.service.PostService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
public class HomePageController {
    private final PostService postService;
	
    @GetMapping({"/", "/posts/public"})
    public String homePage(Model model) {
        model.addAttribute("posts", postService.getPublishedPublicPosts());
        return "index";
    }

    @GetMapping("/posts/public/details")
    public String publicPostDetails(@RequestParam("slug") String slug, Model model) {
        return postService.getPostBySlug(slug)
                .map(post -> {
                    model.addAttribute("post", post);
                    return "public/post/details";
                })
                .orElse("redirect:/posts/public");
    }
}
