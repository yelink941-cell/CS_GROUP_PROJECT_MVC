package com.hibernate.controller;

import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;
import com.hibernate.service.UserService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * Display Registration View Form
     * URL: http://localhost:8080/OJT_22CheatSheet/register
     */
    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("profile", new UserProfile());
        return "register"; // Maps to /WEB-INF/views/register.jsp
    }

    /**
     * Process Registration Form Submission & Multi-part File Upload
     */
    @PostMapping("/register")
    public String processRegistration(
            @ModelAttribute("user") User user, 
            @ModelAttribute("profile") UserProfile profile, 
            @RequestParam("avatarFile") MultipartFile avatarFile,
            HttpServletRequest request,
            Model model) {
        
        try {
            // If an avatar file is uploaded, extract bytes into your LONGBLOB field array
            if (avatarFile != null && !avatarFile.isEmpty()) {
                profile.setAvatar(avatarFile.getBytes());
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Image processing failed. Please try again.");
            return "register";
        }
        
        // Save entities sequentially down into database rows via transactional service
        boolean isSuccess = userService.registerNewUser(user, profile);
        
        if (isSuccess) {
            model.addAttribute("msg", "Account Created Successfully");
            return "index"; 
        } else {
            model.addAttribute("error", "This Email is already registered!");
            return "register"; 
        }
    }

    /**
     * Display Login Entry Form
     * URL: http://localhost:8080/OJT_22CheatSheet/login
     */
    @GetMapping("/login")
    public String showLoginForm() {
        return "login"; // Maps to /WEB-INF/views/login.jsp
    }

    /**
     * Process Session Authentication Rules
     */
    @PostMapping("/login")
    public String processLogin(
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            HttpSession session,
            Model model) {
        
        User loggedInUser = userService.authenticateUser(email, password);
        
        if (loggedInUser != null) {
            // Store active user properties securely inside session container context
            session.setAttribute("currentUser", loggedInUser);
            
            if ("ADMIN".equalsIgnoreCase(loggedInUser.getRole())) {
                return "redirect:/admin/dashboard";
            } else {
                return "redirect:/";
            }
        } else {
            // Direct text return prevents session data wipeout issues on redirect loops
            model.addAttribute("error", "Invalid email credentials or password matching sequence.");
            return "login"; 
        }
    }
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        // 🧼 Session ကို လုံးဝ ဖျက်သိမ်း (Invalidate) လိုက်ခြင်း
        if (session != null) {
            session.invalidate(); 
        }
        
        // 🔄 Session ပျက်သွားပြီးနောက် Login Page သို့ ပြန်လည် မောင်းထုတ်မည်
        return "redirect:/"; 
    }

    /**
     * Render Dedicated Standalone Profile Page View 
     * URL: http://localhost:8080/OJT_22CheatSheet/profile
     */
    @GetMapping("/profile")
    public String showUserProfilePage(HttpSession session, Model model) {
        // 1. Authenticate if a valid user context row reference details exist inside active session
        User currentUser = (User) session.getAttribute("currentUser");
        
        // Security Gatekeeper: Redirect anonymous intruders back to login screen
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        // 2. Fetch profile data record row linked to your User entity ID
        UserProfile profile = userService.getUserProfileByUserId(currentUser.getId());
        
        // 3. Using the full explicit type path prevents missing import compile errors
        if (profile != null && profile.getAvatar() != null) {
            String base64Avatar = java.util.Base64.getEncoder().encodeToString(profile.getAvatar());
            model.addAttribute("avatarImage", base64Avatar);
        }
        
        model.addAttribute("userProfile", profile);
        return "profile"; // Maps beautifully to /WEB-INF/views/profile.jsp
    }
    /**
     * Display Edit Profile View Page
     * URL: http://localhost:8080/OJT_22CheatSheet/profile/edit
     */
    @GetMapping("/profile/edit")
    public String showEditProfilePage(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        UserProfile profile = userService.getUserProfileByUserId(currentUser.getId());
        model.addAttribute("userProfile", profile);
        return "edit-profile"; // Will route to /WEB-INF/views/edit-profile.jsp
    }

    /**
     * Process Profile Updates with Optional Avatar Upload
     */
    /**
     * Process Profile Updates with Optional Avatar Upload
     */
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
            // Fetch the existing profile record row currently stored inside your database
            UserProfile existingProfile = userService.getUserProfileByUserId(currentUser.getId());
            
            if (existingProfile != null) {
                // 1. FIX THE ERROR: Re-attach the parent User entity map instance so it's never null
                updatedProfile.setUser(existingProfile.getUser());
                
                // 2. Safely retain database primary keys
                updatedProfile.setId(existingProfile.getId());
                
                // 3. Keep original birthday values from changing unexpectedly
                updatedProfile.setDobDay(existingProfile.getDobDay());
                updatedProfile.setDobMonth(existingProfile.getDobMonth());
                updatedProfile.setDobYear(existingProfile.getDobYear());
                
                // 4. Handle avatar files fallback cleanly
                if (avatarFile != null && !avatarFile.isEmpty()) {
                    updatedProfile.setAvatar(avatarFile.getBytes());
                } else {
                    updatedProfile.setAvatar(existingProfile.getAvatar());
                }
            } else {
                // Defensive fallback strategy if no row existed previously
                updatedProfile.setUser(currentUser);
            }
            
            // Commit changes down into transactional database layers smoothly
            userService.updateUserProfile(updatedProfile);
            
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Failed to update profile settings.");
            return "edit-profile";
        }
        
        return "redirect:/profile";
    }

    /**
     * Secure Administrative Control Area
     * URL: http://localhost:8080/OJT_22CheatSheet/admin/dashboard
     */
    @GetMapping("/admin/dashboard")
    public String showAdminDashboard(HttpSession session) {
        User adminUser = (User) session.getAttribute("currentUser");
        
        // Authorization Guards
        if (adminUser == null || !"ADMIN".equalsIgnoreCase(adminUser.getRole())) {
            return "redirect:/login"; 
        }
        
        return "admin-dashboard"; // Maps to /WEB-INF/views/admin-dashboard.jsp
    }
}