<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container" style="display: flex; justify-content: center; align-items: center; min-height: calc(100vh - 160px); padding-top: 20px;">
        
        <div class="empty-state" style="max-width: 440px; width: 100%; padding: 40px 32px; text-align: left; color: var(--text);">
            
            <div style="text-align: center; margin-bottom: 32px;">
                <h2 style="margin: 0 0 8px 0; font-size: 1.75rem; font-weight: 800; color: var(--text);">Welcome Back</h2>
                <p style="margin: 0; font-size: 0.92rem; color: var(--muted);">Access your personal technical references</p>
            </div>

            <c:if test="${param.error == 'inactive'}">
                <div id="authAlert" class="form-message-error" style="margin-bottom: 24px; font-weight: 600; font-size: 0.88rem; display: flex; align-items: center; gap: 8px; background-color: #fee2e2; border-left: 4px solid #ef4444; color: #991b1b; padding: 12px 14px; border-radius: 8px;">
                    <i class="fa-solid fa-triangle-exclamation"></i> Access Denied. Your account is currently inactive.
                </div>
                <script>
                    window.onload = function() {
                        alert("Your account is currently inactive. Access Denied!");
                    };
                </script>
            </c:if>

            <c:if test="${param.error == 'true'}">
                <div id="authAlert" class="form-message-error" style="margin-bottom: 24px; font-weight: 600; font-size: 0.88rem; display: flex; align-items: center; gap: 8px;">
                    <i class="fa-solid fa-triangle-exclamation"></i> Invalid credentials. Please try again.
                </div>
            </c:if>
            
            <c:if test="${param.resetSuccess != null}">
                <div id="authAlert" style="padding: 12px 14px; color: #166534; background: #dcfce7; border-radius: 8px; margin-bottom: 24px; font-weight: 600; font-size: 0.88rem; display: flex; align-items: center; gap: 8px;">
                    <i class="fa-solid fa-circle-check"></i> Password updated successfully!
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div style="margin-bottom: 24px; display: flex; flex-direction: column; gap: 8px;">
                    <label style="font-size: 0.88rem; font-weight: 700; color: var(--text);">Email Address</label>
                    <div style="position: relative; display: flex; align-items: center;">
                        <i class="fa-solid fa-envelope" style="position: absolute; left: 16px; color: var(--muted); font-size: 15px;"></i>
                        <input type="email" name="email" placeholder="name@example.com" required autocomplete="username"
                               style="width: 100%; padding: 12px 16px 12px 46px; border: 1px solid var(--border); border-radius: 9px; font-size: 0.95rem; font-family: inherit; outline: none; color: var(--text); background: var(--background);">
                    </div>
                </div>

                <div style="margin-bottom: 24px; display: flex; flex-direction: column; gap: 8px;">
                    <label style="font-size: 0.88rem; font-weight: 700; color: var(--text);">Password</label>
                    <div style="position: relative; display: flex; align-items: center;">
                        <i class="fa-solid fa-lock" style="position: absolute; left: 16px; color: var(--muted); font-size: 15px;"></i>
                        <input type="password" name="password" placeholder="••••••••" required autocomplete="current-password"
                               style="width: 100%; padding: 12px 16px 12px 46px; border: 1px solid var(--border); border-radius: 9px; font-size: 0.95rem; font-family: inherit; outline: none; color: var(--text); background: var(--background);">
                    </div>
                </div>

                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; font-size: 0.88rem;">
                    <div></div>
                    <a href="${pageContext.request.contextPath}/forgot-password" style="color: var(--primary); font-weight: 600; text-decoration: none;">Forgot Password?</a>
                </div>

                <button type="submit" class="button" style="width: 100%; min-height: 46px; font-size: 0.95rem; margin-bottom: 24px;">Login Account</button>
            </form>

            <div style="text-align: center; font-size: 0.9rem; color: var(--muted);">
                Don't have an account? <a href="${pageContext.request.contextPath}/register" style="color: var(--primary); font-weight: 700; text-decoration: none;">Register here</a>
            </div>
        </div>
    </main>

    <script>
        // Automatically hide alert notifications cleanly after 4 seconds
        window.addEventListener('DOMContentLoaded', () => {
            const alertBox = document.getElementById('authAlert');
            if (alertBox) {
                setTimeout(() => {
                    alertBox.style.transition = "opacity 0.4s ease, transform 0.4s ease";
                    alertBox.style.opacity = "0";
                    alertBox.style.transform = "translateY(-4px)";
                    setTimeout(() => {
                        alertBox.style.display = "none";
                        const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
                        window.history.replaceState({ path: cleanUrl }, '', cleanUrl);
                    }, 400);
                }, 4000);
            }
        });
    </script>
</body>
</html>