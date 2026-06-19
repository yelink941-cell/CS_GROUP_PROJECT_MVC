<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>👥 Group Chat ဖန်တီးရန်</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; padding: 0; background: #f0f2f5; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
        .create-container { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 100%; max-width: 480px; }
        h2 { color: #333; margin-bottom: 8px; }
        p { color: #65676b; font-size: 14px; margin-bottom: 20px; }
        .form-group { margin-bottom: 16px; }
        label { display: block; margin-bottom: 6px; font-weight: bold; color: #4b4f56; font-size: 14px; }
        .input-field { width: 100%; padding: 12px; border: 1px solid #ccd0d5; border-radius: 8px; box-sizing: border-box; font-size: 15px; }
        .btn-submit { width: 100%; background: #25d366; color: white; border: none; padding: 12px; border-radius: 8px; font-weight: bold; font-size: 16px; cursor: pointer; margin-top: 8px; }
        .btn-submit:hover { background: #1da851; }
        .error-msg { color: #e41e3f; background: #ffebe9; padding: 10px; border-radius: 6px; font-size: 14px; margin-bottom: 16px; border: 1px solid rgba(228,30,63,0.2); }
        .back-link { display: inline-block; margin-top: 16px; color: #0084ff; text-decoration: none; font-weight: bold; font-size: 14px; }
    </style>
</head>
<body>

<div class="create-container">
    <h2>👥 Group Chat အသစ်</h2>
    <p>Group အမည်နှင့် member username များကို comma (,) ခြားပြီး ထည့်ပါ။</p>

    <c:if test="${not empty error}">
        <div class="error-msg">⚠️ <c:out value="${error}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/chat/create-group" method="POST">
        <div class="form-group">
            <label for="title">Group အမည်:</label>
            <input type="text" id="title" name="title" class="input-field" placeholder="ဥပမာ - CS Team" required>
        </div>

        <div class="form-group">
            <label for="usernames">Member Usernames (comma ခြား):</label>
            <input type="text" id="usernames" name="usernames" class="input-field"
                   placeholder="john_doe, alice, bob" required>
        </div>

        <button type="submit" class="btn-submit">Group ဖန်တီးမည်</button>
    </form>

    <a href="${pageContext.request.contextPath}/chat" class="back-link">⬅ Inbox သို့</a>
</div>

</body>
</html>
