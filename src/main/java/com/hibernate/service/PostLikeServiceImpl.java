package com.hibernate.service;

import com.hibernate.entity.Post;
import com.hibernate.entity.PostLike;
import com.hibernate.entity.User;
import com.hibernate.repository.PostLikeRepository;
import com.hibernate.repository.PostRepository;
import com.hibernate.repository.UserRepository;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class PostLikeServiceImpl implements PostLikeService {

    private final PostLikeRepository postlikeRepository;
    private final PostRepository postRepository;
    private final UserRepository userRepository;

    @Override
    @Transactional
    public void toggleLike(Integer postId, Long userId) {
        // userId မှာ Long အမျိုးအစားဖြစ်ပြီးသားမို့ .longValue() ထပ်ထည့်ရန် မလိုတော့ပါ
        Optional<PostLike> existingLike = postlikeRepository.findByPostIdAndUserId(postId, userId);

        if (existingLike.isPresent()) {
            // Like ပေးပြီးသားဖြစ်နေလျှင် Unlike လုပ်သည် (Delete)
            postlikeRepository.delete(existingLike.get());
        } else {
            // Like မပေးရသေးလျှင် အသစ်ထည့်သည် (Save)
            Post post = postRepository.findById(postId)
                    .orElseThrow(() -> new IllegalArgumentException("Post not found"));
            
            User user = userRepository.getUserById(userId);
            if (user == null) {
                throw new IllegalArgumentException("User not found");
            }

            PostLike newLike = new PostLike();
            newLike.setPost(post);
            newLike.setUser(user);
            
            postlikeRepository.save(newLike);
        }
    }

    @Override
    public long getLikeCount(Integer postId) {
        return postlikeRepository.countByPostId(postId);
    }

    @Override
    public boolean hasUserLiked(Integer postId, Long userId) {
        // Long အမျိုးအစား userId အား တိုက်ရိုက်စစ်ဆေးခြင်း
        return postlikeRepository.findByPostIdAndUserId(postId, userId).isPresent();
    }
}