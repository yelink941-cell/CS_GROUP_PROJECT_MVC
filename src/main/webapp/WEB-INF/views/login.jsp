<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Sign In</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 100px; background-color: #f0f2f5; }
        .login-container { background: white; padding: 35px; border-radius: 12px; max-width: 400px; margin: auto; box-shadow: 0px 4px 15px rgba(0,0,0,0.1); }
        h2 { text-align: center; color: #333; margin-bottom: 25px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #555; }
        .form-group input { width: 100%; padding: 11px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 6px; font-size: 14px; }
        .btn-submit { width: 100%; padding: 12px; background-color: #007bff; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 16px; font-weight: bold; margin-top: 10px; }
        .btn-submit:hover { background-color: #0056b3; }
        .error { color: red; text-align: center; margin-bottom: 15px; font-weight: 500; }
        .success { color: green; text-align: center; margin-bottom: 15px; font-weight: 500; }
        .footer-link { text-align: center; margin-top: 20px; font-size: 14px; color: #65676b; }
        .footer-link a { color: #007bff; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>

<div class="login-container">
    <h2>Welcome Back</h2>

    <% if(request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>
    
    <% if(request.getAttribute("msg") != null) { %>
        <p class="success"><%= request.getAttribute("msg") %></p>
    <% } %>

    <form action="${pageContext.request.contextPath}/login" method="POST">
        <div class="form-group">
            <label>Email Address:</label>
            <input type="email" name="email" placeholder="Enter your email" required />
        </div>
        
        <div class="form-group">
            <label>Password:</label>
            <input type="password" name="password" placeholder="Enter your password" required />
        </div>
        
        <button type="submit" class="btn-submit">Sign In</button>
    </form>

    <div class="footer-link">
        Don't have an account? <a href="${pageContext.request.contextPath}/register">Create Account</a>
    </div>
</div>

</body>
</html>