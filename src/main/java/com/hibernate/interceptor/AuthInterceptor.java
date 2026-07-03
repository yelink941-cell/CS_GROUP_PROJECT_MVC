package com.hibernate.interceptor;

import com.hibernate.entity.User;
import com.hibernate.entity.enums.Role;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

public class AuthInterceptor implements HandlerInterceptor {

    @org.springframework.beans.factory.annotation.Autowired
    private com.hibernate.service.UserService userService;

    @Override
    public boolean preHandle(
            HttpServletRequest request,
            HttpServletResponse response,
            Object handler) throws Exception {
        String path = getPath(request);

        // Allow suspended page, logout, and resources to load
        if ("/suspended".equals(path) || "/logout".equals(path) || path.startsWith("/resources/")) {
            return true;
        }

        HttpSession session = request.getSession(false);
        User user = normalizeSession(session);

        // Gatekeeper Logic: Check if logged-in user is BANNED
        if (user != null) {
            User dbUser = userService.getUserById(user.getId());
            if (dbUser != null && com.hibernate.entity.enums.UserStatus.BANNED.equals(dbUser.getStatus())) {
                if (session != null) {
                    session.invalidate();
                }
                org.springframework.security.core.context.SecurityContextHolder.clearContext();
                redirect(request, response, "/suspended");
                return false;
            }
        }

        if (isAdminPath(path)) {
            if (user == null) {
                redirect(request, response, "/login");
                return false;
            }

            if (!user.isAdmin()) {
                redirect(request, response, "/");
                return false;
            }
        }

        if (isUserPath(path)) {
            if (user == null) {
                redirect(request, response, "/login");
                return false;
            }

            if (user.isAdmin()) {
                redirect(request, response, "/admin-dashboard");
                return false;
            }
        }

        return true;
    }


    private User normalizeSession(HttpSession session) {
        if (session == null) {
            return null;
        }

        User user = (User) session.getAttribute("user");

        if (user == null) {
            user = (User) session.getAttribute("currentUser");
        }

        if (user != null) {
            session.setAttribute("user", user);
            session.setAttribute("currentUser", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("role", user.getRole().name());
        }

        return user;
    }

    private String getPath(HttpServletRequest request) {
        return request.getRequestURI().substring(request.getContextPath().length());
    }

    private boolean isAdminPath(String path) {
        return "/admin-dashboard".equals(path) || path.startsWith("/admin/");
    }

    private boolean isUserPath(String path) {
        return path.startsWith("/user/");
    }

    private void redirect(
            HttpServletRequest request,
            HttpServletResponse response,
            String path) throws Exception {
        response.sendRedirect(request.getContextPath() + path);
    }
}
