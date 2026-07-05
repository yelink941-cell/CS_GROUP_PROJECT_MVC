package com.hibernate.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class LastSeenFormatter {

    public static String format(Boolean isOnline, LocalDateTime lastSeen) {
        if (Boolean.TRUE.equals(isOnline)) {
            return "Online";
        }
        if (lastSeen == null) {
            return "Offline";
        }
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("hh:mm a");
        if (lastSeen.toLocalDate().equals(now.toLocalDate())) {
            return "Last seen at " + lastSeen.format(timeFormatter);
        } else if (lastSeen.toLocalDate().equals(now.toLocalDate().minusDays(1))) {
            return "Last seen yesterday at " + lastSeen.format(timeFormatter);
        } else {
            return "Last seen at " + lastSeen.format(DateTimeFormatter.ofPattern("MMM dd 'at' hh:mm a"));
        }
    }
}
