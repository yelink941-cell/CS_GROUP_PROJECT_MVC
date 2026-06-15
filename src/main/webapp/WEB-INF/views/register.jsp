<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>Multi-step Registration</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 50px; background-color: #f0f2f5; }
        .form-container { background: white; padding: 30px; border-radius: 12px; max-width: 480px; margin: auto; box-shadow: 0px 4px 15px rgba(0,0,0,0.1); }
        h2 { text-align: center; color: #333; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 600; color: #555; }
        .form-group input, .form-group textarea { width: 100%; padding: 10px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 6px; }
        .btn-container { display: flex; gap: 10px; margin-top: 25px; }
        .btn { padding: 11px; border: none; border-radius: 6px; cursor: pointer; font-size: 15px; font-weight: bold; flex: 1; text-align: center; }
        .btn-next { background-color: #007bff; color: white; }
        .btn-submit { background-color: #28a745; color: white; }
        .btn-skip { background-color: #6c757d; color: white; }
        .btn-back { background-color: #e4e6eb; color: #333; }
        .progress-bar { display: flex; justify-content: space-between; margin-bottom: 25px; }
        .step-indicator { width: 35px; height: 35px; background: #e4e6eb; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; color: #65676b; }
        .step-indicator.active { background: #007bff; color: white; }
        .form-step { display: none; }
        .form-step.active { display: block; }
        .error { color: red; text-align: center; }
    </style>
</head>
<body>

<div class="form-container">
    <h2>Create Account</h2>

    <div class="progress-bar">
        <div id="ind-1" class="step-indicator active">1</div>
        <div id="ind-2" class="step-indicator">2</div>
    </div>

    <% if(request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <form:form id="regForm" action="${pageContext.request.contextPath}/register" method="POST" modelAttribute="user" enctype="multipart/form-data">
        
        <div id="step-1" class="form-step active">
            <div class="form-group">
                <label>Full Name:</label>
                <input type="text" id="fullName" name="fullName" required />
            </div>
            <div class="form-group">
                <label>Email Address:</label>
                <form:input path="email" type="email" id="email" required="required" />
            </div>
            <div class="form-group">
                <label>Password:</label>
                <form:password path="passwordHash" id="password" required="required" />
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
                <label>Bio:</label>
                <textarea name="bio" rows="3"></textarea>
            </div>
            <div class="form-group">
                <label>Date of Birth (Day / Month / Year):</label>
                <div style="display: flex; gap: 8px;">
                    <input type="number" name="dobDay" placeholder="DD" min="1" max="31" />
                    <input type="number" name="dobMonth" placeholder="MM" min="1" max="12" />
                    <input type="number" name="dobYear" placeholder="YYYY" min="1900" max="2026" />
                </div>
            </div>
            <div class="form-group">
                <label>Country:</label>
                <input type="text" name="country" />
            </div>
            
            <div class="btn-container">
                <button type="button" class="btn btn-back" onclick="goToStep1()">◄ Back</button>
                <button type="button" class="btn btn-skip" onclick="skipAndSubmit()">Skip</button>
                <button type="submit" class="btn btn-submit">Submit</button>
            </div>
        </div>
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