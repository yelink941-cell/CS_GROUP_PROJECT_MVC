package com.hibernate.controller;

import com.hibernate.dto.RegistrationDto;
import com.hibernate.entity.User;
import com.hibernate.service.UserService;

import javax.servlet.http.HttpServletRequest; // 👈 ဖြည့်စွက်ထားသော Import
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam; // 👈 ဖြည့်စွက်ထားသော Import

@Controller
public class UserController {
    private final UserService userService;
    public UserController(UserService userService) {
        this.userService = userService;
    }
    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("registrationDto", new RegistrationDto());
        return "register"; 
    }
    @PostMapping("/register")
    public String registerUser(@ModelAttribute("registrationDto") RegistrationDto dto, Model model) {
        try {
            User registeredUser = userService.registerNewUser(dto);
            model.addAttribute("successMessage", "အောင်မြင်စွာ Register လုပ်ပြီးပါပြီ။ ယူဆာ ID: " + registeredUser.getId());
            model.addAttribute("registrationDto", new RegistrationDto()); // Form ပြန်ရှင်းရန်
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("errorMessage", "စနစ်ချို့ယွင်းမှု တစ်ခုဖြစ်ပွားခဲ့ပါသည်။");
        }
        return "register";
    }

    @GetMapping("/login")
    public String showLoginForm() {
        return "login"; 
    }

    @PostMapping("/login")
    public String processLogin(
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            HttpServletRequest request,
            Model model) {
        
        User authenticatedUser = userService.loginUser(email, password);
        
        if (authenticatedUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", authenticatedUser);
            
            model.addAttribute("msg", "Welcome Back, " + authenticatedUser.getUsername() + "! 🎉");
            return "index";
        } else {
            model.addAttribute("error", "Invalid Email or Password! ❌");
            return "login";
        }
    }

    @GetMapping("/logout")
    public String processLogout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Session ကို ဖျက်ချလိုက်ခြင်း
        }
        return "redirect:/login";
    }
}