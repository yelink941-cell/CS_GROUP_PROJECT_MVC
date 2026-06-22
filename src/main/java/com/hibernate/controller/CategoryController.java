package com.hibernate.controller;

import com.hibernate.entity.Category;
import com.hibernate.service.CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/categories")
public class CategoryController {
    private final CategoryService categoryService;

    @GetMapping
    public String listCategories(Model model) {
        model.addAttribute("categories", categoryService.getAllCategories());
        return "admin/categories/list";
    }
    
	/*
	 * @GetMapping("/hello")
	 * 
	 * @ResponseBody public String hello() { return "Category Controller OK"; }
	 */

    @GetMapping("/new")
    public String showCreateForm(Model model) {
        model.addAttribute("category", new Category());
        return "admin/categories/form";
    }

    @PostMapping
    public String createCategory(@ModelAttribute("category") Category category, Model model) {
        if (categoryService.existsByName(category.getName())) {
            model.addAttribute("errorMessage", "Category name already exists.");
            model.addAttribute("category", category);
            return "admin/categories/form";
        }

        categoryService.createCategory(category);
        model.addAttribute("categories", categoryService.getAllCategories());
        return "admin/categories/list";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model) {
        return categoryService.getCategoryById(id)
                .map(category -> {
                    model.addAttribute("category", category);
                    return "admin/categories/form";
                })
                .orElseGet(() -> {
                    model.addAttribute("errorMessage", "Category not found.");
                    model.addAttribute("categories", categoryService.getAllCategories());
                    return "admin/categories/list";
                });
    }

    @PostMapping("/update/{id}")
    public String updateCategory(
            @PathVariable Integer id,
            @ModelAttribute("category") Category category,
            Model model) {
        category.setId(id);
        categoryService.updateCategory(category);
        model.addAttribute("categories", categoryService.getAllCategories());
        return "admin/categories/list";
    }

    @GetMapping("/delete/{id}")
    public String deleteCategory(@PathVariable Integer id, Model model) {
        categoryService.deleteCategory(id);
        model.addAttribute("categories", categoryService.getAllCategories());
        return "admin/categories/list";
    }
}
