package com.hibernate.controller;

import com.hibernate.entity.Tag;
import com.hibernate.service.TagService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/tags")
public class TagController {
    private final TagService tagService;

    @GetMapping
    public String listTags(Model model) {
        model.addAttribute("tags", tagService.getAllTags());
        return "admin/tags/list";
    }

    @GetMapping("/new")
    public String showCreateForm(Model model) {
        model.addAttribute("tag", new Tag());
        return "admin/tags/form";
    }

    @PostMapping
    public String createTag(@ModelAttribute("tag") Tag tag, Model model) {
        if (tagService.existsByName(tag.getName())) {
            model.addAttribute("errorMessage", "Tag name already exists.");
            model.addAttribute("tag", tag);
            return "admin/tags/form";
        }

        tagService.createTag(tag);
        model.addAttribute("tags", tagService.getAllTags());
        return "admin/tags/list";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model) {
        return tagService.getTagById(id)
                .map(tag -> {
                    model.addAttribute("tag", tag);
                    return "admin/tags/form";
                })
                .orElseGet(() -> {
                    model.addAttribute("errorMessage", "Tag not found.");
                    model.addAttribute("tags", tagService.getAllTags());
                    return "admin/tags/list";
                });
    }

    @PostMapping("/update/{id}")
    public String updateTag(
            @PathVariable Integer id,
            @ModelAttribute("tag") Tag tag,
            Model model) {
        tag.setId(id);
        tagService.updateTag(tag);
        model.addAttribute("tags", tagService.getAllTags());
        return "admin/tags/list";
    }

    @GetMapping("/delete/{id}")
    public String deleteTag(@PathVariable Integer id, Model model) {
        tagService.deleteTag(id);
        model.addAttribute("tags", tagService.getAllTags());
        return "admin/tags/list";
    }
}
