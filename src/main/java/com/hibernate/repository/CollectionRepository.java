package com.hibernate.repository;

import com.hibernate.entity.Collection;
import com.hibernate.entity.Post; // 🎯 Post Entity အတွက် Import တိုးပေးပါ
import java.util.List;
import java.util.Optional;

public interface CollectionRepository {
    Collection save(Collection collection);
    Collection update(Collection collection);
    void delete(Integer id);
    Optional<Collection> findById(Integer id);
    List<Collection> findByUserId(Long userId);
    List<Collection> findPublicCollections();
    
    // 🎯 🌟 ဖိုဒါ ID ကို သုံးပြီး ၎င်းထဲတွင် သိမ်းထားသမျှ Post များကို ဆွဲထုတ်ပေးမည့် မက်သတ်အသစ်
    List<Post> findPostsByCollectionId(Integer collectionId);
    void removePostFromCollection(Integer collectionId, Integer postId);
}