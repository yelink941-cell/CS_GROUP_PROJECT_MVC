package com.hibernate.repository;

import com.hibernate.entity.Post;
import com.hibernate.entity.enums.PostStatus;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PostRepository extends JpaRepository<Post, Integer> {
	List<Post> findByStatus(PostStatus status);
}