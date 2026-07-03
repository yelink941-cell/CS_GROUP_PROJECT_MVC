package com.hibernate.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.hibernate.entity.User;
import com.hibernate.service.UserService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

@Component("customSuccessHandler")
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {
	@Autowired
    private UserService userService;
	
    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, 
                                        HttpServletResponse response, 
                                        Authentication authentication) throws IOException {
    	
    	HttpSession session = request.getSession();
        String email = authentication.getName();
        
        
        User dbUser = userService.findUserByEmail(email);
        
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());
        
        session.setAttribute("currentUser", dbUser); 
        session.setAttribute("userId", dbUser != null ? dbUser.getId() : null);

        if (roles.contains("ROLE_ADMIN") || roles.contains("ADMIN") || roles.contains("ROLE_SUPER_ADMIN") || roles.contains("SUPER_ADMIN")) {
            session.setAttribute("role", "ADMIN"); 
            response.sendRedirect(request.getContextPath() + "/admin/dashboard"); 
        } else {
            session.setAttribute("role", "USER");  
            response.sendRedirect(request.getContextPath() + "/");
        }

    }
}