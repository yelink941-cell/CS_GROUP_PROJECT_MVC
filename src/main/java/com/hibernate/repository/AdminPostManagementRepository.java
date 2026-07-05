package com.hibernate.repository;

import com.hibernate.entity.Post;
import java.util.List;
import java.util.Optional;

public interface AdminPostManagementRepository {
    List<Post> findAllForManagement();

    Optional<Post> findByIdForManagement(Integer id);

    Post update(Post post);
}
