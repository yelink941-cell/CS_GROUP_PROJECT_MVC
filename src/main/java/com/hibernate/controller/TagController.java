package com.hibernate.controller;

import com.hibernate.entity.Tag;
import com.hibernate.service.PostService;
import com.hibernate.service.TagService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/tags")
public class TagController {
    private final TagService tagService;
    private final PostService postService;

    // =========================================================
    // 1. LIST TAGS - FIXED (with statistics)
    // =========================================================
    @GetMapping
    public String listTags(Model model) {
        List<Tag> tags = tagService.getAllTags();
        
        // Tags data
        model.addAttribute("tags", tags);
        
        // Statistics for dashboard cards
        int totalTags = tags.size();
        model.addAttribute("totalTags", totalTags);
        model.addAttribute("totalPosts", postService.countAllPosts());
        
        // Average tags per post
        double avgTags = tagService.getAverageTagsPerPost();
        model.addAttribute("avgTagsPerPost", String.format("%.1f", avgTags));
        
        // Most used tag
        String mostUsedTag = tagService.getMostUsedTagName();
        model.addAttribute("mostUsedTag", mostUsedTag != null ? mostUsedTag : "N/A");
        
        // ✅ JSP က WEB-INF/views/admin/tags/list.jsp မှာရှိတယ်
        return "admin/tags/list";
    }

    // =========================================================
    // 2. SHOW CREATE FORM
    // =========================================================
    @GetMapping("/new")
    public String showCreateForm(Model model) {
        model.addAttribute("tag", new Tag());
        model.addAttribute("pageTitle", "Create New Tag");
        model.addAttribute("action", "create");
        // ✅ JSP က WEB-INF/views/admin/tags/form.jsp မှာရှိတယ်
        return "admin/tags/form";
    }

    // =========================================================
    // 3. CREATE TAG (POST)
    // =========================================================
    @PostMapping
    public String createTag(@ModelAttribute("tag") Tag tag, 
                            Model model,
                            RedirectAttributes redirectAttributes) {
        if (tagService.existsByName(tag.getName())) {
            model.addAttribute("errorMessage", "Tag name '" + tag.getName() + "' already exists.");
            model.addAttribute("tag", tag);
            model.addAttribute("pageTitle", "Create New Tag");
            model.addAttribute("action", "create");
            return "admin/tags/form";
        }

        tagService.createTag(tag);
        
        redirectAttributes.addFlashAttribute("successMessage", 
                "Tag '" + tag.getName() + "' created successfully!");
        return "redirect:/admin/tags";
    }

    // =========================================================
    // 4. SHOW EDIT FORM
    // =========================================================
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model) {
        return tagService.getTagById(id)
                .map(tag -> {
                    model.addAttribute("tag", tag);
                    model.addAttribute("pageTitle", "Edit Tag");
                    model.addAttribute("action", "update");
                    return "admin/tags/form";
                })
                .orElseGet(() -> {
                    model.addAttribute("errorMessage", "Tag not found.");
                    return "redirect:/admin/tags";
                });
    }

    // =========================================================
    // 5. UPDATE TAG (POST)
    // =========================================================
    @PostMapping("/update/{id}")
    public String updateTag(
            @PathVariable Integer id,
            @ModelAttribute("tag") Tag tag,
            RedirectAttributes redirectAttributes) {
        
        if (!tagService.getTagById(id).isPresent()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Tag not found.");
            return "redirect:/admin/tags";
        }
        
        tag.setId(id);
        tagService.updateTag(tag);
        
        redirectAttributes.addFlashAttribute("successMessage", 
                "Tag updated successfully!");
        return "redirect:/admin/tags";
    }

    // =========================================================
    // 6. DELETE TAG
    // =========================================================
    @GetMapping("/delete/{id}")
    public String deleteTag(@PathVariable Integer id, 
                            RedirectAttributes redirectAttributes) {
        try {
            Tag tag = tagService.getTagById(id).orElse(null);
            
            if (tag == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Tag not found.");
                return "redirect:/admin/tags";
            }
            
            // Check if tag has posts
            if (tag.getPosts() != null && !tag.getPosts().isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", 
                        "Cannot delete tag '" + tag.getName() + "' because it has associated posts. " +
                        "Please remove the tag from posts first.");
                return "redirect:/admin/tags";
            }
            
            tagService.deleteTag(id);
            redirectAttributes.addFlashAttribute("successMessage", 
                    "Tag '" + tag.getName() + "' deleted successfully!");
                    
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", 
                    "Error deleting tag: " + e.getMessage());
        }
        
        return "redirect:/admin/tags";
    }
}