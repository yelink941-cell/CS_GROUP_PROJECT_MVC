package com.hibernate.service;

import java.util.List;

import com.hibernate.entity.Post;

public interface BookmarkService {
    boolean toggleBookmark(Long userId, Integer postId);
    long getBookmarkCount(Integer postId);
    boolean hasUserBookmarked(Long userId, Integer postId);
    List<Post> getBookmarksByUserId(Long userId);
}