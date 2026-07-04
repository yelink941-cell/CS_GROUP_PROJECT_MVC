package com.hibernate.util;

import java.util.UUID;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public final class GuestTokenCookieUtil {
    private static final String COOKIE_NAME = "guest_token";
    private static final int COOKIE_MAX_AGE_SECONDS = 30 * 24 * 60 * 60;
    private static final int MAX_TOKEN_LENGTH = 255;

    private GuestTokenCookieUtil() {
    }

    public static String getOrCreateGuestToken(
            HttpServletRequest request,
            HttpServletResponse response) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (COOKIE_NAME.equals(cookie.getName()) && isValid(cookie.getValue())) {
                    return cookie.getValue();
                }
            }
        }

        String guestToken = UUID.randomUUID().toString();
        Cookie cookie = new Cookie(COOKIE_NAME, guestToken);
        cookie.setHttpOnly(true);
        cookie.setSecure(request.isSecure());
        cookie.setMaxAge(COOKIE_MAX_AGE_SECONDS);
        cookie.setPath(getCookiePath(request));
        response.addCookie(cookie);
        return guestToken;
    }

    private static boolean isValid(String guestToken) {
        return guestToken != null
                && !guestToken.trim().isEmpty()
                && guestToken.length() <= MAX_TOKEN_LENGTH;
    }

    private static String getCookiePath(HttpServletRequest request) {
        String contextPath = request.getContextPath();
        return contextPath == null || contextPath.isEmpty() ? "/" : contextPath;
    }
}
