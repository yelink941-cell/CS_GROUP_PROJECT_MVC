package com.hibernate.controller;

import com.hibernate.entity.User;
import com.hibernate.service.UserService;
import javax.servlet.http.HttpSession;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomePageController {

    private final UserService userService;

    // Inject your user service to fetch the account data
    public HomePageController(UserService userService) {
        this.userService = userService;
    }
    
    @GetMapping("/")
    public String homePage(HttpSession session) {
        // 1. Check Spring Security context directly to see who is logged in
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
            // 2. If the session variable is missing, force-populate it right now!
            if (session.getAttribute("currentUser") == null) {
                String identifier = auth.getName(); // Grabs the logged-in user's email
                User user = userService.findUserByEmail(identifier); 
                if (user != null) {
                    session.setAttribute("currentUser", user);
                }
            }
        }
        
        return "index";
    }
}