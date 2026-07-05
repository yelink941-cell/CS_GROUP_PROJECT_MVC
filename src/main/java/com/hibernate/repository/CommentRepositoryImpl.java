package com.hibernate.repository;

import com.hibernate.entity.Comment;
import org.springframework.stereotype.Repository;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;

@Repository
public class CommentRepositoryImpl implements CommentRepository {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<Comment> findByPostId(Integer postId) {
        // 🔴 JOIN FETCH c.user ကို ထည့်ပေးခြင်းဖြင့် User data ကိုပါ တစ်ပါတည်း Lazy မဖြစ်စေဘဲ ဆွဲထုတ်ပေးမည် 🔴
        return entityManager.createQuery("SELECT c FROM Comment c JOIN FETCH c.user WHERE c.post.id = :postId", Comment.class)
                .setParameter("postId", postId)
                .getResultList();
    }

    @Override
    public List<Comment> findByPostIdAndDeletedAtIsNull(Integer postId) {
        // 🔴 JOIN FETCH c.user ကို ဤနေရာတွင်လည်း ထည့်ပေးပါ 🔴
        return entityManager.createQuery("SELECT c FROM Comment c JOIN FETCH c.user WHERE c.post.id = :postId AND c.deletedAt IS NULL", Comment.class)
                .setParameter("postId", postId)
                .getResultList();
    }

    @Override
    public int countByPostIdAndDeletedAtIsNull(Integer postId) {
        Long count = entityManager.createQuery("SELECT COUNT(c) FROM Comment c WHERE c.post.id = :postId AND c.deletedAt IS NULL", Long.class)
                .setParameter("postId", postId)
                .getSingleResult();
        return count.intValue();
    }

    @Override
    @Transactional
    public void save(Comment comment) {
        if (comment.getId() == null) {
            entityManager.persist(comment);
        } else {
            entityManager.merge(comment);
        }
    }

    @Override
    public Optional<Comment> findById(Integer id) {
        Comment comment = entityManager.find(Comment.class, id);
        return Optional.ofNullable(comment);
    }
    
    @Override
    public List<Comment> findByPostIdAndParentIsNullAndDeletedAtIsNull(Integer postId) {
        return entityManager.createQuery(
            "SELECT c FROM Comment c JOIN FETCH c.user " +
            "WHERE c.post.id = :postId AND c.parent IS NULL AND c.deletedAt IS NULL", 
            Comment.class)
                .setParameter("postId", postId)
                .getResultList();
    }
    
 // CommentRepositoryImpl သို့မဟုတ် Repository interface တွင်
    public int countActiveCommentsByPostId(Integer postId) {
        return entityManager.createQuery(
            "SELECT COUNT(c) FROM Comment c WHERE c.post.id = :postId AND c.deletedAt IS NULL", Long.class)
            .setParameter("postId", postId)
            .getSingleResult().intValue();
    }
}