<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>💬 1-to-1 Chat စတင်ရန်</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; padding: 0; background: #f0f2f5; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
        .create-container { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 100%; max-width: 400px; text-align: center; }
        h2 { color: #333; margin-bottom: 10px; }
        p { color: #65676b; font-size: 14px; margin-bottom: 25px; }
        .form-group { text-align: left; margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: bold; color: #4b4f56; font-size: 14px; }
        .input-field { width: 100%; padding: 12px; border: 1px solid #ccd0d5; border-radius: 8px; box-sizing: border-box; font-size: 15px; }
        .btn-submit { width: 100%; background: #0084ff; color: white; border: none; padding: 12px; border-radius: 8px; font-weight: bold; font-size: 16px; cursor: pointer; }
        .error-msg { color: #e41e3f; background: #ffebe9; padding: 10px; border-radius: 6px; font-size: 14px; margin-bottom: 20px; text-align: left; }
        .back-link { display: inline-block; margin-top: 20px; color: #0084ff; text-decoration: none; font-weight: bold; font-size: 14px; }
    </style>
</head>
<body>

<div class="create-container">
    <h2>💬 1-to-1 Chat</h2>
    <p>စကားပြောလိုသော user ၏ username ကို ရိုက်ထည့်ပါ။</p>

    <c:if test="${not empty error}">
        <div class="error-msg">⚠️ <c:out value="${error}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/chat/create" method="POST">
        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" class="input-field" placeholder="john_doe" required autocomplete="off">
        </div>
        <button type="submit" class="btn-submit">Chat စတင်မည်</button>
    </form>

    <a href="${pageContext.request.contextPath}/chat" class="back-link">⬅ Inbox သို့</a>
</div>

</body>
</html>
