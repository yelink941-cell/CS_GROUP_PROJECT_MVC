package com.hibernate.repository;

import com.hibernate.entity.Comment;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Integer> {
    
    List<Comment> findByPostId(Integer postId);
    
    // 🌟 ပို့စ်တစ်ခုအတွက် မဖျက်ရသေးသော Parent comments အစစ်အမှန်များကိုသာ သီးသန့်ထုတ်ပေးမည့် Query 🌟
    @Query("SELECT c FROM Comment c WHERE c.post.id = :postId AND c.deletedAt IS NULL")
    List<Comment> findActiveCommentsByPostId(@Param("postId") Integer postId);
 // CommentRepository.java ထဲတွင် ထည့်ရန်
    @Query("SELECT COUNT(c) FROM Comment c WHERE c.post.id = :postId AND c.deletedAt IS NULL")
    int countActiveCommentsByPostId(@Param("postId") Integer postId);
}