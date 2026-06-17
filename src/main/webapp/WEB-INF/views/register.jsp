<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Registration</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; background-color: #f4f4f9; }
        .container { max-width: 450px; background: white; padding: 30px; border-radius: 8px; box-shadow: 0px 0px 10px rgba(0,0,0,0.1); margin: auto; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group textarea, .form-group select { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .dob-group { display: flex; gap: 10px; }
        .btn { background-color: #007bff; color: white; padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer; width: 100%; font-size: 16px; }
        .btn:hover { background-color: #0056b3; }
        .error { color: red; margin-bottom: 15px; font-weight: bold; }
        .success { color: green; margin-bottom: 15px; font-weight: bold; }
    </style>
</head>
<body>

<div class="container">
    <h2>အကောင့်သစ်ဖွင့်ရန်</h2>

    <c:if test="${not empty errorMessage}">
        <div class="error">${errorMessage}</div>
    </c:if>
    <c:if test="${not empty successMessage}">
        <div class="success">${successMessage}</div>
    </c:if>

    <form:form action="${pageContext.request.contextPath}/register" method="POST" modelAttribute="registrationDto">
        
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

        <button type="submit" class="btn">Register လုပ်မည်</button>
    </form:form>
</div>

</body>
</html>