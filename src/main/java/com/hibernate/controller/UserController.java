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

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("profile", new UserProfile());
        return "register"; 
    }

    @PostMapping("/register")
    public String processRegistration(
            @ModelAttribute("user") User user, 
            @ModelAttribute("profile") UserProfile profile, 
            @RequestParam("avatarFile") MultipartFile avatarFile, // 👈 ဓါတ်ပုံဖိုင်လှမ်းဖမ်းခြင်း
            HttpServletRequest request,
            Model model) {
        
        try {
        	// 📸 ပုံဖိုင် ပါလာခဲ့ရင် byte[] အဖြစ်ပြောင်းပြီး တိုက်ရိုက်သိမ်းမယ်
            if (avatarFile != null && !avatarFile.isEmpty()) {
                profile.setAvatar(avatarFile.getBytes()); // 👈 byte array အဖြစ် တိုက်ရိုက်ထည့်ခြင်း
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Image saving is Failed, Try again");
            return "register";
        }
        
        // Service သို့ လွှဲပေးပြီး Save မည်
        boolean isSuccess = userService.registerNewUser(user, profile);
        
        if (isSuccess) {
            model.addAttribute("msg", "Account Created Successfully");
            return "index"; 
        } else {
            model.addAttribute("error", "This Email is already extisted!");
            return "register"; 
        }
    }
    @GetMapping("/login")
    public String showLoginForm() {
    	return "login";
    }
    @PostMapping("/login")
    public String processLogin(@RequestParam("email") String email,
    							@RequestParam("password") String password,
    							HttpSession session,
    							Model model) {
    	
    	User logginUser = userService.authenticateUser(email, password);
    	
    	if(logginUser != null) {
    		
    		session.setAttribute("currentUser",logginUser);
    		if("ADMIN".equalsIgnoreCase(logginUser.getRole())) {
    			return"redirect:/admin/dashboard";
    		}else {
        		return "redirect:/";
    		}
    	}else {
    		model.addAttribute("error", "Something Wrong");
    		return "redirect:/login";	
    	}
    }
    @GetMapping("/admin/dashboard")
    public String showAdminDashboard(HttpSession session) {
        // Session ထဲကနေ Object ကို ယူပြီး 'adminUser' ထဲ ထည့်လိုက်ခြင်း
        User adminUser = (User) session.getAttribute("currentUser");
        
        // Security Check: Login မဝင်ထားရင် သော်လည်းကောင်း၊ ADMIN မဟုတ်ရင် သော်လည်းကောင်း မောင်းထုတ်မည်
        // 💡 currentUser နေရာမှာ အပေါ်က ကြေညာခဲ့တဲ့ adminUser ကို ပြောင်းလဲအသုံးပြုထားပါတယ်
        if (adminUser == null || !"ADMIN".equalsIgnoreCase(adminUser.getRole())) {
            return "redirect:/login"; 
        }
        
        return "admin-dashboard"; // admin-dashboard.jsp ကို ပြသမည်
    }
    

    

}