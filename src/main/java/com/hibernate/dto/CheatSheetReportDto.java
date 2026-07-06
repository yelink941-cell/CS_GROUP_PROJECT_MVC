package com.hibernate.dto;

import java.math.BigInteger;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CheatSheetReportDto {
    private BigInteger no;
    private String author;
    private LocalDateTime created_date;
    private String title;
    private Long like_count;
    private Long total_cheat_sheets;

    // Helper getter for JSP formatting
    public String getFormattedCreatedDate() {
        if (created_date == null) return "";
        return created_date.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS"));
    }
}
