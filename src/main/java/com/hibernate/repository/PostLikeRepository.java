package com.hibernate.repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.hibernate.entity.PostLike;

@Repository
public interface PostLikeRepository extends JpaRepository<PostLike, Integer> {
    
    // User နှင့် Post ID တို့ဖြင့် Like ရှာဖွေခြင်း
    Optional<PostLike> findByPostIdAndUserId(Integer postId, Integer userId);
    
    boolean existsByPostIdAndUserId(Integer postId, Integer userId);
    // သက်ဆိုင်ရာ ပို့စ်တစ်ခုအတွက် စုစုပေါင်း Like အရေအတွက် ရေတွက်ခြင်း
    long countByPostId(Integer postId);
}