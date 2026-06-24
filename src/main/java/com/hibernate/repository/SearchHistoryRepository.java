package com.hibernate.repository;

import java.util.List;
import com.hibernate.entity.SearchHistory;

public interface SearchHistoryRepository {
    void save(SearchHistory history);
    void deleteById(int historyId);
    List<SearchHistory> findByUserId(int userId);
    
    // 🎯 NEW: User ID ရော Keyword ပါ ကိုက်ညီတဲ့ Record ရှိမရှိ ရှာဖွေပေးမည့် Method
    SearchHistory findByUserIdAndKeyword(int userId, String keyword);
}