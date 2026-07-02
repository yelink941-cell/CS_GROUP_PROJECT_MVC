package com.hibernate.service;

import com.hibernate.entity.Comment;
import com.hibernate.repository.AdminCommentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import javax.transaction.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminCommentServiceImpl implements AdminCommentService {

    private final AdminCommentRepository adminCommentRepository;

    @Override
    public List<Comment> getAllComments() {
        // Comment အားလုံးကို Database မှ ဆွဲထုတ်ခြင်း
        return adminCommentRepository.findAll();
    }

    @Override
    @Transactional
    public void deleteComment(Integer id) {
        // Comment အား ID ဖြင့်ရှာ၍ တွေ့လျှင် ဖျက်ပစ်ခြင်း
        adminCommentRepository.findById(id).ifPresent(adminCommentRepository::delete);
    }
}