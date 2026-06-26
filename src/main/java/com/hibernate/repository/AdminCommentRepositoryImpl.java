package com.hibernate.repository;

import com.hibernate.entity.Comment;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import lombok.RequiredArgsConstructor;
import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class AdminCommentRepositoryImpl implements AdminCommentRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public List<Comment> findAll() {
        // Comment အားလုံးကို Database မှ ဆွဲထုတ်ခြင်း
        return getSession().createQuery("FROM Comment", Comment.class).getResultList();
    }

    @Override
    public Optional<Comment> findById(Integer id) {
        // ID ဖြင့် Comment တစ်ခုချင်းစီကို ရှာဖွေခြင်း
        Comment comment = getSession().get(Comment.class, id);
        return Optional.ofNullable(comment);
    }

    @Override
    public void delete(Comment comment) {
        // Comment အား Database မှ ဖျက်ပစ်ခြင်း
        getSession().delete(comment);
    }
}