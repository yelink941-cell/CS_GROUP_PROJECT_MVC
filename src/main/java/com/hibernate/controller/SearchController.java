package com.hibernate.controller;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.hibernate.entity.SearchHistory;
import com.hibernate.entity.User;
import com.hibernate.service.SearchService;

@Controller
public class SearchController {

    @Autowired
    private SearchService searchService;

    // 🔎 Search Action
    @PostMapping("/doSearch")
    public String doSearch(@RequestParam("keyword") String keyword, HttpSession session, Model model) {
        Object loggedInUser = session.getAttribute("currentUser");
        boolean isUserLoggedIn = false;

        // 🎯 User Login ဝင်ထားခြင်း ရှိ/မရှိ စစ်ဆေးပြီး သမိုင်းမှတ်တမ်း သိမ်းဆည်းခြင်း Logic
        if (loggedInUser != null) {
            isUserLoggedIn = true; 
            User userEntity = (User) loggedInUser;
            int userId = userEntity.getId().intValue(); // Long ကို int သို့ပြောင်းလဲခြင်း
            searchService.saveSearchQuery(userId, keyword);
        }

        // 🎯 အလုံးစုံ ရှာဖွေမှုရလဒ်များကို ဆွဲထုတ်ခြင်း (Posts, Collections, Categories, Users)
        Map<String, List<?>> allResults = searchService.searchEverything(keyword);
        
        // JSP ဘက်သို့ Attribute များ စနစ်တကျ ပါးပေးခြင်း
        model.addAttribute("categoryResults", allResults.get("categories"));
        model.addAttribute("userResults", allResults.get("users"));
        model.addAttribute("postResults", allResults.get("posts"));
        model.addAttribute("collectionResults", allResults.get("collections")); // 📁 Collections (Folders)
        model.addAttribute("searchedKeyword", keyword);
        model.addAttribute("isSearching", true); 
        model.addAttribute("isLoggedIn", isUserLoggedIn);
        
        return "index"; 
    }

    // 🕒 History Action (အနီရောင်လိုင်း အမှားပြင်ဆင်ပြီးသား နေရာ)
    @GetMapping("/history")
    public String showHistoryPage(HttpSession session, Model model) {
        Object loggedInUser = session.getAttribute("currentUser");
        
        // 🎯 Type Mismatch အမှားကို ဖြေရှင်းရန် userId ကို Long ဖြင့် ကြေညာထားပါသည်
        Long userId;

        if (loggedInUser == null) {
            // Guest User အတွက် အလိုအလျောက် ID = 1L (Long) သတ်မှတ်ခြင်း
            userId = 1L; 
        } else {
            // Login ဝင်ထားလျှင် User Entity ထဲက Long ID ကို တိုက်ရိုက်ဆွဲယူခြင်း
            User userEntity = (User) loggedInUser;
            userId = userEntity.getId(); 
        }

        // 🎯 Service ဘက်က int လက်ခံထားသောကြောင့် ပို့ခါနီးမှ .intValue() ပြောင်းပြီး လှမ်းခေါ်ခြင်း
        List<SearchHistory> historyList = searchService.getSearchHistoryByUserId(userId.intValue());
        model.addAttribute("searchHistory", historyList);
        
        return "history"; 
    }

    // 🗑️ Delete Action
    @GetMapping("/history/delete")
    public String deleteHistory(@RequestParam("id") int historyId) {
        searchService.deleteHistory(historyId);
        return "redirect:/history"; 
    }
}