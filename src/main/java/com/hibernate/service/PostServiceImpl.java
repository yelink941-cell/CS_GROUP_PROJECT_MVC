package com.hibernate.service;

import com.hibernate.entity.Category;
import com.hibernate.entity.Post;
import com.hibernate.entity.Tag;
import com.hibernate.entity.enums.PostStatus;
import com.hibernate.repository.CategoryRepository;
import com.hibernate.repository.PostRepository;
import com.hibernate.repository.TagRepository;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class PostServiceImpl implements PostService {
    private final PostRepository postRepository;
    private final CategoryRepository categoryRepository;
    private final TagRepository tagRepository;

    @Override
    public Post createPost(Post post, Integer categoryId, List<Integer> tagIds) {
        post.setCategory(getCategory(categoryId));
        post.setTags(getTags(tagIds));
        return postRepository.save(post);
    }

    @Override
    public Post updatePost(Integer id, Post post, Integer categoryId, List<Integer> tagIds) {
        Post existingPost = postRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Post not found."));

        existingPost.setTitle(post.getTitle());
        existingPost.setSlug(post.getSlug());
        existingPost.setExcerpt(post.getExcerpt());
        existingPost.setStatus(post.getStatus());
        existingPost.setCategory(getCategory(categoryId));
        existingPost.setTags(getTags(tagIds));

        return postRepository.update(existingPost);
    }

    @Override
    public void deletePost(Integer id) {
        postRepository.delete(id);
    }

    @Override
    public Optional<Post> getPostById(Integer id) {
        return postRepository.findById(id);
    }

    @Override
    public List<Post> getAllPosts() {
        return postRepository.findAll();
    }

    @Override
    public Optional<Post> getPostBySlug(String slug) {
        return postRepository.findBySlug(slug);
    }

    @Override
    public boolean existsBySlug(String slug) {
        return postRepository.existsBySlug(slug);
    }

    @Override
    public List<Post> getPostsByCategoryId(Integer categoryId) {
        return postRepository.findByCategoryId(categoryId);
    }

    @Override
    public List<Post> getPostsByStatus(PostStatus status) {
        return postRepository.findByStatus(status);
    }

    private Category getCategory(Integer categoryId) {
        return categoryRepository.findById(categoryId)
                .orElseThrow(() -> new IllegalArgumentException("Category not found."));
    }

    private List<Tag> getTags(List<Integer> tagIds) {
        List<Tag> tags = new ArrayList<>();

        if (tagIds == null) {
            return tags;
        }

        for (Integer tagId : tagIds) {
            Tag tag = tagRepository.findById(tagId)
                    .orElseThrow(() -> new IllegalArgumentException("Tag not found."));
            tags.add(tag);
        }

        return tags;
    }
}
