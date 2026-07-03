package com.hibernate.controller;

import com.hibernate.entity.Category;
import com.hibernate.service.CategoryService;
import lombok.RequiredArgsConstructor;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/categories")
public class CategoryController {
    private final CategoryService categoryService;

    // =========================================================
    // 1. LIST CATEGORIES - FIXED
    // =========================================================
    @GetMapping
    public String listCategories(Model model) {
        List<Category> categories = categoryService.getAllCategories();
        
        model.addAttribute("categories", categories);
        
        int totalCategories = categories.size();
        model.addAttribute("totalCategories", totalCategories);
        
        long activeCount = categories.stream()
                .filter(c -> c.getIsActive() != null && c.getIsActive())
                .count();
        model.addAttribute("activeCategories", activeCount);
        model.addAttribute("inactiveCategories", totalCategories - activeCount);
        model.addAttribute("totalPosts", 0);
        
        return "admin/categories/list";
    }

    // =========================================================
    // 2. SHOW CREATE FORM
    // =========================================================
    @GetMapping("/new")
    public String showCreateForm(Model model) {
        model.addAttribute("category", new Category());
        return "admin/categories/form";
    }

    // =========================================================
    // 3. CREATE CATEGORY (POST) - FIXED
    // =========================================================
    @PostMapping
    public String createCategory(@ModelAttribute("category") Category category, 
                                  Model model,
                                  RedirectAttributes redirectAttributes) {
        if (categoryService.existsByName(category.getName())) {
            model.addAttribute("errorMessage", "Category name already exists.");
            model.addAttribute("category", category);
            return "admin/categories/form";
        }

        // ✅ Set default active status
        if (category.getIsActive() == null) {
            category.setIsActive(true);
        }
        
        categoryService.createCategory(category);
        
        // ✅ Redirect with success message
        redirectAttributes.addFlashAttribute("successMessage", 
                "Category '" + category.getName() + "' created successfully!");
        return "redirect:/admin/categories";
    }

    // =========================================================
    // 4. SHOW EDIT FORM
    // =========================================================
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model) {
        return categoryService.getCategoryById(id)
                .map(category -> {
                    model.addAttribute("category", category);
                    return "admin/categories/form";
                })
                .orElseGet(() -> {
                    model.addAttribute("errorMessage", "Category not found.");
                    return "redirect:/admin/categories";
                });
    }

    // =========================================================
    // 5. UPDATE CATEGORY (POST) - FIXED
    // =========================================================
    @PostMapping("/update/{id}")
    public String updateCategory(
            @PathVariable Integer id,
            @ModelAttribute("category") Category category,
            Model model,
            RedirectAttributes redirectAttributes) {
        
        // ✅ Check if category exists
        if (!categoryService.getCategoryById(id).isPresent()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Category not found.");
            return "redirect:/admin/categories";
        }
        
        category.setId(id);
        categoryService.updateCategory(category);
        
        redirectAttributes.addFlashAttribute("successMessage", 
                "Category updated successfully!");
        return "redirect:/admin/categories";
    }

    // =========================================================
    // 6. DELETE CATEGORY - FIXED
    // =========================================================
 // =========================================================
 // DELETE CATEGORY - FIXED (with error handling)
 // =========================================================
 @GetMapping("/delete/{id}")
 public String deleteCategory(@PathVariable Integer id, 
                               RedirectAttributes redirectAttributes) {
     try {
         // Check if category has posts
         Category category = categoryService.getCategoryById(id).orElse(null);
         if (category == null) {
             redirectAttributes.addFlashAttribute("errorMessage", 
                     "Category not found.");
             return "redirect:/admin/categories";
         }
         
         // Try to delete
         categoryService.deleteCategory(id);
         redirectAttributes.addFlashAttribute("successMessage", 
                 "Category '" + category.getName() + "' deleted successfully!");
                 
     } catch (Exception e) {
         // If category has posts, show friendly error
         redirectAttributes.addFlashAttribute("errorMessage", 
                 "Cannot delete category because it has posts. Please remove posts first or deactivate the category.");
     }
     
     return "redirect:/admin/categories";
 }
    
    // =========================================================
    // 7. TOGGLE CATEGORY STATUS - FIXED
    // =========================================================
    @GetMapping("/toggle/{id}")
    public String toggleCategoryStatus(
            @PathVariable Integer id,
            RedirectAttributes redirectAttributes) {
        
        categoryService.getCategoryById(id).ifPresentOrElse(
            category -> {
                boolean currentStatus = category.getIsActive() != null && category.getIsActive();
                category.setIsActive(!currentStatus);
                categoryService.updateCategory(category);
                
                String status = category.getIsActive() ? "Active" : "Inactive";
                redirectAttributes.addFlashAttribute("successMessage", 
                        "Category '" + category.getName() + "' status toggled to " + status);
            },
            () -> {
                redirectAttributes.addFlashAttribute("errorMessage", 
                        "Category not found.");
            }
        );
        
        return "redirect:/admin/categories";
    }
}