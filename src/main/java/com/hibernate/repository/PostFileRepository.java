package com.hibernate.repository;

import com.hibernate.entity.PostFile;
import java.util.List;
import java.util.Optional;

public interface PostFileRepository {
    PostFile save(PostFile postFile);

    List<PostFile> findByPostId(Integer postId);

    Optional<PostFile> findById(Integer fileId);

    Optional<PostFile> findByIdAndPostId(Integer id, Integer postId);
}
