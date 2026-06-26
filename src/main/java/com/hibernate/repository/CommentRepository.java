package com.hibernate.repository;

import com.hibernate.entity.Comment;
import java.util.List;
import java.util.Optional;

public interface CommentRepository {
    
    List<Comment> findByPostId(Integer postId);
    
    List<Comment> findByPostIdAndDeletedAtIsNull(Integer postId);

    int countByPostIdAndDeletedAtIsNull(Integer postId);
    
    // Save method လည်း လိုအပ်တဲ့အတွက် ထည့်ပေးထားပါတယ်
    void save(Comment comment);
    Optional<Comment> findById(Integer id);

	List<Comment> findByPostIdAndParentIsNullAndDeletedAtIsNull(Integer postId);
}