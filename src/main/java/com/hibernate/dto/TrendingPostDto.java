package com.hibernate.dto;

import com.hibernate.entity.Post;

public class TrendingPostDto {
    private final Post post;
    private final Long todayViewCount;

    public TrendingPostDto(Post post, Long todayViewCount) {
        this.post = post;
        this.todayViewCount = todayViewCount;
    }

    public Post getPost() {
        return post;
    }

    public Long getTodayViewCount() {
        return todayViewCount;
    }
}
