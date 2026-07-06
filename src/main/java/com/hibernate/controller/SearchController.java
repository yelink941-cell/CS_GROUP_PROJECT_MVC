package com.hibernate.controller;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.hibernate.entity.SearchHistory;
import com.hibernate.entity.User;
import com.hibernate.service.SearchService;

@Controller
public class SearchController {

    @Autowired
    private SearchService searchService;

    // 🔎 Search Action - Full search (for form submit)
    @PostMapping("/doSearch")
    public String doSearch(@RequestParam("keyword") String keyword, HttpSession session, Model model) {
        Object loggedInUser = session.getAttribute("currentUser");
        boolean isUserLoggedIn = false;
        Long userId = 1L;

        if (loggedInUser != null) {
            isUserLoggedIn = true; 
            User userEntity = (User) loggedInUser;
            userId = userEntity.getId();
            searchService.saveSearchQuery(userId.intValue(), keyword);
        }

        // Get search results
        Map<String, List<?>> allResults = searchService.searchEverything(keyword);
        
        // Get search history (for related searches)
        List<SearchHistory> searchHistory = searchService.getSearchHistoryByUserId(userId.intValue());
        
        model.addAttribute("categoryResults", allResults.get("categories"));
        model.addAttribute("userResults", allResults.get("users"));
        model.addAttribute("postResults", allResults.get("posts"));
        model.addAttribute("collectionResults", allResults.get("collections"));
        model.addAttribute("searchHistory", searchHistory);
        model.addAttribute("searchedKeyword", keyword);
        model.addAttribute("isSearching", true); 
        model.addAttribute("isLoggedIn", isUserLoggedIn);
        
        return "index"; 
    }

    // ✅ AJAX - Live Search Suggestions
    @GetMapping("/search/suggestions")
    @ResponseBody
    public Map<String, Object> getSuggestions(@RequestParam("q") String query, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        if (query == null || query.trim().length() < 1) {
            response.put("suggestions", List.of());
            return response;
        }
        
        Object loggedInUser = session.getAttribute("currentUser");
        Long userId = 1L;
        
        if (loggedInUser != null) {
            User userEntity = (User) loggedInUser;
            userId = userEntity.getId();
        }
        
        List<String> suggestions = searchService.getSearchSuggestions(userId.intValue(), query.trim());
        
        response.put("suggestions", suggestions);
        response.put("query", query);
        
        return response;
    }

    // 🗑️ Delete Search History - ✅ STAY ON SAME PAGE
    @GetMapping("/history/delete")
    public String deleteHistory(@RequestParam("id") int historyId, 
                                @RequestParam(value = "keyword", required = false) String keyword,
                                RedirectAttributes redirectAttributes,
                                HttpSession session,
                                Model model) {
        try {
            searchService.deleteHistory(historyId);
            redirectAttributes.addFlashAttribute("successMessage", "Search history deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error deleting history: " + e.getMessage());
        }
        
        // ✅ If keyword is provided, stay on search results page
        if (keyword != null && !keyword.trim().isEmpty()) {
            return "redirect:/doSearch?keyword=" + keyword;
        }
        
        // Otherwise redirect to home
        return "redirect:/";
    }
    
    // 🔎 GET method for search (for redirect after delete)
    @GetMapping("/doSearch")
    public String getSearch(@RequestParam("keyword") String keyword, HttpSession session, Model model) {
        return doSearch(keyword, session, model);
    }
}