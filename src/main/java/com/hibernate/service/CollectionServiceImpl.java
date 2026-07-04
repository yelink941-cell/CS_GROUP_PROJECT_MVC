package com.hibernate.service;

import com.hibernate.entity.Collection;
import com.hibernate.entity.Post;
import com.hibernate.entity.User;
import com.hibernate.repository.CollectionRepository;
import com.hibernate.repository.PostRepository;
import com.hibernate.repository.UserRepository;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class CollectionServiceImpl implements CollectionService {
    private final CollectionRepository collectionRepository;
    private final PostRepository postRepository;
    private final UserRepository userRepository;

    @Override
    public Collection createCollection(String name, String description, Boolean isPublic, Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        Collection collection = new Collection();
        collection.setName(name);
        collection.setDescription(description);
        collection.setIsPublic(isPublic != null ? isPublic : false);
        collection.setUser(user);
        collection.setPosts(new ArrayList<>());

        return collectionRepository.save(collection);
    }

    @Override
    public Collection updateCollection(Integer id, String name, String description, Boolean isPublic) {
        Collection collection = collectionRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Collection not found"));
        
        collection.setName(name);
        collection.setDescription(description);
        collection.setIsPublic(isPublic != null ? isPublic : false);
        
        return collectionRepository.update(collection);
    }

    @Override
    public void deleteCollection(Integer id) {
        collectionRepository.delete(id);
    }

    @Override
    public Optional<Collection> getCollectionById(Integer id) {
        return collectionRepository.findById(id);
    }

    @Override
    public List<Collection> getCollectionsByUserId(Long userId) {
        return collectionRepository.findByUserId(userId);
    }

    @Override
    public List<Collection> getPublicCollections() {
        return collectionRepository.findPublicCollections();
    }

    @Override
    public void addPostToCollection(Integer collectionId, Integer postId) {
        Collection collection = collectionRepository.findById(collectionId)
                .orElseThrow(() -> new IllegalArgumentException("Collection not found"));
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Post not found"));

        if (!collection.getPosts().contains(post)) {
            collection.getPosts().add(post);
            collectionRepository.update(collection);
        }
    }

    @Override
    public void removePostFromCollection(Integer collectionId, Integer postId) {
        // 🎯 🌟 နည်းလမ်း (၁) - Repository ထဲက SQL Delete Query ကို တိုက်ရိုက် လှမ်းခေါ်ခြင်း
        collectionRepository.removePostFromCollection(collectionId, postId);
    }

    @Override
    public List<Post> getPostsByCollectionId(Integer collectionId) {
        // Repo ထဲက ရေးခဲ့တဲ့ Custom Query မက်သတ်ကို တိုက်ရိုက် လှမ်းခေါ်ပြီး ပြန်ပေးခြင်း
        return collectionRepository.findPostsByCollectionId(collectionId);
    }
}