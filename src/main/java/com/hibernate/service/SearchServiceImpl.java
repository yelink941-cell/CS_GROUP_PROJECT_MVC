package com.hibernate.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.hibernate.entity.SearchHistory;
import com.hibernate.entity.User;
import com.hibernate.repository.SearchHistoryRepository;
import com.hibernate.repository.UserRepository;

@Service
@Transactional
public class SearchServiceImpl implements SearchService {

    @Autowired
    private SearchHistoryRepository searchHistoryRepository;

    @Autowired
    private UserRepository userRepository; // Member 1 ဘက်က ဆောက်ထားတဲ့ ဇယား

    @Override
    public void saveSearchQuery(int userId, String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return;
        }

        // Member 1 ရဲ့ Method ကို သုံးပြီး UserProfile ကို အရင်ရှာတယ်
        com.hibernate.entity.UserProfile profile = userRepository.getUserProfileByUserId(userId); 
        
        if (profile != null && profile.getUser() != null) {
            User user = profile.getUser(); // Profile ထဲကနေ User Object ကို လှမ်းယူတာပါ

            SearchHistory history = new SearchHistory();
            history.setKeyword(keyword.trim());
            history.setUser(user); 

            searchHistoryRepository.save(history);
        }
    }

    @Override
    public List<SearchHistory> getSearchHistoryByUserId(int userId) {
        return searchHistoryRepository.findByUserId(userId);
    }
}