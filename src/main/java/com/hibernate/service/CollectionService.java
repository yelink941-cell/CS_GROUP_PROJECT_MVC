package com.hibernate.service;

import com.hibernate.entity.Collection;
import com.hibernate.entity.Post;

import java.util.List;
import java.util.Optional;

public interface CollectionService {
    Collection createCollection(String name, String description, Boolean isPublic, Long userId);
    Collection updateCollection(Integer id, String name, String description, Boolean isPublic);
    void deleteCollection(Integer id);
    Optional<Collection> getCollectionById(Integer id);
    List<Collection> getCollectionsByUserId(Long userId);
    List<Collection> getPublicCollections();
    List<Post> getPostsByCollectionId(Integer collectionId);
    
    // 📁 Post များကို Collection ထဲသို့ ပေါင်းထည့်ခြင်းနှင့် ဖယ်ထုတ်ခြင်း လုပ်ဆောင်ချက်များ
    void addPostToCollection(Integer collectionId, Integer postId);
    void removePostFromCollection(Integer collectionId, Integer postId);

}