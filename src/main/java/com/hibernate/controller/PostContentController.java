package com.hibernate.controller;

import com.hibernate.entity.PostContent;
import com.hibernate.entity.enums.ContentType;
import com.hibernate.entity.enums.PostStatus;
import com.hibernate.service.PostContentService;
import com.hibernate.service.PostService;
import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
@RequestMapping("/user/posts")
public class PostContentController {
    private final PostContentService postContentService;
    private final PostService postService;

    @GetMapping("/{postId}/contents")
    public String listContents(
            @PathVariable Integer postId,
            HttpSession session,
            Model model) {
        String accessRedirect = getAccessRedirect(postId, session);
        if (accessRedirect != null) {
            return accessRedirect;
        }

        model.addAttribute("post", postService.getPostById(postId).orElseThrow());
        model.addAttribute("contents", postContentService.getContentsByPostId(postId));
        return "user/post/contents";
    }

    @GetMapping("/{postId}/contents/new")
    public String showAddForm(
            @PathVariable Integer postId,
            HttpSession session,
            Model model) {
        String accessRedirect = getAccessRedirect(postId, session);
        if (accessRedirect != null) {
            return accessRedirect;
        }

        PostContent postContent = new PostContent();
        loadForm(model, postId, postContent);
        return "user/post/content-form";
    }

    @PostMapping("/{postId}/contents/add")
    public String addContent(
            @PathVariable Integer postId,
            @RequestParam(required = false) String subtitle,
            @RequestParam ContentType contentType,
            @RequestParam(required = false) String contentData,
            @RequestParam(required = false) MultipartFile imageFile,
            HttpSession session,
            Model model) {
        String accessRedirect = getAccessRedirect(postId, session);
        if (accessRedirect != null) {
            return accessRedirect;
        }

        PostContent postContent = buildContent(subtitle, contentType, contentData);
        try {
            postContentService.addContent(postId, postContent, imageFile);
            return "redirect:/user/posts/" + postId + "/contents";
        } catch (IllegalArgumentException | IllegalStateException exception) {
            model.addAttribute("errorMessage", exception.getMessage());
            loadForm(model, postId, postContent);
            return "user/post/content-form";
        }
    }

    @GetMapping("/{postId}/contents/edit/{contentId}")
    public String showEditForm(
            @PathVariable Integer postId,
            @PathVariable Integer contentId,
            HttpSession session,
            Model model) {
        String accessRedirect = getAccessRedirect(postId, session);
        if (accessRedirect != null) {
            return accessRedirect;
        }

        return postContentService.getContent(postId, contentId)
                .map(postContent -> {
                    loadForm(model, postId, postContent);
                    return "user/post/content-form";
                })
                .orElse("redirect:/user/posts/" + postId + "/contents");
    }

    @PostMapping("/{postId}/contents/update/{contentId}")
    public String updateContent(
            @PathVariable Integer postId,
            @PathVariable Integer contentId,
            @RequestParam(required = false) String subtitle,
            @RequestParam ContentType contentType,
            @RequestParam(required = false) String contentData,
            @RequestParam(required = false) MultipartFile imageFile,
            HttpSession session,
            Model model) {
        String accessRedirect = getAccessRedirect(postId, session);
        if (accessRedirect != null) {
            return accessRedirect;
        }

        PostContent postContent = buildContent(subtitle, contentType, contentData);
        postContent.setId(contentId);
        try {
            postContentService.updateContent(postId, contentId, postContent, imageFile);
            return "redirect:/user/posts/" + postId + "/contents";
        } catch (IllegalArgumentException | IllegalStateException exception) {
            model.addAttribute("errorMessage", exception.getMessage());
            loadForm(model, postId, postContent);
            return "user/post/content-form";
        }
    }

    @GetMapping("/{postId}/contents/delete/{contentId}")
    public String deleteContent(
            @PathVariable Integer postId,
            @PathVariable Integer contentId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        String accessRedirect = getAccessRedirect(postId, session);
        if (accessRedirect != null) {
            return accessRedirect;
        }

        try {
            postContentService.deleteContent(postId, contentId);
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("errorMessage", exception.getMessage());
        }

        return "redirect:/user/posts/" + postId + "/contents";
    }

    private String getAccessRedirect(Integer postId, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        if (!postContentService.isPostOwner(postId, userId)) {
            return "redirect:/user/posts";
        }

        if (postService.getPostById(postId)
                .filter(post -> post.getDeletedAt() == null)
                .filter(post -> !PostStatus.USER_DELETED.equals(post.getStatus()))
                .isEmpty()) {
            return "redirect:/user/posts";
        }

        return null;
    }

    private PostContent buildContent(
            String subtitle,
            ContentType contentType,
            String contentData) {
        PostContent postContent = new PostContent();
        postContent.setSubtitle(subtitle);
        postContent.setContentType(contentType);
        postContent.setContentData(contentData);
        return postContent;
    }

    private void loadForm(Model model, Integer postId, PostContent postContent) {
        model.addAttribute("postId", postId);
        model.addAttribute("postContent", postContent);
        model.addAttribute(
                "contentTypes",
                new ContentType[] {
                    ContentType.TEXT,
                    ContentType.CODE,
                    ContentType.IMAGE
                });
    }
}
