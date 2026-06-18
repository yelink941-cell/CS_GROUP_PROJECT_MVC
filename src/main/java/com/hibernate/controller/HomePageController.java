package com.hibernate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
<<<<<<< Updated upstream
public class HomepageController {
	
	@GetMapping("/")
=======
public class HomePageController {

    @GetMapping("/")
    
>>>>>>> Stashed changes
    public String homePage() {
        return "index";
    }
}