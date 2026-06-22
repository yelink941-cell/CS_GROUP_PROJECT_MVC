package com.hibernate.entity;



import java.time.LocalDateTime;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "comments")

public class Comment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "post_id", nullable = false)
    private Post post;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    // Self-Referencing (Reply comments တွေအတွက် ဖြစ်ပါတယ်)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "parent_id")
    private Comment parent;

    @OneToMany(mappedBy = "parent", cascade = CascadeType.ALL,fetch = FetchType.EAGER )
    private List<Comment> replies;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @Column(name = "is_approved")
    private Boolean isApproved = true;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}