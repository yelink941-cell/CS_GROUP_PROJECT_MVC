package com.hibernate.controller;

import com.hibernate.dto.RegistrationDto;
import com.hibernate.entity.User;
import com.hibernate.entity.UserPreference;
import com.hibernate.entity.UserProfile;
import com.hibernate.entity.enums.Role;
import com.hibernate.entity.enums.UserStatus;
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

@Controller
public class UserController {

    private final UserService userService;
    private final JavaMailSender mailSender;

    public UserController(UserService userService, JavaMailSender mailSender) {
        this.userService = userService;
        this.mailSender = mailSender;
    }

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
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

        // ❌ ဒီ line ကို ဖျက်လိုက်ပါ - password ဆိုတဲ့ variable မရှိဘူး
        // User loggedInUser = userService.authenticateUser(email, password);

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

        if (user.getTokenExpiryDate() == null || user.getTokenExpiryDate().isBefore(LocalDateTime.now())) {
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
        if (user == null || user.getTokenExpiryDate() == null || user.getTokenExpiryDate().isBefore(LocalDateTime.now())) {
            model.addAttribute("error", "Transaction session expired. Please start over.");
            return "redirect:/forgot-password";
        }

        userService.updatePassword(user, password);
        return "redirect:/login?resetSuccess=true";
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
        return "profile/profile";
    }

    @GetMapping("/profile/edit")
    public String showEditProfilePage(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        UserProfile profile = userService.getUserProfileByUserId(currentUser.getId());
        model.addAttribute("userProfile", profile);
        return "profile/edit-profile";
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
            return "profile/edit-profile";
        }

        return "redirect:/profile";
    }

    @GetMapping("/settings")
    public String showSettingsSpace(HttpSession session, Model model) {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
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
        if (current == null) {
            return "redirect:/login";
        }
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
    public String followAction(@RequestParam("targetId") Long targetId, HttpSession session) {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
        userService.followUser(current.getId(), targetId);
        return "redirect:/profile?id=" + targetId;
    }

    @PostMapping("/user/unfollow")
    public String unfollowAction(@RequestParam("targetId") Long targetId, HttpSession session) {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
        userService.unfollowUser(current.getId(), targetId);
        return "redirect:/profile?id=" + targetId;
    }

    @GetMapping("/admin/dashboard")
    public String showAdminDashboard(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != Role.ADMIN) {
            return "redirect:/login";
        }
        return "admin/admin-dashboard";
    }

    @GetMapping("/admin/users")
    public String listAllUsers(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != Role.ADMIN) {
            return "redirect:/login";
        }
        List<User> userList = userService.getAllUsers();
        model.addAttribute("users", userList);
        return "admin/admin-user-management";
    }

    @PostMapping("/admin/users/update-status")
    public String updateStatusAndRole(
            @RequestParam("userId") Long userId,
            @RequestParam("role") String roleStr,
            @RequestParam("status") String statusStr,
            HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != Role.ADMIN) {
            return "redirect:/login";
        }
        userService.updateUserRoleAndStatus(userId, Role.valueOf(roleStr), UserStatus.valueOf(statusStr));
        return "redirect:/admin/users";
    }

    @GetMapping("/admin/users/edit")
    public String showAdminEditUserPage(@RequestParam("id") Long userId, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != Role.ADMIN) {
            return "redirect:/login";
        }
        model.addAttribute("targetUser", userService.getUserById(userId));
        return "admin/admin-edit-user";
    }

    @GetMapping("/admin/users/delete")
    public String deleteUserAccount(@RequestParam("id") Long userId, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != Role.ADMIN) {
            return "redirect:/login";
        }
        userService.softDeleteUser(userId);
        return "redirect:/admin/users";
    }

    @GetMapping("/logout")
    public String processLogout(HttpSession session) {
        session.invalidate();
        SecurityContextHolder.clearContext();
        return "redirect:/?logout=true";
    }
}