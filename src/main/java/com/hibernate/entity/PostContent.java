package com.hibernate.entity;

import com.hibernate.entity.enums.ContentType;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "post_contents")
public class PostContent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "post_id", nullable = false)
    private Post post;

    @Enumerated(EnumType.STRING)
    @Column(name = "content_type", length = 20)
    private ContentType contentType = ContentType.TEXT;

    @Column(length = 500)
    private String subtitle;

    @Lob
    @Column(name = "content_data", nullable = false, columnDefinition = "LONGTEXT")
    private String contentData;

    @Column(name = "sort_order")
    private Integer sortOrder = 0;
}