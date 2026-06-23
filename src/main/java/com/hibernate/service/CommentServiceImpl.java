package com.hibernate.service;

import java.util.List;
import java.util.stream.Collectors;
import javax.transaction.Transactional; 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.hibernate.entity.Comment;
import com.hibernate.entity.Post;
import com.hibernate.repository.CommentRepository;

@Service
public class CommentServiceImpl implements CommentService {

    @Autowired
    private CommentRepository commentRepository;

    @Override
    @Transactional
    public void saveComment(Comment comment) {
        try {
            System.out.println("DEBUG: Attempting to save comment in DB...");
            
            if (comment != null && comment.getContent() != null) {
                commentRepository.save(comment);
                commentRepository.flush(); 
                System.out.println("DEBUG: Comment saved successfully!");
            } else {
                System.err.println("🚨 Comment data is null or empty 🚨");
            }
            
        } catch (Exception e) {
            System.err.println("🚨🚨 CRITICAL ERROR DURING COMMENT SAVE 🚨🚨");
            e.printStackTrace();
        }
    }

    @Override
    @Transactional 
    public List<Comment> getCommentsByPostId(Integer postId) {

        List<Comment> allComments = commentRepository.findByPostId(postId);

        System.out.println("ALL COMMENTS SIZE = " + allComments.size());

        for(Comment c : allComments){
            System.out.println(
                "ID = " + c.getId()
                + ", Parent = "
                + (c.getParent() == null ? "NULL" : c.getParent().getId())
                + ", Content = " + c.getContent()
            );
        }

        // 🌟 အပြောင်းအလဲ - ဖျက်မထားသော ကောင်များနှင့် မိဘအဆင့်ဆင့် ဖျက်ခံထားရခြင်း ရှိ/မရှိ စစ်ဆေးခြင်း 🌟
        List<Comment> activeComments = allComments.stream()
                .filter(c -> c.getDeletedAt() == null && !isParentDeleted(c))
                .collect(Collectors.toList());

        // 🌟 Replies များကို Database မှ အမှန်တကယ် ပြန်လည်ဖြည့်တင်းပေးခြင်း (Recursively) 🌟
        for (Comment comment : activeComments) {
            initializeReplies(comment);
        }
        
        return activeComments;
    }
    
    private void initializeReplies(Comment comment) {
        if (comment.getReplies() != null) {
            // 🌟 Replies များကို စစ်ထုတ်ရာတွင် မိဘအဆင့်ဆင့် ဖျက်ထားခြင်းကိုပါ ထပ်မံစစ်ဆေးပေးခြင်း 🌟
            List<Comment> activeReplies = comment.getReplies().stream()
                    .filter(r -> r.getDeletedAt() == null && !isParentDeleted(r) && r.getContent() != null && !r.getContent().trim().isEmpty())
                    .collect(Collectors.toList());
            
            comment.setReplies(activeReplies);
            
            // သားစဉ်မြေးဆက် အားလုံး အဆင့်ဆင့်ပေါ်ရန် ထပ်ဆင့် လှည့်ပေးခြင်း
            for (Comment reply : activeReplies) {
                initializeReplies(reply);
            }
        }
    }

    @Override
    @Transactional
    public List<Comment> getCommentsByPost(Post post) {
        List<Comment> allComments = commentRepository.findByPostId(post.getId());
        System.out.println("ALL COMMENTS SIZE = " + allComments.size());
        
        return allComments.stream()
                .filter(c -> c.getDeletedAt() == null && !isParentDeleted(c))
                .collect(Collectors.toList());
    }

    @Override
    public List<Comment> getActiveParentComments(Integer postId) {
        List<Comment> allCommentsForPost = commentRepository.findByPostId(postId);
        
        // ဖျက်မထားသော (deletedAt == null) နှင့် မိဘ (parent == null) ဖြစ်သော comment အစစ်များကို စစ်ထုတ်ခြင်း
        List<Comment> activeParentComments = allCommentsForPost.stream()
                .filter(c -> c.getDeletedAt() == null && !isParentDeleted(c) && c.getParent() == null)
                .collect(Collectors.toList());

        return activeParentComments;
    }

    @Override
    public int getTotalActiveComments(Integer postId) {
        List<Comment> allComments = commentRepository.findByPostId(postId);
        
        // JSP တွင် အမှန်တကယ် ပေါ်မည့် အရေအတွက်အတိုင်း မိဘအဆင့်ဆင့်ကိုပါ ထည့်သွင်းရေတွက်ခြင်း
        long actualVisibleCount = allComments.stream()
                .filter(c -> c.getDeletedAt() == null && !isParentDeleted(c))
                .count();
                
        return (int) actualVisibleCount;
    }
    
    // 🌟 မိဘ သို့မဟုတ် အထက်အလွှာ မိဘများ ဖျက်/မဖျက် အဆင့်ဆင့် စစ်ဆေးပေးသော Method 🌟
    private boolean isParentDeleted(Comment comment) {
        if (comment.getParent() == null) {
            return false;
        }
        if (comment.getParent().getDeletedAt() != null) {
            return true;
        }
        // အထက်အလွှာ မိဘများ (အဆင့်ဆင့်) ကိုပါ ဆက်လက်စစ်ဆေးခြင်း
        return isParentDeleted(comment.getParent());
    }
}