package com.hibernate.service;

import com.hibernate.entity.Bookmark;
import com.hibernate.entity.Post;
import com.hibernate.entity.User;
import com.hibernate.repository.PostRepository;
import com.hibernate.repository.BookmarkRepository;
import com.hibernate.repository.UserRepository;

import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class BookmarkServiceImpl implements BookmarkService {

    private final BookmarkRepository bookmarkRepository;
    private final PostRepository postRepository;
    private final UserRepository userRepository;

    @Override
    public boolean toggleBookmark(Long userId, Integer postId) {
        Optional<Bookmark> existingBookmark = bookmarkRepository.findByUserIdAndPostId(userId, postId);

        if (existingBookmark.isPresent()) {
            bookmarkRepository.delete(existingBookmark.get());
            return false; // Bookmark un-toggled (removed)
        } else {
            Post post = postRepository.findById(postId)
                    .orElseThrow(() -> new IllegalArgumentException("Post not found"));
            
            User user = userRepository.getUserById(userId);
            if (user == null) {
                throw new IllegalArgumentException("User not found");
            }

            Bookmark newBookmark = new Bookmark();
            newBookmark.setPost(post);
            newBookmark.setUser(user);
            
            bookmarkRepository.save(newBookmark);
            return true; // Bookmark toggled on (saved)
        }
    }

    @Override
    public long getBookmarkCount(Integer postId) {
        return bookmarkRepository.countByPostId(postId);
    }

    @Override
    public boolean hasUserBookmarked(Long userId, Integer postId) {
        return bookmarkRepository.existsByUserIdAndPostId(userId, postId);
    }
    
    @Override
    public List<Post> getBookmarksByUserId(Long userId) {
        // 🟢 Repository မှတစ်ဆင့် user ၏ bookmark လုပ်ထားသော post များကို ဆွဲထုတ်ခြင်း
        return bookmarkRepository.findPostsByUserId(userId);
    }
}