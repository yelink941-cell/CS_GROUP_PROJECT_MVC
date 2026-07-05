package com.hibernate.service;

import java.util.List;
import java.util.Map;
import com.hibernate.entity.SearchHistory;

public interface SearchService {
    
    // 🔎 Category ရော User ပါ ပေါင်းပြီး ရှာဖွေပေးမည့် Method
    Map<String, List<?>> searchEverything(String keyword);
    
    // 🕒 ရိုက်ရှာခဲ့သမျှ သမိုင်းမှတ်တမ်းကို DB ထဲ သိမ်းမည့် Method
    void saveSearchQuery(int userId, String keyword);
    
    // 🗑️ သမိုင်းမှတ်တမ်းကို ဖျက်ပစ်မည့် Method
    void deleteHistory(int historyId);
    
    // 📂 သမိုင်းမှတ်တမ်းကို User ID (int) ဖြင့် ပြန်လည်ဆွဲထုတ်မည့် Method
    List<SearchHistory> getSearchHistoryByUserId(int userId);
    // ✅ New method for suggestions
    List<String> getSearchSuggestions(int userId, String query);
    
}