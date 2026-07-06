package com.hibernate.controller;

import com.hibernate.dto.RegistrationDto;
import com.hibernate.entity.Post;
import com.hibernate.entity.User;
import com.hibernate.entity.UserProfile;
import com.hibernate.entity.enums.Role;
import com.hibernate.entity.enums.UserStatus;
import com.hibernate.service.UserService;
import com.hibernate.service.PostService;    
import com.hibernate.service.PostLikeService;

import java.time.LocalDateTime;
import java.util.Base64;

import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
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
    private final PostService postService;     
    private final PostLikeService postLikeService; 

    public UserController(UserService userService, JavaMailSender mailSender,PostService postService, PostLikeService postLikeService) {
        this.userService = userService;
        this.mailSender = mailSender;
        this.postService = postService;
        this.postLikeService = postLikeService;
    }

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("registrationDto", new RegistrationDto());
        return "register";
    }

    @PostMapping("/register")
    public String processRegistration(
            @ModelAttribute("registrationDto") RegistrationDto dto,
            @RequestParam(value = "avatarFile", required = false) MultipartFile avatarFile,
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
        profile.setCountry(dto.getCountry());
        profile.setDobDay(dto.getDobDay());
        profile.setDobMonth(dto.getDobMonth());
        profile.setDobYear(dto.getDobYear());

        try {
            if (avatarFile != null && !avatarFile.isEmpty()) {
                profile.setAvatar(avatarFile.getBytes());
            }
        } catch (Exception e) {
            model.addAttribute("error", "Image processing failed. Please try again.");
            return "register";
        }

        boolean isSuccess = userService.registerNewUser(user, profile);

        if (isSuccess) {
            model.addAttribute("msg", "Account Created Successfully");
            return "login";
        }

        model.addAttribute("error", "This Email or Username is already registered!");
        return "register";
    }

    @GetMapping("/login")
    public String showLoginForm(@RequestParam(value = "error", required = false) String error, Model model) {
        if ("inactive".equals(error)) {
            model.addAttribute("loginError", "Your account is currently inactive. Please contact the administrator.");
        }
        return "login";
    }

    @ModelAttribute
    public void populateUserSession(HttpSession session) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
            String identifier = auth.getName(); 
            User user = userService.findUserByEmail(identifier); 
            
            if (user != null) {
                // 🔴 LOGIC BLOCK: If user account is marked INACTIVE, block access immediately
                if (user.getStatus() == com.hibernate.entity.enums.UserStatus.INACTIVE) {
                    session.invalidate(); // Clear out session variables
                    SecurityContextHolder.clearContext(); // Disconnect Spring Security authentication
                    return;
                }
                
                if (session.getAttribute("currentUser") == null) {
                    session.setAttribute("currentUser", user);
                    session.setAttribute("userId", user.getId());
                }
            }
        }
    }

    @GetMapping("/forgot-password")
    public String showForgotPasswordForm() {
        return "forgot-password";
    }

    @PostMapping("/forgot-password")
    public String processForgotPassword(@RequestParam("email") String email, Model model) {
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
        
        if (user.getTokenExpiryDate().isBefore(LocalDateTime.now())) {
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
    public String showUserProfilePage(HttpSession session, Model model) {
       
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        Long profileOwnerId = currentUser.getId();
        
        // --- 1. Fetch Profile Information ---
        UserProfile profile = userService.getUserProfileByUserId(profileOwnerId);
        if (profile != null && profile.getAvatar() != null) {
            String base64Avatar = Base64.getEncoder().encodeToString(profile.getAvatar());
            model.addAttribute("avatarImage", base64Avatar);
        }
        
        User profileOwner = userService.getUserById(profileOwnerId);
        long followerCount = userService.getFollowerCount(profileOwnerId);
        long followingCount = userService.getFollowingCount(profileOwnerId);
        long postCount = userService.getPostCountByUserId(profileOwnerId);
        List<User> followers = userService.getFollowersByUserId(profileOwnerId);
        List<User> following = userService.getFollowingByUserId(profileOwnerId);

        model.addAttribute("followersList", followers);
        model.addAttribute("followingList", following);

        model.addAttribute("userProfile", profile);
        model.addAttribute("profileOwner", profileOwner);
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("followerCount", followerCount);
        model.addAttribute("followingCount", followingCount);
        model.addAttribute("postCount", postCount);
        model.addAttribute("isFollowing", false);

        // --- 2. Fetch User's Created Posts (Recent Activity Tab) ---
        List<Post> userPosts = postService.getPostsByAuthorId(profileOwnerId);
        model.addAttribute("userPosts", userPosts);

        // --- 3. OPTION A FIX: Dynamically filter what platform sheets the user LIKED ---
        List<Post> allPosts = postService.getAllPosts();
        List<Post> savedPosts = new java.util.ArrayList<>();
        
        if (allPosts != null) {
            for (Post p : allPosts) {
                if (postService.hasUserLiked(p.getId(), profileOwnerId)) {
                    savedPosts.add(p);
                }
            }
        }
        model.addAttribute("savedPosts", savedPosts);

        // --- 4. Build Combined Like Mappings for All Displayed Cards ---
        Map<Integer, Long> postLikeCounts = new java.util.HashMap<>();
        
        if (userPosts != null) {
            for (Post post : userPosts) {
                postLikeCounts.put(post.getId(), postLikeService.getLikeCount(post.getId()));
            }
        }
        
        if (savedPosts != null) {
            for (Post post : savedPosts) {
                if (!postLikeCounts.containsKey(post.getId())) {
                    postLikeCounts.put(post.getId(), postLikeService.getLikeCount(post.getId()));
                }
            }
        }
        model.addAttribute("postLikeCounts", postLikeCounts);

        return "profile/profile"; 
    }

    @GetMapping("/profile/edit")
    public String showEditProfilePage(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        UserProfile profile = userService.getUserProfileByUserId(currentUser.getId());
        if (profile != null && profile.getAvatar() != null) {
            String base64Avatar = Base64.getEncoder().encodeToString(profile.getAvatar());
            model.addAttribute("avatarImage", base64Avatar);
        }
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

                userService.updateUserProfile(existingProfile);
            } else {
                updatedProfile.setUser(currentUser);
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Failed to update profile settings.");
            return "profile/edit-profile";
        }
        
        return "redirect:/profile";
    }
    
    
   
    @GetMapping("/admin-dashboard")
    public String showAdminDashboard(HttpSession session) {
        // 🟢 ပြင်ဆင်ချက်- currentUser အစား ပိုမိုကျယ်ပြန့်သော user ကိုပါ ထည့်သွင်းစစ်ဆေးပေးခြင်း 
        // (Interceptor သို့မဟုတ် Intercept အချို့ကြောင့် session key တစ်ခုခု ပြတ်တောက်သွားလျှင်ပင် အခြားတစ်ခုဖြင့် ဆက်ဖမ်းနိုင်ရန်)
        User adminUser = (User) session.getAttribute("user");
        
        if (adminUser == null) {
            adminUser = (User) session.getAttribute("currentUser");
        }
        
        if (adminUser == null || !Role.ADMIN.equals(adminUser.getRole())) {
            return "redirect:/login"; 
        }
        
        return "redirect:/settings";
    }
    
    @PostMapping("/user/follow")
    public String followAction(@RequestParam("targetId") Long targetId,HttpServletRequest request, HttpSession session) {
        User current = (User) session.getAttribute("currentUser");
        userService.followUser(current.getId(), targetId);
        
        String referer = request.getHeader("Referer");
        return "redirect:" + (referer != null ? referer : "/posts/public");
    }

    @PostMapping("/user/unfollow")
    public String unfollowAction(@RequestParam("targetId") Long targetId,HttpServletRequest request, HttpSession session) {
        User current = (User) session.getAttribute("currentUser");
        userService.unfollowUser(current.getId(), targetId);
        
        String referer = request.getHeader("Referer");
        return "redirect:" + (referer != null ? referer : "/posts/public");
    }

    @GetMapping("/admin/users")
    public String listAllUsers(
            @RequestParam(value = "page", required = false, defaultValue = "1") int page,
            @RequestParam(value = "search", required = false) String search,
            Model model) {
        
        int pageSize = 10; 

        // 🛠️ Pass the search parameter right down to the database query layers
        List<User> userList = userService.getAllUsersPaginated(page, pageSize, search);
        long totalUsers = userService.getTotalUserCount(search);
        
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }

        model.addAttribute("users", userList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        
        return "admin/admin-user-management"; 
    }
    @GetMapping("/admin/dashboard")
    public String showAdminDashboard() {
        return "admin/admin-dashboard"; 
    }

    @PostMapping("/admin/users/update-status")
    public String updateStatusAndRole(
            @RequestParam("userId") Long userId,
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
    public String deleteUserAccount(@RequestParam("id") Long userId) {
        userService.softDeleteUser(userId);
        return "redirect:/admin/users";
    }

    @GetMapping("/logout")
    public String processLogout(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            try {
                userService.updateUserOnlineStatus(currentUser.getId(), false);
            } catch (Exception e) {
                System.err.println("Failed to set offline status on logout: " + e.getMessage());
            }
        }
        session.invalidate();
        SecurityContextHolder.clearContext();
        return "redirect:/?logout=true";
    }
}
