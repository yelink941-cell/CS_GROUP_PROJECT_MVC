<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Multi-step Registration</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-form.css">
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; background-color: #f0f2f5; }
        .form-container { background: white; padding: 30px; border-radius: 12px; max-width: 480px; margin: 50px auto; box-shadow: 0px 4px 15px rgba(0,0,0,0.1); }
        h2 { text-align: center; color: #333; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 600; color: #555; }
        .form-group input, .form-group textarea, .form-group select { width: 100%; padding: 10px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 6px; }
        .btn-container { display: flex; gap: 10px; margin-top: 25px; }
        .btn { padding: 11px; border: none; border-radius: 6px; cursor: pointer; font-size: 15px; font-weight: bold; flex: 1; text-align: center; }
        .btn-submit { background-color: #28a745; color: white; width: 100%; margin-top: 15px; }
        .dob-group { display: flex; gap: 10px; }
        .dob-group select { flex: 1; }
        .error { color: red; text-align: center; margin-bottom: 15px; }
        .success { color: green; text-align: center; margin-bottom: 15px; }
    </style>
</head>
<body>

<div class="form-container">
    <h2>Create Account</h2>

    <c:if test="${not empty errorMessage}">
        <div class="error">${errorMessage}</div>
    </c:if>
    <c:if test="${not empty successMessage}">
        <div class="success">${successMessage}</div>
    </c:if>

    <form:form action="${pageContext.request.contextPath}/register" method="POST" modelAttribute="registrationDto" enctype="multipart/form-data">
        
        <div class="form-group">
            <label>Full Name:</label>
            <form:input path="fullName" required="required" placeholder="မောင်မောင်" />
        </div>

        <div class="form-group">
            <label>Username:</label>
            <form:input path="username" required="required" placeholder="maungmaung123" />
        </div>

        <div class="form-group">
            <label>Email:</label>
            <form:input path="email" type="email" required="required" placeholder="example@mail.com" />
        </div>

        <div class="form-group">
            <label>Password:</label>
            <form:password path="password" required="required" />
        </div>

        <div class="form-group">
            <label>Confirm Password:</label>
            <form:password path="confirmPassword" required="required" />
        </div>

        <div class="form-group">
            <label>Profile Picture (အသုံးပြုမည့်ပုံရွေးပါ):</label>
            <input type="file" name="avatar" accept="image/*" />
        </div>

        <div class="form-group">
            <label>Bio:</label>
            <form:textarea path="bio" rows="3" placeholder="မိမိအကြောင်းအကျဉ်းချုပ်ရေးရန်..." />
        </div>
        

        <div class="form-group">
            <label>Birthday (မွေးနေ့):</label>
            <div class="dob-group">
                <form:select path="dobDay" required="required">
                    <form:option value="" label="နေ့"/>
                    <c:forEach var="i" begin="1" end="31">
                        <form:option value="${i}" label="${i}"/>
                    </c:forEach>
                </form:select>

                <form:select path="dobMonth" required="required">
                    <form:option value="" label="လ"/>
                    <c:forEach var="i" begin="1" end="12">
                        <form:option value="${i}" label="${i}"/>
                    </c:forEach>
                </form:select>

                <form:select path="dobYear" required="required">
                    <form:option value="" label="ခုနှစ်"/>
                    <c:forEach var="i" begin="1950" end="2026">
                        <form:option value="${i}" label="${i}"/>
                    </c:forEach>
                </form:select>
            </div>
        </div>

        <button type="submit" class="btn btn-submit">Register လုပ်မည်</button>
    </form:form>
</div>

</body>
</html>