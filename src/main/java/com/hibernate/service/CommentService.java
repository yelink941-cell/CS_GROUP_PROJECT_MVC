package com.hibernate.service;

import java.util.List;
import com.hibernate.entity.Comment;
import com.hibernate.entity.Post;

public interface CommentService {
    void saveComment(Comment comment);
    List<Comment> getCommentsByPostId(Integer postId);
    List<Comment> getCommentsByPost(Post post);
    
    // 🌟 အသစ်ထည့်ရန် 🌟
    List<Comment> getActiveParentComments(Integer postId);
 // CommentService.java 
    int getTotalActiveComments(Integer postId);
}