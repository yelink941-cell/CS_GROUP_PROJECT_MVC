package com.hibernate.controller;

import com.hibernate.dto.RegistrationDto;
import com.hibernate.entity.User;
import com.hibernate.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class RegistrationController {

    private final UserService userService;

    public RegistrationController(UserService userService) {
        this.userService = userService;
    }

    // Register Form ကို စဖွင့်ပေးခြင်း
    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("registrationDto", new RegistrationDto());
        return "register"; 
    }

    // Form ကလာတဲ့ Data ကို လက်ခံပြီး Register လုပ်ပေးခြင်း
    @PostMapping("/register")
    public String registerUser(@ModelAttribute("registrationDto") RegistrationDto dto, Model model) {
        try {
            User registeredUser = userService.registerNewUser(dto);
            model.addAttribute("successMessage", "အောင်မြင်စွာ Register လုပ်ပြီးပါပြီ။ ယူဆာ ID: " + registeredUser.getId());
            model.addAttribute("registrationDto", new RegistrationDto()); // Form ပြန်ရှင်းရန်
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
        	// 🔴 ဒီစာကြောင်းကို ထည့်ပြီး Console မှာ Error ကို ဖတ်ကြည့်ပါ
            e.printStackTrace();
            model.addAttribute("errorMessage", "စနစ်ချို့ယွင်းမှု တစ်ခုဖြစ်ပွားခဲ့ပါသည်။");
        }
        return "register";
    }
}