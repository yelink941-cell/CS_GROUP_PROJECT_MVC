package com.hibernate.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.hibernate.entity.Post;
import com.hibernate.entity.PostLike;
import com.hibernate.entity.User;
import com.hibernate.repository.PostLikeRepository;
import com.hibernate.repository.PostRepository;

@RestController
public class LikeRestController {

    @Autowired
    private PostLikeRepository postLikeRepository;

    @Autowired
    private PostRepository postRepository;

    @ResponseBody
    @PostMapping("/api/toggle-like")
    public Map<String, Object> toggleLike(@RequestParam Integer postId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        Map<String, Object> response = new HashMap<>();
        
        if (user == null) {
            response.put("status", "error");
            response.put("message", "Not authenticated");
            return response;
        }
        
        // ပို့စ် ရှိ/မရှိ စစ်ဆေးခြင်း
        Optional<Post> postOpt = postRepository.findById(postId);
        if (!postOpt.isPresent()) {
            response.put("status", "error");
            response.put("message", "Post not found");
            return response;
        }
        
        Post post = postOpt.get();
        
        // အဆိုပါ User သည် အဆိုပါ Post ကို Like နှိပ်ထားပြီးသား ရှိ/မရှိ စစ်ဆေးခြင်း
        Optional<PostLike> existingLike = postLikeRepository.findByPostIdAndUserId(postId, user.getId());
        
        boolean currentIsLiked = false;
        
        if (existingLike.isPresent()) {
            // Like နှိပ်ထားပြီးသားဖြစ်ပါက Like ကို ပြန်ဖြုတ်ခြင်း (Unlike)
            postLikeRepository.delete(existingLike.get());
            currentIsLiked = false;
        } else {
            // Like အသစ် ထည့်သွင်းခြင်း (Like)
            PostLike newLike = new PostLike();
            newLike.setPost(post);
            newLike.setUser(user);
            postLikeRepository.save(newLike);
            currentIsLiked = true;
        }
        
        // အဆိုပါ ပို့စ်အတွက် စုစုပေါင်း Like အရေအတွက်ကို ပြန်လည်ရေတွက်ခြင်း
        long newTotalLikes = postLikeRepository.countByPostId(postId);

        response.put("status", "success");
        response.put("isLiked", currentIsLiked);
        response.put("totalLikes", newTotalLikes);
        
        return response;
    }
}