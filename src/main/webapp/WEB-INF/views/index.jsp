<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; margin: 0; background: #f0f2f5; min-height: 100vh; }
        header { background: #fff; padding: 14px 20px; box-shadow: 0 1px 3px rgba(0,0,0,.08); display: flex; justify-content: space-between; align-items: center; }
        header a { color: #008069; text-decoration: none; font-weight: 600; margin-left: 14px; }
        main { padding: 32px 20px; max-width: 720px; margin: 0 auto; }
        .welcome-msg { color: #008069; font-size: 18px; font-weight: 600; }
        .chat-fab {
            position: fixed; right: 24px; bottom: 24px; width: 58px; height: 58px;
            border-radius: 50%; background: #008069; color: #fff; border: none;
            box-shadow: 0 4px 14px rgba(0,128,105,.4); font-size: 26px; cursor: pointer;
            display: flex; align-items: center; justify-content: center; text-decoration: none;
            z-index: 100;
        }
        .chat-fab:hover { background: #006b58; transform: scale(1.05); }
    </style>
</head>
<body>

<header>
    <strong>Cheatsheet Social</strong>
    <div>
        <c:choose>
            <c:when test="${not empty sessionScope.currentUser}">
                <span style="color:#667781;">${sessionScope.currentUser.username}</span>
                <a href="${pageContext.request.contextPath}/logout">Logout</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/register">Register</a>
                <a href="${pageContext.request.contextPath}/login">Login</a>
            </c:otherwise>
        </c:choose>
    </div>
</header>

<main>
    <p class="welcome-msg">${msg}</p>

    <c:if test="${not empty sessionScope.currentUser}">
        <h2>မင်္ဂလာပါ၊ <c:out value="${sessionScope.currentUser.username}"/> 👋</h2>
        <p style="color:#667781;"></p>
    </c:if>

    <c:if test="${empty sessionScope.currentUser}">
        <h3>WElCOME TO OUR CHEATSHEET</h3>
        <p style="color:#667781;"></p>
    </c:if>
</main>

<c:if test="${not empty sessionScope.currentUser}">
    <a href="${pageContext.request.contextPath}/chat" class="chat-fab" title="Messages">💬</a>
</c:if>

</body>
</html>
