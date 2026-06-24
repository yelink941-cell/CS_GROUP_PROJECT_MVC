<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
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

    <div class="progress-bar">
        <div id="ind-1" class="step-indicator active">1</div>
        <div id="ind-2" class="step-indicator">2</div>
    </div>

    <form:form action="${pageContext.request.contextPath}/register" method="POST" modelAttribute="registrationDto" enctype="multipart/form-data">
        
        <div class="form-group">
            <label>Full Name:</label>
            <form:input path="fullName" id="fullName" required="required" />
        </div>
        <div class="form-group">
            <label>Email Address:</label>
            <form:input path="email" type="email" id="email" required="required" />
        </div>
        <div class="form-group">
            <label>Password:</label>
            <form:password path="password" id="password" required="required" />
        </div>
        <div class="btn-container">
            <button type="button" class="btn btn-next" onclick="goToStep2()">Next ▶</button>
        </div>
    </div>

    <div id="step-2" class="form-step">
        <div class="form-group">
            <label>Username:</label>
            <form:input path="username" id="username" placeholder="e.g. ye_hsu123" />
        </div>
        <div class="form-group">
            <label>Profile Image :</label>
            <input type="file" name="avatarFile" accept="image/*" />
        </div>
        <div class="form-group">
            <label>Profile Picture (အသုံးပြုမည့်ပုံရွေးပါ):</label>
            <input type="file" name="avatar" accept="image/*" />
        </div>

        <div class="form-group">
            <label>Bio:</label>
            <form:textarea path="bio" rows="3" />
        </div>
        <div class="form-group">
            <label>Date of Birth (Day / Month / Year):</label>
            <div style="display: flex; gap: 8px;">
                <form:input type="number" path="dobDay" placeholder="DD" min="1" max="31" />
                <form:input type="number" path="dobMonth" placeholder="MM" min="1" max="12" />
                <form:input type="number" path="dobYear" placeholder="YYYY" min="1900" max="2026" />
            </div>
        </div>

        <button type="submit" class="btn btn-submit">Register လုပ်မည်</button>
    </form:form>
</div>

<script>
    function goToStep2() {
        var fullName = document.getElementById("fullName").value.trim();
        var email = document.getElementById("email").value.trim();
        var password = document.getElementById("password").value.trim();

        if (fullName === "" || email === "" || password === "") {
            alert("Please Fill the First Step First !");
            return;
        }
        document.getElementById("step-1").classList.remove("active");
        document.getElementById("step-2").classList.add("active");
        document.getElementById("ind-2").classList.add("active");
    }

    function goToStep1() {
        document.getElementById("step-2").classList.remove("active");
        document.getElementById("step-1").classList.add("active");
        document.getElementById("ind-2").classList.remove("active");
    }

    function skipAndSubmit() {
        var usernameField = document.getElementById("username");
        if(usernameField.value.trim() === "") {
            var email = document.getElementById("email").value;
            usernameField.value = email.split('@')[0] + Math.floor(Math.random() * 1000); 
        }
        document.getElementById("regForm").submit();
    }
</script>
</body>
</html>