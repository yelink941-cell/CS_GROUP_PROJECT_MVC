package com.hibernate.service;

import java.util.List;
import com.hibernate.entity.Comment;
import com.hibernate.entity.Post;

public interface CommentService {
    void saveComment(Comment comment);
    List<Comment> getCommentsByPostId(Integer postId);
    List<Comment> getCommentsByPost(Post post);
    List<Comment> getActiveParentComments(Integer postId);
    int getTotalActiveComments(Integer postId);
 // CommentService.java တွင် ထည့်ရန်
    int getTotalActiveParentComments(Integer postId);
	void deleteComment(Integer id);
	
}