package com.hibernate.controller;

import com.hibernate.entity.Post;
import com.hibernate.entity.enums.PostStatus;
import com.hibernate.service.CategoryService;
import com.hibernate.service.PostService;
import com.hibernate.service.TagService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
@RequestMapping("/user/posts")
public class PostController {
    private final PostService postService;
    private final CategoryService categoryService;
    private final TagService tagService;

    @GetMapping
    public String listPosts(Model model) {
        model.addAttribute("posts", postService.getAllPosts());
        return "user/post/list";
    }

    @GetMapping("/new")
    public String showCreateForm(Model model) {
        model.addAttribute("post", new Post());
        loadFormData(model);
        return "user/post/form";
    }

    @PostMapping
    public String createPost(
            @RequestParam String title,
            @RequestParam String slug,
            @RequestParam(required = false) String excerpt,
            @RequestParam Integer categoryId,
            @RequestParam(required = false) List<Integer> tagIds,
            @RequestParam PostStatus status,
            Model model) {
        Post post = buildPost(title, slug, excerpt, status);

        if (postService.existsBySlug(slug)) {
            model.addAttribute("errorMessage", "Post slug already exists.");
            model.addAttribute("post", post);
            model.addAttribute("selectedCategoryId", categoryId);
            model.addAttribute("selectedTagIds", tagIds);
            loadFormData(model);
            return "user/post/form";
        }

        postService.createPost(post, categoryId, tagIds);
        return "redirect:/user/posts";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model) {
        return postService.getPostById(id)
                .map(post -> {
                    model.addAttribute("post", post);
                    loadFormData(model);
                    return "user/post/form";
                })
                .orElse("redirect:/user/posts");
    }

    @PostMapping("/update/{id}")
    public String updatePost(
            @PathVariable Integer id,
            @RequestParam String title,
            @RequestParam String slug,
            @RequestParam(required = false) String excerpt,
            @RequestParam Integer categoryId,
            @RequestParam(required = false) List<Integer> tagIds,
            @RequestParam PostStatus status) {
        Post post = buildPost(title, slug, excerpt, status);
        postService.updatePost(id, post, categoryId, tagIds);
        return "redirect:/user/posts";
    }

    @GetMapping("/delete/{id}")
    public String deletePost(@PathVariable Integer id) {
        postService.deletePost(id);
        return "redirect:/user/posts";
    }

    private Post buildPost(String title, String slug, String excerpt, PostStatus status) {
        Post post = new Post();
        post.setTitle(title);
        post.setSlug(slug);
        post.setExcerpt(excerpt);
        post.setStatus(status);
        return post;
    }

    private void loadFormData(Model model) {
        model.addAttribute("categories", categoryService.getAllCategories());
        model.addAttribute("tags", tagService.getAllTags());
        model.addAttribute("statuses", PostStatus.values());
    }
}
