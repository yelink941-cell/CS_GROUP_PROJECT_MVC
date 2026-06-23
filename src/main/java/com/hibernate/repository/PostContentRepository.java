package com.hibernate.repository;

import com.hibernate.entity.PostContent;
import java.util.List;
import java.util.Optional;

public interface PostContentRepository {
    PostContent save(PostContent postContent);

    PostContent update(PostContent postContent);

    void delete(PostContent postContent);

    Optional<PostContent> findByIdAndPostId(Integer id, Integer postId);

    List<PostContent> findByPostId(Integer postId);
}
