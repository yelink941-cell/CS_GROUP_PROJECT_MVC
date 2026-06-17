package com.hibernate.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "collections")
public class Collection {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false, length = 150)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "is_public")
    private Boolean isPublic = false;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    // collection_posts Table ကို Join Table အနေနဲ့ ညွှန်းဆိုခြင်း
    @ManyToMany
    @JoinTable(
        name = "collection_posts",
        joinColumns = @JoinColumn(name = "collection_id"),
        inverseJoinColumns = @JoinColumn(name = "post_id")
    )
    private List<Post> posts;
}