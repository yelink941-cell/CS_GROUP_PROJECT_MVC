package com.hibernate.interceptor;

import com.hibernate.entity.User;
import com.hibernate.entity.enums.Role;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

public class AuthInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(
	        HttpServletRequest request,
	        HttpServletResponse response,
	        Object handler) throws Exception {
	    
	    // 🟢 ၁။ ပထမဆုံး Session ရှိ/မရှိကို အရင်စစ်ဆေးပြီး User data ကို Normalize လုပ်ပေးပါ (API အတွက်ပါ Session ဖမ်းမိစေရန်)
	    HttpSession session = request.getSession(false);
	    User user = normalizeSession(session);
	    
	    // 🟢 ၂။ ထို့နောက်မှ လမ်းကြောင်းများကို စစ်ဆေးပါ
	    String requestPath = getPath(request);
	    String requestedWith = request.getHeader("X-Requested-With");
	    
	    if ("/login".equals(requestPath) || 
	        requestPath.startsWith("/resources/") || 
	        "XMLHttpRequest".equals(requestedWith) ||
	        requestPath.startsWith("/api/") || 
	        requestPath.startsWith("/comments/") || 
	        requestPath.startsWith("/user/posts/like") || 
	        requestPath.startsWith("/user/posts/comment/add")) {
	        
	        return true; 
	    }
	    
	    String path = getPath(request);

	    if (isAdminPath(path)) {
	        if (user == null) {
	            redirect(request, response, "/login");
	            return false;
	        }

	        if (!Role.ADMIN.equals(user.getRole())) {
	            redirect(request, response, "/");
	            return false;
	        }
	    }

	    if (isUserPath(path)) {
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
        // 🟢 API နှင့် AJAX လမ်းကြောင်းများကို လုံးဝဖယ်ရှားပြီး User ၏ Web Page လမ်းကြောင်းများကိုသာ စစ်ဆေးရန်
        return path.startsWith("/user/");
    }

    private void redirect(
            HttpServletRequest request,
            HttpServletResponse response,
            String path) throws Exception {
        response.sendRedirect(request.getContextPath() + path);
    }
}
