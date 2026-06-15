<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hibernate.entity.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body { font-family: sans-serif; margin: 40px; background-color: #f4f6f9; }
        .admin-box { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); max-width: 600px; margin: auto; text-align: center; }
        .badge { background-color: #dc3545; color: white; padding: 5px 10px; border-radius: 4px; font-size: 14px; font-weight: bold; }
        .btn-logout { display: inline-block; margin-top: 20px; padding: 10px 20px; background: #333; color: white; text-decoration: none; border-radius: 5px; }
    </style>
</head>
<body>

    <%
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
    %>

    <div class="admin-box">
        <h1 style="color: #dc3545;">Admin Control Panel 👑</h1>
        <p>Welcome back, <strong><%= currentUser.getUsername() %></strong></p>
        <p>Your Role Status: <span class="badge"><%= currentUser.getRole() %></span></p>
        
        <hr>
        <p style="color: #666;">ဒီနေရာမှာ User စာရင်းတွေကို စီမံခန့်ခွဲခြင်းနဲ့ Application Settings များကို ပြင်ဆင်နိုင်ပါတယ်ဗျာ။</p>
        
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sign Out</a>
    </div>

</body>
</html>