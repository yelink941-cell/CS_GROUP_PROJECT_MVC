package com.hibernate.service;

import com.hibernate.entity.Post;
import com.hibernate.entity.Rating;
import com.hibernate.entity.User;
import com.hibernate.repository.PostRepository;
import com.hibernate.repository.RatingRepository;
import com.hibernate.repository.UserRepository;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class RatingServiceImpl implements RatingService {

    private final RatingRepository ratingRepository;
    private final PostRepository postRepository;
    private final UserRepository userRepository;

    @Override
    public void toggleRating(Integer postId, Long userId, Integer ratingValue) {
        Optional<Rating> existingRating = ratingRepository.findByPostIdAndUserId(postId, userId);

        if (existingRating.isPresent()) {
            Rating ratingObj = existingRating.get();
            // အကယ်၍ အရင်ပေးထားသော rating နှင့် အခုပေးသော rating တူနေလျှင် (Toggle off/Delete) 
            // မတူတော့ဘူးဆိုရင် အသစ်ပြင်ပေးသည် (Update)
            if (ratingObj.getRating().equals(ratingValue)) {
                ratingRepository.delete(ratingObj);
            } else {
                ratingObj.setRating(ratingValue);
                ratingRepository.save(ratingObj);
            }
        } else {
            Post post = postRepository.findById(postId)
                    .orElseThrow(() -> new IllegalArgumentException("Post not found"));
            
            User user = userRepository.getUserById(userId);
            if (user == null) {
                throw new IllegalArgumentException("User not found");
            }

            Rating newRating = new Rating();
            newRating.setPost(post);
            newRating.setUser(user);
            newRating.setRating(ratingValue);
            
            ratingRepository.save(newRating);
        }
    }

    @Override
    public Double getAverageRating(Integer postId) {
        return ratingRepository.getAverageRatingByPostId(postId);
    }

    @Override
    public long getRatingCount(Integer postId) {
        return ratingRepository.countByPostId(postId);
    }

    @Override
    public boolean hasUserRated(Integer postId, Long userId) {
        return ratingRepository.existsByPostIdAndUserId(postId, userId);
    }
}