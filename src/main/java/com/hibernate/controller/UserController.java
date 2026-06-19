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
            
            // FIXED: Clean, type-safe comparison with Enum literals
            if (Role.ADMIN.equals(loggedInUser.getRole())) {
                return "redirect:/admin/dashboard";
            } else {
                return "redirect:/profile";
            }
        } else {
            model.addAttribute("error", "Invalid email or password.");
            return "login"; 
        }
    }

    @GetMapping("/profile")
    public String showUserProfilePage(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        UserProfile profile = userService.getUserProfileByUserId(currentUser.getId());
        
        if (profile != null && profile.getAvatar() != null) {
            String base64Avatar = java.util.Base64.getEncoder().encodeToString(profile.getAvatar());
            model.addAttribute("avatarImage", base64Avatar);
        }
        
        model.addAttribute("userProfile", profile);
        return "profile";
    }

    @GetMapping("/profile/edit")
    public String showEditProfilePage(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        UserProfile profile = userService.getUserProfileByUserId(currentUser.getId());
        model.addAttribute("userProfile", profile);
        return "edit-profile";
    }

    @PostMapping("/profile/update")
    public String processUpdateProfile(
            @ModelAttribute("userProfile") UserProfile updatedProfile,
            @RequestParam("avatarFile") MultipartFile avatarFile,
            HttpSession session,
            Model model) {
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        try {
            UserProfile existingProfile = userService.getUserProfileByUserId(currentUser.getId());
            
            if (existingProfile != null) {
                // Attach the underlying references so Hibernate merge works perfectly
                updatedProfile.setUser(existingProfile.getUser());
                updatedProfile.setId(existingProfile.getId());
                
                if (avatarFile != null && !avatarFile.isEmpty()) {
                    updatedProfile.setAvatar(avatarFile.getBytes());
                } else {
                    updatedProfile.setAvatar(existingProfile.getAvatar());
                }
            } else {
                updatedProfile.setUser(currentUser);
            }
            
            userService.updateUserProfile(updatedProfile);
            
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Failed to update profile settings.");
            return "edit-profile";
        }
        
        return "redirect:/profile";
    }

    @GetMapping("/admin/dashboard")
    public String showAdminDashboard(HttpSession session) {
        User adminUser = (User) session.getAttribute("currentUser");
        if (adminUser == null || !Role.ADMIN.equals(adminUser.getRole())) {
            return "redirect:/login"; 
        }
        return "admin-dashboard";
    }
}