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

    // Constructor Injection ဖြင့် Service ကို ချိတ်ဆက်ခြင်း
    public UserController(UserService userService) {
        this.userService = userService;
    }

    // 📝 Register Form ကို စဖွင့်ပေးခြင်း
    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("registrationDto", new RegistrationDto());
        return "register"; 
    }

    // 🚀 Form ကလာတဲ့ Data ကို လက်ခံပြီး Register လုပ်ပေးခြင်း
    @PostMapping("/register")
    public String registerUser(@ModelAttribute("registrationDto") RegistrationDto dto, Model model) {
        try {
            User registeredUser = userService.registerNewUser(dto);
            model.addAttribute("successMessage", "အောင်မြင်စွာ Register လုပ်ပြီးပါပြီ။ ယူဆာ ID: " + registeredUser.getId());
            model.addAttribute("registrationDto", new RegistrationDto()); // Form ပြန်ရှင်းရန်
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            // Console မှာ Error အပြည့်အစုံ ဖတ်ရှုရန်
            e.printStackTrace();
            model.addAttribute("errorMessage", "စနစ်ချို့ယွင်းမှု တစ်ခုဖြစ်ပွားခဲ့ပါသည်။");
        }
        return "register";
    }

    // 🔄 Login Page ကို စတင်ပြသရန်
    @GetMapping("/login")
    public String showLoginForm() {
        return "login"; 
    }

    // 🔑 Login Form တင်လိုက်ချိန်တွင် လုပ်ဆောင်ရန်
    @PostMapping("/login")
    public String processLogin(
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            HttpServletRequest request,
            Model model) {
        
        // Service Layer သို့ ပို့၍ စစ်ဆေးခိုင်းခြင်း
        User authenticatedUser = userService.loginUser(email, password);
        
        if (authenticatedUser != null) {
            // အောင်မြင်ပါက Session ထဲသို့ အသုံးပြုသူ၏ ဒေတာ သိမ်းဆည်းခြင်း
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", authenticatedUser);
            
            model.addAttribute("msg", "Welcome Back, " + authenticatedUser.getUsername() + "! 🎉");
            return "index"; // Dashboard သို့မဟုတ် Index Page သို့ ပို့မည်
        } else {
            // ကျရှုံးပါက Error Message နှင့်အတူ Login Page တွင်ပဲ ဆက်ထားမည်
            model.addAttribute("error", "Invalid Email or Password! ❌");
            return "login";
        }
    }

    // 🚪 Logout လုပ်ဆောင်ရန်
    @GetMapping("/logout")
    public String processLogout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Session ကို ဖျက်ချလိုက်ခြင်း
        }
        return "redirect:/login";
    }
}