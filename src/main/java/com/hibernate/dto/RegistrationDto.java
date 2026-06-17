package com.hibernate.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RegistrationDto {
    private String username;
    private String email;
    private String password;
    private String confirmPassword;
    private String fullName;
    private String bio;
    private Integer dobDay;
    private Integer dobMonth;
    private Integer dobYear;
}