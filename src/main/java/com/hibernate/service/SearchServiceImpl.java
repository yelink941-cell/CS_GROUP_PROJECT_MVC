package com.hibernate.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.hibernate.entity.SearchHistory;
import com.hibernate.entity.User;
import com.hibernate.entity.Category;
import com.hibernate.entity.Post;
import com.hibernate.repository.SearchHistoryRepository;
import com.hibernate.repository.UserRepository;

@Service
@Transactional
public class SearchServiceImpl implements SearchService {

    @Autowired
    private SearchHistoryRepository searchHistoryRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void saveSearchQuery(int userId, String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) { return; }
        
        String cleanKeyword = keyword.trim();
        
        // ၁။ ဒီ User ဟာ ဒီ Keyword ကို ရှာဖူးသလား Repository ကနေ အရင်လှမ်းစစ်မယ်
        SearchHistory existingHistory = searchHistoryRepository.findByUserIdAndKeyword(userId, cleanKeyword);
        
        if (existingHistory != null) {
            // ၂။ ရှိပြီးသားဖြစ်နေရင် Row အသစ်ထပ်မတိုးတော့ဘဲ ရှာဖွေခဲ့တဲ့ အချိန် (Timestamp) ကိုပဲ လက်ရှိအချိန်အတိုင်း Update လုပ်ပေးမယ်
            existingHistory.setSearchedAt(java.time.LocalDateTime.now());
            searchHistoryRepository.save(existingHistory);
        } else {
            // ၃။ လုံးဝအသစ်ဆိုမှသာ Record အသစ်တစ်ခု တည်ဆောက်ပြီး ဒေတာထဲ သိမ်းဆည်းမယ်
            Optional<User> userOptional = userRepository.findById((long) userId); 
            if (userOptional.isPresent()) {
                User user = userOptional.get();
                SearchHistory history = new SearchHistory();
                history.setKeyword(cleanKeyword);
                history.setUser(user); 
                history.setSearchedAt(java.time.LocalDateTime.now());
                searchHistoryRepository.save(history);
            }
        }
    }

    @Override
    public List<SearchHistory> getSearchHistoryByUserId(int userId) {
        return searchHistoryRepository.findByUserId(userId);
    }

    @Override
    public Map<String, List<?>> searchEverything(String keyword) {
        Map<String, List<?>> results = new HashMap<>();
        String searchParam = "%" + keyword.trim().toLowerCase() + "%";

        // ၁။ Categories ထဲမှာ လိုက်ရှာခြင်း
        String catHql = "FROM Category c WHERE LOWER(c.name) LIKE :kw OR LOWER(c.description) LIKE :kw";
        List<Category> categories = sessionFactory.getCurrentSession()
                .createQuery(catHql, Category.class)
                .setParameter("kw", searchParam)
                .getResultList();
        results.put("categories", categories);

        // ၂။ Users ထဲမှာ လိုက်ရှာခြင်း
        List<User> users = userRepository.searchByUsername(keyword.trim(), 0L, 10);
        results.put("users", users);

        // 🎯 ၃။ Cheat Sheets (Posts) ထဲမှာ လိုက်ရှာခြင်း (Error တက်စေတဲ့ p.isPublic ဖယ်ရှားပြီးသား)
        String postHql = "FROM Post p WHERE LOWER(p.title) LIKE :kw OR LOWER(p.excerpt) LIKE :kw";
        List<Post> posts = sessionFactory.getCurrentSession()
                .createQuery(postHql, Post.class)
                .setParameter("kw", searchParam)
                .getResultList();
        results.put("posts", posts);

     // 🎯 Find this block in SearchServiceImpl.java (around lines 89-95)
     // Change the query string to include: JOIN FETCH c.user
     String colHql = "FROM Collection c JOIN FETCH c.user WHERE LOWER(c.name) LIKE :kw";
     List<?> collections = sessionFactory.getCurrentSession()
             .createQuery(colHql)
             .setParameter("kw", searchParam)
             .getResultList();
     results.put("collections", collections);

        return results;
    }

    @Override
    public void deleteHistory(int historyId) {
        searchHistoryRepository.deleteById(historyId);
    }
}