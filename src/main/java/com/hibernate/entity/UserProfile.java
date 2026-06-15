package com.hibernate.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import jakarta.persistence.Lob;
import lombok.Getter;
import lombok.Setter;

@Getter

@Setter
@Entity
@Table(name = "user_profiles")
public class UserProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "full_name", length = 150, nullable = false)
    private String fullName;

    @Column(name = "bio", columnDefinition = "TEXT")
    private String bio;

    @Lob
    @Column(name = "avatar", columnDefinition = "LONGBLOB")
    private byte[] avatar;

    // ⬇️ နေ့၊ လ၊ ခုနှစ် သီးသန့်စီ ခွဲသိမ်းရန် ပြောင်းလဲလိုက်သော Fields များ
    @Column(name = "dob_day")
    private int dobDay;

    @Column(name = "dob_month")
    private int dobMonth;

    @Column(name = "dob_year")
    private int dobYear;

    @Column(name = "country", length = 100)
    private String country;

    @OneToOne
    @JoinColumn(name = "user_id", unique = true, nullable = false)
    private User user;
}
