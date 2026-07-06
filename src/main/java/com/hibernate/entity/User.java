package com.hibernate.entity;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id; // 🔴 သေချာပေါက် javax ဖြစ်ရပါမည်
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import com.hibernate.entity.enums.Role;
import com.hibernate.entity.enums.UserStatus;

import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 100)
    private String username;

    @Column(nullable = false, unique = true, length = 255)
    private String email;

    @Column(name = "password_hash", nullable = false, length = 255)
    private String passwordHash;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private UserStatus status = UserStatus.ACTIVE;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private Role role = Role.USER;
    
 // ✅ အသစ်ထည့်ထားတဲ့ column နှစ်ခု
    @Column(name = "is_online", nullable = false)
    private Boolean isOnline = false;

    @Column(name = "last_seen")
    private LocalDateTime lastSeen = LocalDateTime.now();
    

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @Column(name = "ban_expires_at")
    private LocalDateTime banExpiresAt;

    @Column(name = "ban_reason", columnDefinition = "TEXT")
    private String banReason;

    @Column(name = "ban_type", length = 30)
    private String banType = "FULL";

    @Column(name = "ban_duration", length = 30)
    private String banDuration = "PERMANENT";

    public String getBanDurationLabel() {
        if ("1_WEEK".equalsIgnoreCase(this.banDuration)) return "1 Week";
        if ("1_MONTH".equalsIgnoreCase(this.banDuration)) return "1 Month";
        if ("1_YEAR".equalsIgnoreCase(this.banDuration)) return "1 Year";
        return "Permanent";
    }

    public boolean isCurrentlyBanned() {
        if (this.status == UserStatus.BANNED) {
            if (this.banExpiresAt == null) {
                return true; // Permanent ban
            }
            return LocalDateTime.now().isBefore(this.banExpiresAt);
        }
        return false;
    }

    public boolean isPostBanned() {
        if (!isCurrentlyBanned()) return false;
        return "FULL".equalsIgnoreCase(this.banType) || "POST_ONLY".equalsIgnoreCase(this.banType);
    }

    public boolean isCommentBanned() {
        if (!isCurrentlyBanned()) return false;
        return "FULL".equalsIgnoreCase(this.banType) || "COMMENT_ONLY".equalsIgnoreCase(this.banType);
    }

    public String getBanRemainingText() {
        if (!isCurrentlyBanned()) {
            return "Active";
        }
        String scopeLabel = "FULL".equalsIgnoreCase(this.banType) ? "Full Ban" : ("POST_ONLY".equalsIgnoreCase(this.banType) ? "Post Ban" : "Comment Ban");
        String durLabel = getBanDurationLabel();
        if (this.banExpiresAt == null) {
            return "Type: " + durLabel + " (" + scopeLabel + ")";
        }
        java.time.Duration remaining = java.time.Duration.between(LocalDateTime.now(), this.banExpiresAt);
        long days = remaining.toDays();
        long hours = remaining.toHours() % 24;
        if (days > 0) {
            return "Type: " + durLabel + " (" + scopeLabel + ") - " + days + "d " + hours + "h remaining";
        } else if (hours > 0) {
            return "Type: " + durLabel + " (" + scopeLabel + ") - " + hours + "h remaining";
        } else {
            long mins = Math.max(1, remaining.toMinutes());
            return "Type: " + durLabel + " (" + scopeLabel + ") - " + mins + "m remaining";
        }
    }

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private UserProfile profile;
    
    
    
    @Column(name = "reset_token", length = 100)
    private String resetToken;

    @Column(name = "token_expiry_date")
    private java.time.LocalDateTime tokenExpiryDate;

    public boolean isAdmin() {
        return this.role == Role.ADMIN || this.role == Role.SUPER_ADMIN;
    }
}