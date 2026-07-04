<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* ===== RESET & BASE ===== */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: #f1f5f9;
            color: #1e293b;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* ===== PAGE WRAPPER ===== */
        .page-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            width: 100%;
            margin-top: 68px;
            min-height: calc(100vh - 68px);
        }

        /* ===== CONTAINER ===== */
        .auth-container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 24px 60px;
        }

        /* ===== CARD ===== */
        .card {
            max-width: 420px;
            width: 100%;
            padding: 40px 36px;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.02);
            transition: box-shadow 0.2s ease;
        }

        .card:hover {
            box-shadow: 0 20px 40px -12px rgba(0, 0, 0, 0.08);
        }

        @media (max-width: 480px) {
            .card {
                padding: 28px 20px;
            }
        }

        /* ===== HEADER ===== */
        .card-header {
            text-align: center;
            margin-bottom: 28px;
        }

        .card-header .icon {
            font-size: 40px;
            color: #2563eb;
            margin-bottom: 8px;
            display: block;
        }

        .card-header h2 {
            font-size: 26px;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 4px;
            letter-spacing: -0.025em;
        }

        .card-header .subtitle {
            color: #64748b;
            font-size: 14px;
            font-weight: 400;
            margin: 0;
        }

        /* ===== ALERT ===== */
        .alert {
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-8px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert-danger {
            color: #991b1b;
            background-color: #fef2f2;
            border: 1px solid #fca5a5;
        }

        .alert-danger i {
            color: #dc2626;
        }

        .alert-success {
            color: #065f46;
            background-color: #ecfdf5;
            border: 1px solid #a7f3d0;
        }

        .alert-success i {
            color: #10b981;
        }

        /* ===== FORM ===== */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #334155;
            font-size: 13px;
            letter-spacing: 0.02em;
        }

        .form-group label .required {
            color: #ef4444;
            margin-left: 2px;
        }

        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-wrapper i {
            position: absolute;
            left: 14px;
            color: #94a3b8;
            font-size: 16px;
            z-index: 1;
            transition: color 0.2s ease;
        }

        .form-group input {
            width: 100%;
            padding: 11px 16px 11px 44px;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            font-size: 14px;
            outline: none;
            transition: all 0.25s ease;
            color: #1e293b;
            background: #fafafa;
            font-family: inherit;
            box-sizing: border-box;
        }

        .form-group input:focus {
            border-color: #2563eb;
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        .form-group input::placeholder {
            color: #94a3b8;
        }

        .form-group input:focus + i,
        .form-group input:focus ~ i {
            color: #2563eb;
        }

        /* ===== BUTTONS ===== */
        .btn-submit {
            width: 100%;
            padding: 13px;
            background: #2563eb;
            color: #ffffff;
            border: none;
            border-radius: 10px;
            font-weight: 700;
            font-size: 15px;
            cursor: pointer;
            transition: all 0.25s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
        }

        .btn-submit:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.35);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        /* ===== LINKS ===== */
        .auth-links {
            text-align: center;
            margin-top: 20px;
            padding-top: 16px;
            border-top: 1px solid #e2e8f0;
        }

        .auth-links a {
            color: #2563eb;
            font-weight: 600;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .auth-links a i {
            font-size: 14px;
        }

        .auth-links a:hover {
            color: #1d4ed8;
            text-decoration: underline;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 720px) {
            .page-wrapper {
                margin-top: 120px;
                min-height: calc(100vh - 120px);
            }

            .auth-container {
                padding: 20px 16px 40px;
            }

            .card-header h2 {
                font-size: 22px;
            }
        }

        @media (max-width: 480px) {
            .page-wrapper {
                margin-top: 110px;
                min-height: calc(100vh - 110px);
            }

            .auth-container {
                padding: 16px 12px 32px;
            }

            .card {
                padding: 24px 16px;
            }

            .card-header h2 {
                font-size: 20px;
            }

            .form-group input {
                padding: 10px 14px 10px 40px;
                font-size: 13px;
            }

            .btn-submit {
                padding: 12px;
                font-size: 14px;
            }
        }

        @media (min-width: 721px) and (max-width: 968px) {
            .page-wrapper {
                margin-top: 68px;
                min-height: calc(100vh - 68px);
            }

            .auth-container {
                padding: 30px 20px 50px;
            }
        }
    </style>
</head>
<body>

    <!-- ===== NAVIGATION ===== -->
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <!-- ===== PAGE WRAPPER ===== -->
    <div class="page-wrapper">
        <div class="auth-container">
            <div class="card">

                <!-- ===== HEADER ===== -->
                <div class="card-header">
                    <span class="icon">
                        <i class="fa-regular fa-envelope"></i>
                    </span>
                    <h2>Reset Password</h2>
                    <p class="subtitle">Enter your email to receive a verification code</p>
                </div>

                <!-- ===== ALERTS ===== -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        ${error}
                    </div>
                </c:if>

                <c:if test="${not empty msg}">
                    <div class="alert alert-success">
                        <i class="fa-solid fa-circle-check"></i>
                        ${msg}
                    </div>
                </c:if>

                <!-- ===== FORM ===== -->
                <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                    <div class="form-group">
                        <label for="email">
                            Email Address <span class="required">*</span>
                        </label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-envelope"></i>
                            <input 
                                type="email" 
                                name="email" 
                                id="email"
                                required 
                                placeholder="Enter your email address"
                            />
                        </div>
                    </div>

                    <button type="submit" class="btn-submit">
                        <i class="fa-regular fa-paper-plane"></i>
                        Send Reset Link
                    </button>
                </form>

                <!-- ===== BACK TO LOGIN ===== -->
                <div class="auth-links">
                    <a href="${pageContext.request.contextPath}/login">
                       
                        Back to Login
                    </a>
                </div>

            </div>
        </div>
    </div>

    <!-- ===== SCRIPTS ===== -->
    <script>
        (function() {
            'use strict';

            // ===== Auto-hide alerts after 5 seconds =====
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    alert.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                    alert.style.opacity = '0';
                    alert.style.transform = 'translateY(-10px)';
                    setTimeout(function() {
                        alert.style.display = 'none';
                    }, 500);
                }, 5000);
            });

        })();
    </script>

</body>
</html>