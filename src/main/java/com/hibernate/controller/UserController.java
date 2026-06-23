package com.hibernate.controller;

import com.hibernate.dto.RegistrationDto;
import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;
import com.hibernate.entity.enums.Role;
import com.hibernate.service.UserService;

import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam; 
import org.springframework.web.multipart.MultipartFile;

@Controller
public class UserController {

    private final UserService userService;

    // Spring injects the service implementation automatically
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        // Send a single DTO object to the view to avoid multi-binding mess
        model.addAttribute("registrationDto", new RegistrationDto());
        return "register";
    }

    @PostMapping("/register")
    public String processRegistration(
            @ModelAttribute("registrationDto") RegistrationDto dto, 
            @RequestParam("avatarFile") MultipartFile avatarFile,
            Model model) {
        
        // 1. Unpack DTO fields into proper Hibernate Entity classes
        User user = new User();
        user.setUsername(dto.getUsername());
        user.setEmail(dto.getEmail());
        user.setPasswordHash(dto.getPassword()); // Service will handle hashing

        UserProfile profile = new UserProfile();
        profile.setFullName(dto.getFullName());
        profile.setBio(dto.getBio());
        profile.setCountry(dto.getCountry());
        
        try {
            if (avatarFile != null && !avatarFile.isEmpty()) {
                profile.setAvatar(avatarFile.getBytes());
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Image processing failed. Please try again.");
            return "register";
        }
        
        // 2. Pass to service layer (which now handles SessionFactory transactions)
        boolean isSuccess = userService.registerNewUser(user, profile);
        
        if (isSuccess) {
            model.addAttribute("msg", "Account Created Successfully");
            return "login"; 
        } else {
            model.addAttribute("error", "This Email is already registered!");
            return "register"; 
        }
    }

    @GetMapping("/login")
    public String showLoginForm() {
        return "login";
    }

    @PostMapping("/login")
    public String processLogin(
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            HttpSession session,
            Model model) {
        
        User loggedInUser = userService.authenticateUser(email, password);
        
        if (loggedInUser != null) {
            session.setAttribute("currentUser", loggedInUser);
            session.setAttribute("userId", loggedInUser.getId());
            
            // FIXED: Clean, type-safe comparison with Enum literals
            if (Role.ADMIN.equals(loggedInUser.getRole())) {
                return "redirect:/admin-dashboard";
            } else {
                return "redirect:/";
            }
        } else {
            model.addAttribute("error", "Invalid email or password.");
            return "login"; 
        }
    }

    @GetMapping("/admin-dashboard")
    public String showAdminDashboard(HttpSession session) {
        User adminUser = (User) session.getAttribute("currentUser");
        if (adminUser == null || !Role.ADMIN.equals(adminUser.getRole())) {
            return "redirect:/login"; 
        }
        return "admin-dashboard";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}
