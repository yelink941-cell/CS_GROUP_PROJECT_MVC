package com.hibernate.controller;

import com.hibernate.entity.Category;
import com.hibernate.entity.Post;
import com.hibernate.entity.Tag;
import com.hibernate.service.CategoryService;
import com.hibernate.service.PostService;
import com.hibernate.service.TagService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/posts")
public class PublicPostController {
    private final PostService postService;
    private final CategoryService categoryService;
    private final TagService tagService;

    @GetMapping("/public")
    public String allPublicPosts(Model model) {
        return showPosts(
                model,
                postService.getPublishedPublicPosts(),
                "All Public Posts",
                "Browse every public cheat sheet approved for publication.",
                "No public posts are available yet.");
    }

    @GetMapping("/categories")
    public String categories(Model model) {
        model.addAttribute(
                "categorySummaries",
                postService.getPublishedPublicPostCountsByCategory());
        return "public/post/categories";
    }

    @GetMapping("/categories/{categoryId}")
    public String postsByCategory(@PathVariable Integer categoryId, Model model) {
        Category category = categoryService.getCategoryById(categoryId).orElse(null);
        if (category == null) {
            return "redirect:/posts/categories";
        }

        return showPosts(
                model,
                postService.getPostsByCategoryId(categoryId),
                category.getName(),
                "Public cheat sheets in this category.",
                "No public posts are available in this category.");
    }

    @GetMapping("/tags")
    public String tags(Model model) {
        model.addAttribute("tagSummaries", postService.getPublishedPublicPostCountsByTag());
        return "public/post/tags";
    }

    @GetMapping("/tags/{tagId}")
    public String postsByTag(@PathVariable Integer tagId, Model model) {
        Tag tag = tagService.getTagById(tagId).orElse(null);
        if (tag == null) {
            return "redirect:/posts/tags";
        }

        return showPosts(
                model,
                postService.getPublishedPublicPostsByTagId(tagId),
                "Tag: " + tag.getName(),
                "Public cheat sheets using this tag.",
                "No public posts are available for this tag.");
    }

    @GetMapping("/popular")
    public String popularPosts(Model model) {
        return showPosts(
                model,
                postService.getPopularPublishedPublicPosts(),
                "Popular Cheat Sheets",
                "Explore public cheat sheets ordered by total views.",
                "No popular posts are available yet.");
    }

    @GetMapping("/new")
    public String newestPosts(Model model) {
        return showPosts(
                model,
                postService.getNewestPublishedPublicPosts(),
                "New Cheat Sheets",
                "Discover the latest public cheat sheets.",
                "No new posts are available yet.");
    }

    private String showPosts(
            Model model,
            List<Post> posts,
            String pageTitle,
            String pageDescription,
            String emptyMessage) {
        model.addAttribute("posts", posts);
        model.addAttribute("pageTitle", pageTitle);
        model.addAttribute("pageDescription", pageDescription);
        model.addAttribute("emptyMessage", emptyMessage);
        return "public/post/list";
    }
}
