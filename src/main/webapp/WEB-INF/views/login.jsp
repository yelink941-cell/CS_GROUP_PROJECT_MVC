<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Cheat Sheet Project</title>
    <style>
        body { background-color: #f4f6f9; font-family: sans-serif; }
        .login-card { max-width: 400px; margin: 80px auto; padding: 30px; background: #fff; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .login-card h2 { text-align: center; margin-bottom: 25px; color: #333; }
        .error-box { color: #fff; background-color: #dc3545; padding: 12px; margin-bottom: 20px; border-radius: 5px; font-weight: bold; text-align: center; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #555; }
        .form-group input { width: 100%; padding: 10px; box-sizing: border-box; border: 1px solid #ddd; border-radius: 5px; }
        .btn-submit { width: 100%; padding: 10px; background-color: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; margin-top: 10px; }
        .btn-submit:hover { background-color: #0056b3; }
        .link-text { text-align: center; margin-top: 20px; font-size: 14px; color: #666; }
    </style>
</head>
<body>

    <div class="login-card">
        <h2>Sign In</h2>

        <c:if test="${not empty error}">
            <div class="error-box">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="POST">
            <div class="form-group">
                <label>Email Address:</label>
                <input type="email" name="email" required="required" placeholder="Enter your email" />
            </div>
            
            <div class="form-group">
                <label>Password:</label>
                <input type="password" name="password" required="required" placeholder="Enter your password" />
            </div>
            
            <button type="submit" class="btn-submit">Login 🚀</button>
            
            <div class="link-text">
                Don't have an account? <a href="${pageContext.request.contextPath}/register">Create Account</a>
            </div>
        </form>
    </div>

</body>
</html>