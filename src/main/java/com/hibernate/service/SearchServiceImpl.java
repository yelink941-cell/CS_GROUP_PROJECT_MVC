package com.hibernate.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.hibernate.entity.SearchHistory;
import com.hibernate.entity.User;
import com.hibernate.entity.Category;
import com.hibernate.entity.Post;
import com.hibernate.entity.enums.PostStatus;
import com.hibernate.entity.enums.PostVisibility;
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

        // 👤 ၂။ Users ထဲမှာ လိုက်ရှာခြင်း (FIXED: Uses flexible pattern matching on username or email)
        String userHql = "FROM User u WHERE LOWER(u.username) LIKE :kw OR LOWER(u.email) LIKE :kw";
        List<User> users = sessionFactory.getCurrentSession()
                .createQuery(userHql, User.class)
                .setParameter("kw", searchParam)
                .setMaxResults(10)
                .getResultList();
        results.put("users", users);

        // 🎯 ၃။ Cheat Sheets (Posts) ထဲမှာ လိုက်ရှာခြင်း
        String postHql = "FROM Post p "
                + "WHERE (LOWER(p.title) LIKE :kw OR LOWER(p.excerpt) LIKE :kw) "
                + "AND p.status = :status "
                + "AND p.visibility = :visibility "
                + "AND p.deletedAt IS NULL";
        List<Post> posts = sessionFactory.getCurrentSession()
                .createQuery(postHql, Post.class)
                .setParameter("kw", searchParam)
                .setParameter("status", PostStatus.PUBLISHED)
                .setParameter("visibility", PostVisibility.PUBLIC)
                .getResultList();
        results.put("posts", posts);

        // 📦 ၄။ Collections ထဲမှာ လိုက်ရှာခြင်း
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

    @Override
    public List<String> getSearchSuggestions(int userId, String query) {
        String searchParam = "%" + query.trim().toLowerCase() + "%";
        
        List<String> historySuggestions = searchHistoryRepository.findByUserIdAndKeywordLike(userId, searchParam);
        
        List<String> categorySuggestions = sessionFactory.getCurrentSession()
                .createQuery("SELECT LOWER(c.name) FROM Category c WHERE LOWER(c.name) LIKE :kw", String.class)
                .setParameter("kw", searchParam)
                .setMaxResults(5)
                .getResultList();
        
        List<String> postSuggestions = getPublicPostSuggestions(searchParam);
        
        List<String> allSuggestions = new java.util.ArrayList<>();
        allSuggestions.addAll(historySuggestions);
        allSuggestions.addAll(categorySuggestions);
        allSuggestions.addAll(postSuggestions);
        
        return allSuggestions.stream()
                .distinct()
                .limit(10)
                .collect(Collectors.toList());
    }

    @Override
    public List<String> getPublicSearchSuggestions(String query) {
        String searchParam = "%" + query.trim().toLowerCase() + "%";

        List<String> categorySuggestions = sessionFactory.getCurrentSession()
                .createQuery("SELECT LOWER(c.name) FROM Category c WHERE LOWER(c.name) LIKE :kw", String.class)
                .setParameter("kw", searchParam)
                .setMaxResults(5)
                .getResultList();

        List<String> postSuggestions = getPublicPostSuggestions(searchParam);

        List<String> allSuggestions = new java.util.ArrayList<>();
        allSuggestions.addAll(categorySuggestions);
        allSuggestions.addAll(postSuggestions);

        return allSuggestions.stream()
                .distinct()
                .limit(10)
                .collect(Collectors.toList());
    }

    private List<String> getPublicPostSuggestions(String searchParam) {
        return sessionFactory.getCurrentSession()
                .createQuery(
                        "SELECT LOWER(p.title) FROM Post p "
                                + "WHERE LOWER(p.title) LIKE :kw "
                                + "AND p.status = :status "
                                + "AND p.visibility = :visibility "
                                + "AND p.deletedAt IS NULL",
                        String.class)
                .setParameter("kw", searchParam)
                .setParameter("status", PostStatus.PUBLISHED)
                .setParameter("visibility", PostVisibility.PUBLIC)
                .setMaxResults(5)
                .getResultList();
    }
}
