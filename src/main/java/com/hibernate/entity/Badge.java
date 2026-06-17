package com.hibernate.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "badges")
public class Badge {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "icon_url", length = 500)
    private String iconUrl;

    // user_badges Table အတွက် Many-to-Many Mapping
    @ManyToMany
    @JoinTable(
        name = "user_badges",
        joinColumns = @JoinColumn(name = "badge_id"),
        inverseJoinColumns = @JoinColumn(name = "user_id")
    )
    private List<User> users;
}