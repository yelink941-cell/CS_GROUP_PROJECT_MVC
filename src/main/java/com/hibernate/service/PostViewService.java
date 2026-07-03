package com.hibernate.service;

import com.hibernate.dto.TrendingPostDto;
import com.hibernate.entity.Post;
import com.hibernate.entity.PostView;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface PostViewService {
    void recordView(
            Post post,
            Long viewerUserId,
            HttpServletRequest request,
            HttpServletResponse response);

    List<PostView> getViewsByPostId(Integer postId);

    long countViewsByPostId(Integer postId);

    List<TrendingPostDto> getTrendingPublishedPublicPosts();
}
