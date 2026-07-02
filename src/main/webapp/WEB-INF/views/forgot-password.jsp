<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password</title>
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { max-width: 400px; width: 100%; padding: 30px; background: #fff; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); box-sizing: border-box; }
        .alert { padding: 12px; margin-bottom: 20px; border-radius: 5px; text-align: center; font-size: 14px; font-weight: bold; }
        .alert-danger { color: #fff; background-color: #dc3545; }
        .alert-success { color: #fff; background-color: #28a745; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #555; }
        .form-group input { width: 100%; padding: 10px; box-sizing: border-box; border: 1px solid #ddd; border-radius: 5px; }
        .btn-submit { width: 100%; padding: 12px; background-color: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Reset Password</h2>
        <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
        <c:if test="${not empty msg}"><div class="alert alert-success">${msg}</div></c:if>
        <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
            <div class="form-group">
                <label>Email Address:</label>
                <input type="email" name="email" required placeholder="Enter your email" />
            </div>
            <button type="submit" class="btn-submit">Send Link</button>
        </form>
        <p style="text-align: center; margin-top: 15px;"><a href="${pageContext.request.contextPath}/login" style="color: #007bff; text-decoration: none;">Back to Login</a></p>
    </div>
</body>
</html>