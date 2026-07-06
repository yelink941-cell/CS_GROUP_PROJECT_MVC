package com.hibernate.service;

import java.time.LocalDateTime;
import java.util.List;
import javax.transaction.Transactional;

import org.hibernate.Hibernate;
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
            if (comment != null && comment.getContent() != null) {
                commentRepository.save(comment); 
                System.out.println("DEBUG: Comment saved successfully!");
            } else {
                System.err.println("🚨 Comment data is null or empty 🚨");
            }
        } catch (Exception e) {
            System.err.println("🚨🚨 CRITICAL ERROR DURING COMMENT SAVE COMMENT 🚨🚨");
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    @Transactional 
    public List<Comment> getCommentsByPostId(Integer postId) {
        return getActiveParentComments(postId);
    }

    private void initializeReplies(Comment comment) {
        if (comment != null && comment.getReplies() != null) {
            Hibernate.initialize(comment.getReplies());
            for (Comment reply : comment.getReplies()) {
                initializeReplies(reply);
            }
        }
    }

    @Override
    @Transactional
    public List<Comment> getCommentsByPost(Post post) {
        return getCommentsByPostId(post.getId());
    }

    @Override
    @Transactional 
    public List<Comment> getActiveParentComments(Integer postId) {
        List<Comment> parentComments = commentRepository.findByPostIdAndParentIsNullAndDeletedAtIsNull(postId);
        
        for (Comment comment : parentComments) {
            initializeReplies(comment);
        }
        
        return parentComments;
    }

    @Override
    public int getTotalActiveComments(Integer postId) {
        List<Comment> parentComments = getActiveParentComments(postId);
        
        int totalCount = parentComments.size();
        for (Comment parent : parentComments) {
            totalCount += countAllRepliesExcludingDeleted(parent.getReplies());
        }
        return totalCount;
    }

    private int countAllRepliesExcludingDeleted(List<Comment> replies) {
        if (replies == null || replies.isEmpty()) {
            return 0;
        }
        int count = (int) replies.stream().filter(r -> r.getDeletedAt() == null).count();
        
        for (Comment reply : replies) {
            if (reply.getDeletedAt() == null && reply.getReplies() != null && !reply.getReplies().isEmpty()) {
                count += countAllRepliesExcludingDeleted(reply.getReplies());
            }
        }
        return count;
    }

    @Override
    @Transactional
    public void deleteComment(Integer id) {
        Comment comment = commentRepository.findById(id).orElse(null);
        
        if (comment != null) {
            LocalDateTime now = LocalDateTime.now();
            comment.setDeletedAt(now);
            commentRepository.save(comment);
            
            initializeAndCascadeDelete(comment, now);
            System.out.println("DEBUG: Comment (ID: " + id + ") soft-deleted successfully.");
        } else {
            System.err.println("🚨 Cannot delete: Comment not found with ID: " + id);
        }
    }

    private void initializeAndCascadeDelete(Comment comment, LocalDateTime deleteTime) {
        if (comment != null && comment.getReplies() != null) {
            Hibernate.initialize(comment.getReplies());
            for (Comment reply : comment.getReplies()) {
                if (reply != null && reply.getDeletedAt() == null) {
                    reply.setDeletedAt(deleteTime);
                    commentRepository.save(reply);
                    initializeAndCascadeDelete(reply, deleteTime);
                }
            }
        }
    }
    
    @Override
    public int getTotalActiveParentComments(Integer postId) {
        return getActiveParentComments(postId).size();
    }
    @Override
    public long countAllComments() {
        try {
            return commentRepository.count();
        } catch (Exception e) {
            System.err.println("Error counting comments: " + e.getMessage());
            return 0;
        }
    }
}