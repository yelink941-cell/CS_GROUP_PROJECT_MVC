package com.hibernate.service;

import com.hibernate.dto.TrendingPostDto;
import com.hibernate.entity.Post;
import com.hibernate.entity.PostView;
import com.hibernate.entity.User;
import com.hibernate.repository.PostViewRepository;
import com.hibernate.repository.UserRepository;
import com.hibernate.util.GuestTokenCookieUtil;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class PostViewServiceImpl implements PostViewService {
    private static final int MAX_USER_AGENT_LENGTH = 500;

    private final PostViewRepository postViewRepository;
    private final UserRepository userRepository;

    @Override
    public void recordView(
            Post post,
            Long viewerUserId,
            HttpServletRequest request,
            HttpServletResponse response) {
        if (viewerUserId != null && viewerUserId.equals(post.getAuthor().getId())) {
            return;
        }

        User viewer = null;
        String guestToken = null;
        Long postId = post.getId().longValue();

        if (viewerUserId != null) {
            if (postViewRepository.existsUserViewWithin24Hours(postId, viewerUserId)) {
                return;
            }
            viewer = userRepository.getUserById(viewerUserId);
        } else {
            guestToken = GuestTokenCookieUtil.getOrCreateGuestToken(request, response);
            if (postViewRepository.existsGuestViewWithin24Hours(postId, guestToken)) {
                return;
            }
        }

        PostView postView = new PostView();
        postView.setPost(post);
        postView.setViewer(viewer);
        postView.setGuestToken(guestToken);
        postView.setViewerName(viewer == null ? null : viewer.getUsername());
        postView.setIpAddress(getIpAddress(request));
        postView.setUserAgent(truncate(request.getHeader("User-Agent"), MAX_USER_AGENT_LENGTH));
        postView.setViewedAt(LocalDateTime.now());
        postViewRepository.recordView(postView);
    }

    @Override
    @Transactional(readOnly = true)
    public List<PostView> getViewsByPostId(Integer postId) {
        return postViewRepository.findByPostId(postId);
    }

    @Override
    @Transactional(readOnly = true)
    public long countViewsByPostId(Integer postId) {
        return postViewRepository.countByPostId(postId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<TrendingPostDto> getTrendingPublishedPublicPosts() {
        List<Object[]> trendingPosts = postViewRepository.findTrendingPublishedPublicPosts(
                LocalDate.now().atStartOfDay());
        List<TrendingPostDto> results = new ArrayList<>();

        for (Object[] trendingPost : trendingPosts) {
            results.add(new TrendingPostDto((Post) trendingPost[0], (Long) trendingPost[1]));
        }

        return results;
    }

    private String getIpAddress(HttpServletRequest request) {
        String forwardedFor = request.getHeader("X-Forwarded-For");
        if (forwardedFor != null && !forwardedFor.trim().isEmpty()) {
            return truncate(forwardedFor.split(",")[0].trim(), 45);
        }

        return truncate(request.getRemoteAddr(), 45);
    }

    private String truncate(String value, int maxLength) {
        if (value == null || value.trim().isEmpty()) {
            return "Unknown";
        }

        String normalizedValue = value.trim();
        return normalizedValue.length() <= maxLength
                ? normalizedValue
                : normalizedValue.substring(0, maxLength);
    }
}
