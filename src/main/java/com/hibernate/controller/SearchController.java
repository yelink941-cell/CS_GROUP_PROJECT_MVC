package com.hibernate.controller;

import java.util.List;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.hibernate.entity.SearchHistory;
import com.hibernate.service.SearchService;

@Controller
public class SearchController {

    @Autowired
    private SearchService searchService;

    // အစမ်း စမ်းသပ်ဖို့ Search Page ပြပေးတဲ့အပိုင်း
    @GetMapping("/search")
    public String showSearchPage(HttpSession session, Model model) {
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            userId = 1; // Login မပြီးသေးခင် စမ်းသပ်ဖို့ Mock ID သတ်မှတ်ထားတာပါ
        }

        List<SearchHistory> historyList = searchService.getSearchHistoryByUserId(userId);
        model.addAttribute("searchHistory", historyList);
        
        return "search"; // search.jsp ကို ညွှန်ပြတာပါ
    }

    // Search Bar ကနေ Form Submit လုပ်လိုက်ရင် ဝင်လာမယ့် နေရာ
    @PostMapping("/doSearch")
    public String doSearch(@RequestParam("keyword") String keyword, HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            userId = 1; 
        }

        searchService.saveSearchQuery(userId, keyword);
        
        // စမ်းသပ်ရလွယ်အောင် search page ဆီပဲ redirect ပြန်လုပ်ထားပါတယ်
        return "redirect:/search"; 
    }
}