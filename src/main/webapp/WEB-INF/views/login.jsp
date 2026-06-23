<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-form.css?v=3">
</head>
<body class="auth-page">
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="auth-main">
        <section class="auth-card">
            <div class="auth-heading">
                <span>Welcome back</span>
                <h1>Sign in to your account</h1>
                <p>Continue creating and managing your cheat sheets.</p>
            </div>

            <c:if test="${not empty error}">
                <p class="auth-message auth-error"><c:out value="${error}" /></p>
            </c:if>

            <c:if test="${not empty msg}">
                <p class="auth-message auth-success"><c:out value="${msg}" /></p>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="auth-field">
                    <label for="email">Email address</label>
                    <input id="email" type="email" name="email" placeholder="you@example.com" autocomplete="email" required>
                </div>

                <div class="auth-field">
                    <label for="password">Password</label>
                    <input id="password" type="password" name="password" placeholder="Enter your password"
                           autocomplete="current-password" required>
                </div>

                <button class="auth-submit" type="submit">Sign In</button>
            </form>

            <p class="auth-footer">
                Don&apos;t have an account?
                <a href="${pageContext.request.contextPath}/register">Create account</a>
            </p>
        </section>
    </main>
</body>
</html>
