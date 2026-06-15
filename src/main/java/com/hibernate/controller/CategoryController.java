package com.hibernate.controller;

import com.hibernate.entity.Category;
import com.hibernate.entity.User;
import com.hibernate.service.CategoryService;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/categories")
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    private boolean isNotAdmin(HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        return user == null || !"ADMIN".equalsIgnoreCase(user.getRole());
    }

    // 1. Read All
    @GetMapping("")
    public String listCategories(HttpSession session, Model model) {
        if (isNotAdmin(session)) return "redirect:/login";
        
        model.addAttribute("categories", categoryService.listAll());
        return "admin-categories";
    }

    // 2. Open Create Form
    @GetMapping("/new")
    public String showCreateForm(HttpSession session, Model model) {
        if (isNotAdmin(session)) return "redirect:/login";
        
        model.addAttribute("category", new Category());
        return "category-form";
    }

    // 3. Open Update Form
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") int id, HttpSession session, Model model) {
        if (isNotAdmin(session)) return "redirect:/login";
        
        model.addAttribute("category", categoryService.get(id));
        return "category-form";
    }

    // 4. Save / Update Action
    @PostMapping("/save")
    public String saveCategory(@ModelAttribute("category") Category category, HttpSession session) {
        if (isNotAdmin(session)) return "redirect:/login";
        
        categoryService.save(category);
        return "redirect:/admin/categories";
    }

    // 5. Delete Action
    @GetMapping("/delete/{id}")
    public String deleteCategory(@PathVariable("id") int id, HttpSession session) {
        if (isNotAdmin(session)) return "redirect:/login";
        
        categoryService.delete(id);
        return "redirect:/admin/categories";
    }
}