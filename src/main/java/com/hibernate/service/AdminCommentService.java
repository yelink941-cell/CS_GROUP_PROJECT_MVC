package com.hibernate.service;

import com.hibernate.entity.Comment;
import java.util.List;

public interface AdminCommentService {
    List<Comment> getAllComments();
    void deleteComment(Integer id);
}