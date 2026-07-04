<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hibernate.entity.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Force Modify Credentials</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f6f9; padding: 50px; }
        .edit-box { background: white; padding: 30px; border-radius: 8px; max-width: 450px; margin: auto; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        h2 { margin-bottom: 20px; text-align: center; color: #1e293b; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 600; color: #475569; }
        .form-group input { width: 100%; padding: 10px; box-sizing: border-box; border: 1px solid #cbd5e1; border-radius: 6px; }
        .btn-update { width: 100%; padding: 12px; background-color: #ef4444; color: white; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; }
        .cancel-btn { display: block; text-align: center; margin-top: 15px; color: #64748b; text-decoration: none; }
    </style>
</head>
<body>
<% User targetUser = (User) request.getAttribute("targetUser"); %>
<div class="edit-box">
    <h2>Administrative Override Matrix</h2>
    <form action="${pageContext.request.contextPath}/admin/users/update-credentials" method="POST">
        <input type="hidden" name="userId" value="<%= targetUser.getId() %>" />
        <div class="form-group">
            <label>Target Username:</label>
            <input type="text" name="username" value="<%= targetUser.getUsername() %>" required />
        </div>
        <div class="form-group">
            <label>Target Email Address:</label>
            <input type="email" name="email" value="<%= targetUser.getEmail() %>" required />
        </div>
        <button type="submit" class="btn-update">Force Apply Changes</button>
        <a href="${pageContext.request.contextPath}/admin/users" class="cancel-btn">Abort Operations</a>
    </form>
</div>
</body>
</html>