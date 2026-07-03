package com.hibernate.controller;

import com.hibernate.dto.RegistrationDto;
import com.hibernate.entity.User;
import com.hibernate.entity.UserPreference;
import com.hibernate.entity.UserProfile;
import com.hibernate.entity.enums.Role;
import com.hibernate.entity.enums.UserStatus;
import com.hibernate.service.CommentService;
import com.hibernate.service.PostService;
import com.hibernate.service.UserService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;

import javax.servlet.http.HttpSession;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam; 
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class UserController {

	private final UserService userService;
    private final JavaMailSender mailSender;
    private final PostService postService;
    private final CommentService commentService;

    // ✅ Constructor ကို ပြင်ပါ
    public UserController(UserService userService, 
                          JavaMailSender mailSender,
                          PostService postService,
                          CommentService commentService) {
        this.userService = userService;
        this.mailSender = mailSender;
        this.postService = postService;
        this.commentService = commentService;
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
        
        if (dto.getPassword() == null || !dto.getPassword().equals(dto.getConfirmPassword())) {
            model.addAttribute("error", "Passwords do not match!");
            return "register";
        }
        
        User user = new User();
        user.setUsername(dto.getUsername());
        user.setEmail(dto.getEmail());
        user.setPasswordHash(dto.getPassword()); 

        UserProfile profile = new UserProfile();
        profile.setFullName(dto.getFullName());
        profile.setBio(dto.getBio());
        profile.setGender(dto.getGender());
        
        try {
            if (avatarFile != null && !avatarFile.isEmpty()) {
                profile.setAvatar(avatarFile.getBytes());
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Image processing failed. Please try again.");
            return "register";
        }
        
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
    
    @ModelAttribute
    public void populateUserSession(HttpSession session) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
            if (session.getAttribute("currentUser") == null) {
                String identifier = auth.getName(); 
                User user = userService.findUserByEmail(identifier); 
                
                if (user != null) {
                    session.setAttribute("currentUser", user);
                }
            }
        }
    }


    @GetMapping("/forgot-password")
    public String showForgotPasswordForm() {
        return "forgot-password"; 
    }

   
    @PostMapping("/forgot-password")
    public String processForgotPassword(
            @RequestParam("email") String email, 
            Model model) {
        
        User user = userService.findUserByEmail(email);
        
        if (user == null) {
           
            model.addAttribute("msg", "If that account exists, a secure verification step has been dispatched.");
            return "forgot-password";
        }

       
        Random random = new Random();
        String otpCode = String.format("%06d", random.nextInt(900000) + 100000);
        
        
        userService.createPasswordResetTokenForUser(user, otpCode);
        
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(email);
            message.setSubject("Your Secure Reset Verification Code");
            message.setText("Hello,\n\nYour security Verification One-Time Code (OTP) is: " + otpCode 
                            + "\n\nThis code will expire in exactly 15 minutes for your protection.");
            
            mailSender.send(message);
            
            model.addAttribute("email", email);
            return "verify-otp";
            
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Failed to process email dispatch. Please try again.");
            return "forgot-password";
        }
    }

    
    @PostMapping("/verify-otp")
    public String processOtpVerification(
            @RequestParam("email") String email,
            @RequestParam("otp") String submittedOtp,
            Model model) {
        
        User user = userService.findUserByEmail(email.trim());
        
        if (user == null || user.getResetToken() == null) {
            model.addAttribute("error", "Session invalid. Please start over.");
            return "forgot-password";
        }
        
        if (user.getTokenExpiryDate().isBefore(java.time.LocalDateTime.now())) {
            model.addAttribute("error", "The OTP code has expired. Please request a new one.");
            return "forgot-password";
        }
        
        if (user.getResetToken().equals(submittedOtp.trim())) {
           
            model.addAttribute("token", submittedOtp.trim());
            return "reset-password"; 
        } else {
           
            model.addAttribute("error", "Invalid OTP security code. Please check your email inbox again.");
            model.addAttribute("email", email); 
            return "verify-otp"; 
        }
    }

   
    @PostMapping("/reset-password")
    public String processResetPassword(
            @RequestParam("token") String token,
            @RequestParam("password") String password,
            @RequestParam("confirmPassword") String confirmPassword,
            Model model) {
        
        if (!password.equals(confirmPassword)) {
            model.addAttribute("token", token);
            model.addAttribute("error", "Passwords do not match!");
            return "reset-password";
        }
        
        User user = userService.findUserByResetToken(token);
        if (user == null || user.getTokenExpiryDate().isBefore(LocalDateTime.now())) {
            model.addAttribute("error", "Transaction session expired. Please start over.");
            return "redirect:/forgot-password";
        }
        
        userService.updatePassword(user, password); 
        return "redirect:/login?resetSuccess=true"; 
    }

    @GetMapping("/profile")
    public String showUserProfilePage(
            @RequestParam(value = "id", required = false) Integer targetUserId, 
            HttpSession session, 
            Model model) {
            
        User currentUser = (User) session.getAttribute("currentUser");
        
        Long profileOwnerId;
        if (targetUserId != null) {
            profileOwnerId = Long.valueOf(targetUserId);
        } else if (currentUser != null) {
            profileOwnerId = currentUser.getId();
        } else {
            return "redirect:/login"; 
        }
        
        UserProfile profile = userService.getUserProfileByUserId(profileOwnerId);
        
        if (profile != null && profile.getAvatar() != null) {
            String base64Avatar = java.util.Base64.getEncoder().encodeToString(profile.getAvatar());
            model.addAttribute("avatarImage", base64Avatar);
        }
        
        model.addAttribute("userProfile", profile);
        model.addAttribute("currentUser", currentUser);

       
        boolean isFollowing = false;
        
        if (currentUser != null && !currentUser.getId().equals(profileOwnerId)) {
            isFollowing = userService.isFollowing(currentUser.getId(), profileOwnerId.intValue());
        }
        model.addAttribute("isFollowing", isFollowing);

        return "profile/profile"; 
    }

    @GetMapping("/profile/edit")
    public String showEditProfilePage(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        UserProfile profile = userService.getUserProfileByUserId(currentUser.getId());
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("userProfile", profile);
        return "profile/edit-profile"; 
    }

    @PostMapping("/profile/update")
    public String handleProfileUpdate(
            @ModelAttribute("userProfile") UserProfile formProfile,
            @RequestParam(value = "avatarFile", required = false) MultipartFile avatarFile,
            @RequestParam(value = "currentPassword", required = false) String currentPassword,
            @RequestParam(value = "newPassword", required = false) String newPassword,
            @RequestParam(value = "confirmPassword", required = false) String confirmPassword,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
       
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        boolean hasCurrentPwd = currentPassword != null && !currentPassword.trim().isEmpty();
        boolean hasNewPwd = newPassword != null && !newPassword.trim().isEmpty();
        
        if (hasCurrentPwd || hasNewPwd) {
            if (!userService.checkPassword(currentUser, currentPassword)) {
                redirectAttributes.addFlashAttribute("errorMessage", "Incorrect current password!");
                return "redirect:/profile/edit";
            }
            
            if (newPassword == null || !newPassword.equals(confirmPassword)) {
                redirectAttributes.addFlashAttribute("errorMessage", "New passwords do not match!");
                return "redirect:/profile/edit";
            }
           
            User liveUser = userService.getUserById(currentUser.getId());            
            if (liveUser != null) {
                // 2. Pass the live database entity to update the credentials
                userService.updatePassword(liveUser, newPassword);
                
                // 3. Sync both the local pointer and session context with the newly hashed password
                currentUser.setPasswordHash(liveUser.getPasswordHash());
                session.setAttribute("currentUser", currentUser);
            }
        }

        try {
            UserProfile existingProfile = userService.getUserProfileByUserId(currentUser.getId());
            
            if (existingProfile != null) {
                existingProfile.setFullName(formProfile.getFullName());
                existingProfile.setBio(formProfile.getBio());
                
                if (avatarFile != null && !avatarFile.isEmpty()) {
                    existingProfile.setAvatar(avatarFile.getBytes());
                }
                
                userService.updateUserProfile(existingProfile);
            } else {
                if (avatarFile != null && !avatarFile.isEmpty()) {
                    formProfile.setAvatar(avatarFile.getBytes());
                }
                formProfile.setUser(currentUser);
                userService.updateUserProfile(formProfile);
            }
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating profile details.");
            return "redirect:/profile/edit";
        }

        return "redirect:/profile";
    }
    
    @GetMapping("/settings")
    public String showSettingsSpace(HttpSession session, Model model) {
        User current = (User) session.getAttribute("currentUser");
        UserPreference pref = userService.getUserPreferenceByUserId(current.getId());
        if (pref == null) {
            pref = new UserPreference(); 
        }
        
        model.addAttribute("userPreference", pref);
        return "profile/account-settings";
    }

    @PostMapping("/settings/save")
    public String saveSettingsAction(
            @ModelAttribute("userPreference") UserPreference incomingPref,
            HttpSession session) {
        User current = (User) session.getAttribute("currentUser");
        UserPreference existing = userService.getUserPreferenceByUserId(current.getId());
        if (existing != null) {
            existing.setTheme(incomingPref.getTheme());
            existing.setLanguageCode(incomingPref.getLanguageCode());
            existing.setEmailNotifications(incomingPref.getEmailNotifications());
            existing.setPushNotifications(incomingPref.getPushNotifications());
            existing.setAllowMessages(incomingPref.getAllowMessages());
            existing.setProfileVisibility(incomingPref.getProfileVisibility());
            userService.saveUserPreference(existing);
        } else {
            incomingPref.setUser(current);
            userService.saveUserPreference(incomingPref);
        }
        
        return "redirect:/settings";
    }
    
    @PostMapping("/user/follow")
    public String followAction(@RequestParam("targetId") int targetId, HttpSession session) {
        User current = (User) session.getAttribute("currentUser");
        
        if (current == null) {
            return "redirect:/login";
        }
        
        if (current.getId().longValue() == targetId) {
            return "redirect:/profile?id=" + targetId;
        }
        
        userService.followUser(current.getId(), targetId);
        return "redirect:/profile?id=" + targetId;
    }

    @PostMapping("/user/unfollow")
    public String unfollowAction(@RequestParam("targetId") int targetId, HttpSession session) {
        User current = (User) session.getAttribute("currentUser");
        
        if (current == null) {
            return "redirect:/login";
        }
        
        userService.unfollowUser(current.getId(), targetId);
        return "redirect:/profile?id=" + targetId;
    }

    
    @GetMapping("/admin/users")
    public String listAllUsers(Model model) {
        List<User> userList = userService.getAllUsers();
        model.addAttribute("users", userList);
        return "admin/admin-user-management"; 
    }

    @PostMapping("/admin/users/update-status")
    public String updateStatusAndRole(
            @RequestParam("userId") int userId,
            @RequestParam("role") String roleStr,
            @RequestParam("status") String statusStr) {
            
        userService.updateUserRoleAndStatus(userId, Role.valueOf(roleStr), UserStatus.valueOf(statusStr));
        return "redirect:/admin/users";
    }

    @GetMapping("/admin/users/edit")
    public String showAdminEditUserPage(@RequestParam("id") Long userId, Model model) {
        model.addAttribute("targetUser", userService.getUserById(userId));
        return "admin/admin-edit-user";
    }

    @GetMapping("/admin/users/delete")
    public String deleteUserAccount(@RequestParam("id") int userId) {
        userService.softDeleteUser(userId);
        return "redirect:/admin/users";
    }

    @GetMapping("/logout")
    public String processLogout(HttpSession session) {
        session.invalidate();
        SecurityContextHolder.clearContext();
        return "redirect:/?logout=true";
    }
    @GetMapping("/admin/dashboard")
    public String showAdminDashboard(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        // Statistics
        model.addAttribute("totalPosts", postService.countAllPosts());
        model.addAttribute("pendingPosts", postService.countPendingPosts());
        model.addAttribute("totalUsers", userService.countAllUsers());
        model.addAttribute("totalComments", commentService.countAllComments());
        
        // ✅ JSP က WEB-INF/views/admin/admin-dashboard.jsp မှာရှိတယ်
        return "admin/admin-dashboard";
    }

    
}
