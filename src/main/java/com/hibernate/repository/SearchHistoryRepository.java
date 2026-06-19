package com.hibernate.repository;

import java.util.List;
import com.hibernate.entity.SearchHistory;

public interface SearchHistoryRepository {
    void save(SearchHistory searchHistory);
    List<SearchHistory> findByUserId(int userId);
}