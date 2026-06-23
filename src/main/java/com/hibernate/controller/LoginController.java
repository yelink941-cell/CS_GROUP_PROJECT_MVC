package com.hibernate.controller;

import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.ui.Model;
import com.hibernate.entity.User;
import com.hibernate.repository.UserRepository;
import java.util.Optional; // Optional ကို import လုပ်ပေးပါ

@Controller
public class LoginController {

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/login")
    public String showLoginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam("email") String email,
                        @RequestParam("password") String password,
                        HttpSession session,
                        Model model) {

        Optional<User> userOptional = userRepository.findByEmail(email);

        if (userOptional.isPresent()) {

            User user = userOptional.get();

            if (user.getPasswordHash().equals(password)) {

                session.setAttribute("user", user);

                System.out.println("LOGIN SUCCESS");
                System.out.println("USER = " + user.getUsername());
                System.out.println("SESSION = " + session.getAttribute("user"));

                return "redirect:/";
            }
        }

        model.addAttribute("error", "Invalid Email or Password!");
        return "login";
    }
}