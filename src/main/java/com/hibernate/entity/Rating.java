package com.hibernate.entity;


import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

import org.hibernate.annotations.CreationTimestamp;

import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
@Entity
@Table(name = "ratings", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"post_id", "user_id"})
})
public class Rating {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "post_id", nullable = false)
    private Post post;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    private Integer rating; // SQL TINYINT ကို Integer ဖြင့် ဖမ်းခြင်း

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}