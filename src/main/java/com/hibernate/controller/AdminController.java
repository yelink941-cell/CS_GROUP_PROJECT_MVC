package com.hibernate.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.hibernate.service.UserService;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserService userService; // User အချက်အလက်ယူဖို့ UserService ကို သုံးပါ

    // User Management ကို နှိပ်ရင်ရောက်မယ့်နေရာ
    @GetMapping("/users")
    public String showUserList(Model model) {
        // Service ကနေ User အားလုံးကို ယူတယ်
        model.addAttribute("users", userService.getAllUsers());
        return "user-list"; // ဒီနာမည်နဲ့ JSP ဖိုင်ကို ဖန်တီးရပါမယ်
    }
    
    @GetMapping("/deleteUser") 
    public String deleteUser(@RequestParam("id") int id) {
        userService.deleteUser(id);
        return "redirect:/admin/users";
    }
    
    @GetMapping("/banUser")
    public String banUser(@RequestParam("id") int id) {
        userService.banUser(id);
        return "redirect:/admin/users";
    }
}
