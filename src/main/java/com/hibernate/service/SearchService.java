package com.hibernate.service;

import java.util.List;
import com.hibernate.entity.SearchHistory;

public interface SearchService {
    void saveSearchQuery(int userId, String keyword);
    List<SearchHistory> getSearchHistoryByUserId(int userId);
}