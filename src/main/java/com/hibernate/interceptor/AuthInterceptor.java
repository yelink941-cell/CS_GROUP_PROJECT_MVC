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
    
    	String requestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(requestedWith)) {
            return true; 
        }
        HttpSession session = request.getSession(false);
        User user = normalizeSession(session);
        
        String requestPath = request.getServletPath();

        if ("/login".equals(requestPath) || 
            "/register".equals(requestPath) ||
            requestPath.startsWith("/posts/") ||
            requestPath.startsWith("/resources/") ||
            requestPath.startsWith("/css/") ||
            requestPath.startsWith("/js/") ||
            requestPath.startsWith("/images/")) {
            
            return true; 
        }
        
        // Web page များအတွက်သာ အောက်ပါအတိုင်း စစ်ဆေးပါ
        if (isAdminPath(requestPath)) {
            if (user == null) {
                redirect(request, response, "/login");
                return false;
            }
            if (!Role.ADMIN.equals(user.getRole())) {
                redirect(request, response, "/");
                return false;
            }
        }

        if (isUserPath(requestPath)) {
            if (user == null) {
                redirect(request, response, "/login");
                return false;
            }
            if (Role.ADMIN.equals(user.getRole())) {
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

        // Session ထဲမှ user အချက်အလက်ကို သေချာပြန်ထုတ်ယူပါ
        User user = (User) session.getAttribute("user");

        if (user == null) {
            user = (User) session.getAttribute("currentUser");
        }

        return user;
    }

    private boolean isAdminPath(String path) {
        boolean isApi = path.contains("/api/") || path.contains("/rest/");
        return ("/admin-dashboard".equals(path) || path.startsWith("/admin/")) && !isApi;
    }

    private boolean isUserPath(String path) {
        // Web page လမ်းကြောင်းများသာဖြစ်ပြီး API လမ်းကြောင်းများနှင့် မသက်ဆိုင်ကြောင်း အတိအကျ သတ်မှတ်ပေးခြင်း
        boolean isApiOrAction = path.startsWith("/api/") || 
                                path.startsWith("/comments/") || 
                                path.contains("/like") || 
                                path.contains("/add") || 
                                path.contains("/bookmark") || 
                                path.contains("/rating");
                                
        return path.startsWith("/user/") && !isApiOrAction;
    }

    private void redirect(
            HttpServletRequest request,
            HttpServletResponse response,
            String path) throws Exception {
        response.sendRedirect(request.getContextPath() + path);
    }
}