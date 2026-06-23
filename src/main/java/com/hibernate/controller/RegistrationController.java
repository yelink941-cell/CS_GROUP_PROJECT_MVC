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

    // 1. Register Form ကို စတင်ခေါ်ယူခြင်း
    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("registrationDto", new RegistrationDto());
        return "register";
    }

    // 2. Data များအားလုံးကို DTO တစ်ခုတည်းနဲ့ လက်ခံခြင်း
    @PostMapping("/register")
    public String registerUser(@ModelAttribute("registrationDto") RegistrationDto dto, Model model) {
        try {
            // Debug စစ်ရန်အတွက် (Console မှာကြည့်ပါ)
            System.out.println("DEBUG: Username received: " + dto.getUsername());
            System.out.println("DEBUG: Email received: " + dto.getEmail());
            
            // Service ထဲမှာ Logic အပြည့်အစုံရေးထားဖို့ လိုပါတယ်
            User registeredUser = userService.registerNewUser(dto);
            
            model.addAttribute("userId", registeredUser.getId());
            return "success-page"; 

        } catch (IllegalArgumentException e) {
            // Password မကိုက်တာမျိုးဆို ဒီမှာဖမ်းပါတယ်
            model.addAttribute("errorMessage", e.getMessage());
            return "register"; 
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("errorMessage", "စနစ်ချို့ယွင်းမှု တစ်ခုဖြစ်ပွားခဲ့ပါသည်။");
            return "register";
        }
    }
}