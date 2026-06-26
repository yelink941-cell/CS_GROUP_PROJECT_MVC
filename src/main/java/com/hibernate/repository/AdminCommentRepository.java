package com.hibernate.repository;

import com.hibernate.entity.Comment;
import java.util.List;
import java.util.Optional;

public interface AdminCommentRepository {
    List<Comment> findAll();
    Optional<Comment> findById(Integer id);
    void delete(Comment comment);
}