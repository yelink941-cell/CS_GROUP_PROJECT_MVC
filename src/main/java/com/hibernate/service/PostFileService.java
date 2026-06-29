package com.hibernate.service;

import com.hibernate.entity.PostFile;
import java.io.IOException;
import java.nio.file.Path;
import java.util.List;
import java.util.Optional;
import org.springframework.web.multipart.MultipartFile;

public interface PostFileService {
    boolean isPostOwner(Integer postId, Long userId);

    List<PostFile> getFilesByPostId(Integer postId);

    PostFile uploadFile(Integer postId, MultipartFile file) throws IOException;

    Optional<PostFile> getById(Integer fileId);

    Optional<PostFile> getFile(Integer postId, Integer fileId);

    Path resolveFile(PostFile postFile);
}
