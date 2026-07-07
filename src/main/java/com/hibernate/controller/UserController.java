package com.hibernate.controller;

import com.hibernate.dto.RegistrationDto;
import com.hibernate.entity.Post;
import com.hibernate.entity.User;
import com.hibernate.entity.UserPreference;
import com.hibernate.entity.UserProfile;
import com.hibernate.entity.enums.Role;
import com.hibernate.entity.enums.UserStatus;
import com.hibernate.service.CollectionService;
import com.hibernate.service.CommentService;
import com.hibernate.service.PostLikeService;
import com.hibernate.service.PostService;
import com.hibernate.service.UserService;

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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class UserController {

    private final UserService userService;
    private final JavaMailSender mailSender;
    private final PostService postService;
    private final PostLikeService postLikeService;
    private final CommentService commentService;
    private final CollectionService collectionService;  // ✅ CollectionService ထည့်ပါ

    // Constructor
    public UserController(UserService userService, 
                          JavaMailSender mailSender,
                          PostService postService,
                          PostLikeService postLikeService,
                          CommentService commentService,
                          CollectionService collectionService) {
        this.userService = userService;
        this.mailSender = mailSender;
        this.postService = postService;
        this.postLikeService = postLikeService;
        this.commentService = commentService;
        this.collectionService = collectionService;
    }

    // =========================================================
    // REGISTER
    // =========================================================
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

    // =========================================================
    // LOGIN
    // =========================================================
    @GetMapping("/login")
    public String showLoginForm(@RequestParam(value = "error", required = false) String error,
                                HttpServletRequest request,
                                Model model) {
        if ("inactive".equals(error)) {
            model.addAttribute("loginError", "Your account is currently inactive. Please contact the administrator.");
        }

        HttpSession session = request.getSession(false);
        if (session != null) {
            Object lastEx = session.getAttribute("SPRING_SECURITY_LAST_EXCEPTION");
            if (lastEx instanceof Exception) {
                String exMsg = ((Exception) lastEx).getMessage();
                if (exMsg != null && (exMsg.contains("banned") || exMsg.contains("suspended") || exMsg.contains("restricted"))) {
                    model.addAttribute("banError", exMsg);
                }
            }
            if (session.getAttribute("banError") != null) {
                model.addAttribute("banError", session.getAttribute("banError"));
                session.removeAttribute("banError");
            }
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
                // LOGIC BLOCK: If user account is FULL BANNED, block access immediately
                if (user.isFullBanned()) {
                    String reason = (user.getBanReason() != null && !user.getBanReason().trim().isEmpty())
                            ? user.getBanReason()
                            : "Violation of community guidelines";
                    String banMsg = "Your account has been banned. Reason: " + reason + " (" + user.getBanRemainingText() + ")";
                    session.setAttribute("banError", banMsg);
                    session.invalidate();
                    SecurityContextHolder.clearContext();
                    return;
                }

                // LOGIC BLOCK: If user account is marked INACTIVE, block access immediately
                if (user.getStatus() == UserStatus.INACTIVE) {
                    session.invalidate();
                    SecurityContextHolder.clearContext();
                    return;
                }
                
                if (session.getAttribute("currentUser") == null) {
                    session.setAttribute("currentUser", user);
                    session.setAttribute("userId", user.getId());
                    
                    // ✅ Login ဝင်တာနဲ့ Default Collection Create လုပ်ပါ
                    createDefaultCollectionIfNotExists(user);
                }
            }
        }
    }

    // ✅ Default Collection Auto Create Method
    private void createDefaultCollectionIfNotExists(User user) {
        try {
            Long userId = user.getId();
            
            // User ရဲ့ Collection တွေကိုယူ
            List<com.hibernate.entity.Collection> collections = collectionService.getCollectionsByUserId(userId);
            
            // Collection မရှိဘူးဆိုရင် Default Collection Create လုပ်ပါ
            if (collections.isEmpty()) {
                collectionService.createCollection(
                    "My Collection", 
                    "A collection of my favorite cheat sheets.", 
                    false,
                    userId
                );
                System.out.println("✅ Default collection created for user: " + user.getUsername());
            }
        } catch (Exception e) {
            System.err.println("❌ Error creating default collection: " + e.getMessage());
        }
    }

    // =========================================================
    // FORGOT PASSWORD
    // =========================================================
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

    // =========================================================
    // PROFILE
    // =========================================================
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

        // --- 3. Dynamically filter what platform sheets the user LIKED ---
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
    @GetMapping("/profile/view")
    public String viewPublicProfile(@RequestParam("id") Long targetUserId, HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        
        // 1. If they clicked on themselves in the search results, route them to their personal profile dashboard
        if (currentUser != null && currentUser.getId().equals(targetUserId)) {
            return "redirect:/profile";
        }
        
        // 2. Fetch the Target User's Profile Info
        UserProfile targetProfile = userService.getUserProfileByUserId(targetUserId);
        if (targetProfile != null && targetProfile.getAvatar() != null) {
            String base64Avatar = Base64.getEncoder().encodeToString(targetProfile.getAvatar());
            model.addAttribute("avatarImage", base64Avatar);
        }
        
        User targetUser = userService.getUserById(targetUserId);
        if (targetUser == null) {
            return "redirect:/?error=UserNotFound";
        }

        // Load metrics for the target user profile
        long followerCount = userService.getFollowerCount(targetUserId);
        long followingCount = userService.getFollowingCount(targetUserId);
        long postCount = userService.getPostCountByUserId(targetUserId);
        
        // Check if the currently logged-in user is following this target user
        boolean isFollowing = false;
        if (currentUser != null) {
            List<User> followers = userService.getFollowersByUserId(targetUserId);
            isFollowing = followers.stream().anyMatch(u -> u.getId().equals(currentUser.getId()));
        }

        // ⭐ FIX: FETCH BOTH LISTS FOR THE TARGET USER AND ADD THEM TO THE MODEL ⭐
        List<User> followersList = userService.getFollowersByUserId(targetUserId);
        List<User> followingList = userService.getFollowingByUserId(targetUserId);
        model.addAttribute("followersList", followersList);
        model.addAttribute("followingList", followingList);

        model.addAttribute("userProfile", targetProfile);
        model.addAttribute("profileOwner", targetUser);
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("followerCount", followerCount);
        model.addAttribute("followingCount", followingCount);
        model.addAttribute("postCount", postCount);
        model.addAttribute("isFollowing", isFollowing);

        // 3. Fetch ONLY the target user's public posts
        List<Post> userPosts = postService.getPostsByAuthorId(targetUserId);
        model.addAttribute("userPosts", userPosts);

        // Build the like count map for their post cards
        Map<Integer, Long> postLikeCounts = new java.util.HashMap<>();
        if (userPosts != null) {
            for (Post post : userPosts) {
                postLikeCounts.put(post.getId(), postLikeService.getLikeCount(post.getId()));
            }
        }
        model.addAttribute("postLikeCounts", postLikeCounts);

        return "profile/profile"; 
    }

    @GetMapping("/profile/edit")
    public String showEditProfilePage(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
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

                userService.updateUserProfile(existingProfile);
            } else {
                updatedProfile.setUser(currentUser);
                userService.updateUserProfile(updatedProfile);
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Failed to update profile settings.");
            return "profile/edit-profile";
        }
        
        return "redirect:/profile";
    }
    
    
    
    @PostMapping("/user/follow")
    public String followAction(@RequestParam("targetId") Long targetId, HttpServletRequest request, HttpSession session) {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
        userService.followUser(current.getId(), targetId);
        
        String referer = request.getHeader("Referer");
        return "redirect:" + (referer != null ? referer : "/posts/public");
    }

    @PostMapping("/user/unfollow")
    public String unfollowAction(@RequestParam("targetId") Long targetId, HttpServletRequest request, HttpSession session) {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
        userService.unfollowUser(current.getId(), targetId);
        
        String referer = request.getHeader("Referer");
        return "redirect:" + (referer != null ? referer : "/posts/public");
    }

    // =========================================================
    // ADMIN - DASHBOARD
    // =========================================================
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
        
        return "admin/admin-dashboard";
    }

    // =========================================================
    // ADMIN - USER MANAGEMENT
    // =========================================================
    @GetMapping("/admin/users")
    public String listAllUsers(
            @RequestParam(value = "page", required = false, defaultValue = "1") int page,
            @RequestParam(value = "search", required = false) String search,
            Model model,
            HttpSession session) {
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != Role.ADMIN) {
            return "redirect:/login";
        }
        
        int pageSize = 10; 

        List<User> userList = userService.getAllUsersPaginated(page, pageSize, search);
        long totalUsers = userService.getTotalUserCount(search);
        
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }

        model.addAttribute("users", userList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalUsers", totalUsers);
        
        // Statistics for cards
        long activeUsers = userList.stream()
                .filter(u -> u.getStatus() != null && u.getStatus() == UserStatus.ACTIVE)
                .count();
        model.addAttribute("activeUsers", activeUsers);
        
        long inactiveUsers = userList.stream()
                .filter(u -> u.getStatus() != null && u.getStatus() == UserStatus.INACTIVE)
                .count();
        model.addAttribute("inactiveUsers", inactiveUsers);
        model.addAttribute("suspendedUsers", 0);
        
        return "admin/admin-user-management"; 
    }

    // =========================================================
    // ADMIN - UPDATE USER STATUS & ROLE
    // =========================================================
    @PostMapping("/admin/users/update-status")
    public String updateStatusAndRole(
            @RequestParam("userId") Long userId,
            @RequestParam("role") String roleStr,
            @RequestParam("status") String statusStr,
            RedirectAttributes redirectAttributes,
            HttpSession session) {
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != Role.ADMIN) {
            return "redirect:/login";
        }
        
        try {
            userService.updateUserRoleAndStatus(userId, Role.valueOf(roleStr), UserStatus.valueOf(statusStr));
            redirectAttributes.addFlashAttribute("successMessage", "User updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating user: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }

    // =========================================================
    // ADMIN - EDIT USER
    // =========================================================
    @GetMapping("/admin/users/edit")
    public String showAdminEditUserPage(@RequestParam("id") Long userId, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != Role.ADMIN) {
            return "redirect:/login";
        }
        model.addAttribute("targetUser", userService.getUserById(userId));
        return "admin/admin-edit-user";
    }

    // =========================================================
    // ADMIN - DELETE USER
    // =========================================================
    @GetMapping("/admin/users/delete")
    public String deleteUserAccount(@RequestParam("id") Long userId, 
                                    RedirectAttributes redirectAttributes,
                                    HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != Role.ADMIN) {
            return "redirect:/login";
        }
        try {
            userService.softDeleteUser(userId);
            redirectAttributes.addFlashAttribute("successMessage", "User deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error deleting user: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }

    // =========================================================
    // LOGOUT
    // =========================================================
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