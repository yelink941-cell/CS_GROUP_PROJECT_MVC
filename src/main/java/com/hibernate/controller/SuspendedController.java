package com.hibernate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class SuspendedController {

    @GetMapping("/suspended")
    public String suspendedPage() {
        return "suspended";
    }
}
