package com.hibernate.entity;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter

@Entity
@Table(name ="users")
public class User {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id;
	@Column(name ="username", unique = true,  length = 100)
	private String username;
	
	@Column(name ="email", unique = true, nullable = false, length = 255)
	private String email;
	
	@Column(name ="password_hash", unique = true, nullable = false, length = 255)
	private String passwordHash;
	
	@Column(name = "status")
    private String status = "ACTIVE";
	
	@Column(name ="role")
	private String role = "USER";
	
	@Column(name = "created_at", updatable = false)
	private LocalDateTime createdAt =LocalDateTime.now();
	
	@Column(name = "updated_at")
	private LocalDateTime updatedAt ;
}
