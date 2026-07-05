package com.hibernate.service;

import com.hibernate.entity.Post;
import com.hibernate.entity.User;
import java.util.List;

public interface AdminPostManagementService {
    List<Post> getAllPosts();

    Post getPostDetail(Integer id);

    void archivePost(Integer id, User admin);

    void restorePost(Integer id, User admin);

    void removePost(Integer id, String removalReason, User admin);

    void permanentlyDeleteUserDeletedPost(Integer id, User admin);
}
