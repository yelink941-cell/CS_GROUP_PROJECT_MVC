<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - Cheatography Reference Engine</title>
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
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
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

        .auth-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            max-width: 680px;
            width: 100%;
            padding: 40px 44px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.02);
            transition: box-shadow 0.2s ease;
        }

        .auth-card:hover {
            box-shadow: 0 20px 40px -12px rgba(0, 0, 0, 0.08);
        }

        @media (max-width: 480px) {
            .auth-card {
                padding: 28px 20px;
            }
        }

        /* ===== HEADER ===== */
        .auth-header {
            text-align: center;
            margin-bottom: 32px;
        }

        .auth-header .icon {
            font-size: 40px;
            color: #2563eb;
            margin-bottom: 8px;
            display: block;
        }

        .auth-title {
            font-size: 28px;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 6px;
            letter-spacing: -0.025em;
        }

        .auth-subtitle {
            color: #64748b;
            font-size: 14px;
            font-weight: 400;
        }

        /* ===== ALERT ===== */
        .alert-error {
            padding: 12px 16px;
            background: #fef2f2;
            color: #991b1b;
            border: 1px solid #fca5a5;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 24px;
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

        .alert-error i {
            font-size: 18px;
            flex-shrink: 0;
        }

        /* ===== FORM GRID ===== */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px 20px;
            margin-bottom: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .form-group.full-width {
            grid-column: span 2;
        }

        @media (max-width: 600px) {
            .form-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }

            .form-group.full-width {
                grid-column: span 1;
            }
        }

        /* ===== FORM LABELS ===== */
        .form-label {
            font-size: 13px;
            font-weight: 600;
            color: #334155;
            letter-spacing: 0.02em;
        }

        .form-label .required {
            color: #ef4444;
            margin-left: 2px;
        }

        /* ===== INPUTS ===== */
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

        .form-input,
        .form-textarea {
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
        }

        .form-textarea {
            padding-left: 16px;
            resize: vertical;
            min-height: 80px;
        }

        .form-input:focus,
        .form-textarea:focus {
            border-color: #2563eb;
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        .form-input::placeholder,
        .form-textarea::placeholder {
            color: #94a3b8;
        }

        .form-input:focus + i,
        .form-input:focus ~ i {
            color: #2563eb;
        }

        /* ===== RADIO BUTTONS ===== */
        .radio-group-horizontal {
            display: flex;
            gap: 24px;
            margin-top: 4px;
            flex-wrap: wrap;
        }

        .radio-circle-label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 500;
            color: #475569;
            cursor: pointer;
            user-select: none;
            transition: color 0.2s ease;
        }

        .radio-circle-label:hover {
            color: #1e293b;
        }

        .radio-circle-label input[type="radio"] {
            appearance: none;
            -webkit-appearance: none;
            width: 20px;
            height: 20px;
            border: 2px solid #cbd5e1;
            border-radius: 50%;
            background-color: #ffffff;
            outline: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease-in-out;
            flex-shrink: 0;
        }

        .radio-circle-label input[type="radio"]:checked {
            border-color: #2563eb;
        }

        .radio-circle-label input[type="radio"]:checked::before {
            content: "";
            width: 10px;
            height: 10px;
            background-color: #2563eb;
            border-radius: 50%;
            display: block;
            animation: radioPop 0.2s ease;
        }

        @keyframes radioPop {
            from {
                transform: scale(0);
            }
            to {
                transform: scale(1);
            }
        }

        .radio-circle-label input[type="radio"]:focus {
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.15);
        }

        .radio-circle-label:hover input[type="radio"] {
            border-color: #94a3b8;
        }

        .radio-circle-label:hover input[type="radio"]:checked {
            border-color: #2563eb;
        }

        /* ===== FILE UPLOAD ===== */
        .file-input-wrapper {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn-file-trigger {
            background: #f1f5f9;
            border: 1px solid #cbd5e1;
            color: #475569;
            padding: 10px 18px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s ease;
        }

        .btn-file-trigger:hover {
            background: #e2e8f0;
            border-color: #94a3b8;
        }

        .btn-file-trigger i {
            color: #2563eb;
        }

        #file-chosen {
            font-size: 13px;
            color: #64748b;
            text-overflow: ellipsis;
            overflow: hidden;
            white-space: nowrap;
            max-width: 200px;
        }

        @media (max-width: 480px) {
            #file-chosen {
                max-width: 140px;
            }
        }

        .file-hint {
            font-size: 11px;
            color: #94a3b8;
            margin-top: 4px;
            width: 100%;
        }

        .file-hint i {
            color: #2563eb;
            margin-right: 4px;
        }

        /* ===== SUBMIT BUTTON ===== */
        .btn-submit {
            width: 100%;
            background: #2563eb;
            color: #ffffff;
            padding: 14px;
            border: none;
            border-radius: 10px;
            font-weight: 700;
            font-size: 15px;
            cursor: pointer;
            transition: all 0.25s ease;
            margin-top: 8px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-submit:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.35);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        /* ===== SWITCH PROMPT ===== */
        .switch-prompt {
            text-align: center;
            font-size: 14px;
            color: #64748b;
        }

        .switch-prompt a {
            color: #2563eb;
            font-weight: 600;
            text-decoration: none;
            transition: color 0.2s ease;
        }

        .switch-prompt a:hover {
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

            .auth-title {
                font-size: 24px;
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

            .auth-title {
                font-size: 20px;
            }

            .form-input,
            .form-textarea {
                padding: 10px 14px 10px 40px;
                font-size: 13px;
            }

            .form-textarea {
                padding-left: 14px;
            }

            .radio-group-horizontal {
                gap: 16px;
            }

            .btn-submit {
                padding: 12px;
                font-size: 14px;
            }

            .btn-file-trigger {
                padding: 8px 14px;
                font-size: 12px;
            }

            .auth-card {
                padding: 20px 16px;
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
            <div class="auth-card">

                <!-- ===== HEADER ===== -->
                <div class="auth-header">
                    <span class="icon">
                        <i class="fa-regular fa-pen-to-square"></i>
                    </span>
                    <h2 class="auth-title">Create Your Reference Profile</h2>
                    <p class="auth-subtitle">Join thousands of engineers and study groups globally</p>
                </div>

                <!-- ===== ERROR ALERT ===== -->
                <c:if test="${not empty error}">
                    <div class="alert-error">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        ${error}
                    </div>
                </c:if>

                <!-- ===== FORM ===== -->
                <form action="${pageContext.request.contextPath}/register" method="POST" enctype="multipart/form-data">

                    <div class="form-grid">

                        <!-- Username -->
                        <div class="form-group">
                            <label class="form-label">
                                Username <span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-user"></i>
                                <input 
                                    type="text" 
                                    name="username" 
                                    class="form-input" 
                                    placeholder="johndoe" 
                                    required
                                />
                            </div>
                        </div>

                        <!-- Full Name -->
                        <div class="form-group">
                            <label class="form-label">
                                Full Name <span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-id-card"></i>
                                <input 
                                    type="text" 
                                    name="fullName" 
                                    class="form-input" 
                                    placeholder="John Doe" 
                                    required
                                />
                            </div>
                        </div>

                        <!-- Email -->
                        <div class="form-group full-width">
                            <label class="form-label">
                                Email Address <span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-envelope"></i>
                                <input 
                                    type="email" 
                                    name="email" 
                                    class="form-input" 
                                    placeholder="john@example.com" 
                                    required
                                />
                            </div>
                        </div>

                        <!-- Password -->
                        <div class="form-group">
                            <label class="form-label">
                                Password <span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-lock"></i>
                                <input 
                                    type="password" 
                                    name="password" 
                                    class="form-input" 
                                    placeholder="••••••••" 
                                    required
                                    minlength="6"
                                />
                            </div>
                        </div>

                        <!-- Confirm Password -->
                        <div class="form-group">
                            <label class="form-label">
                                Confirm Password <span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-shield-halved"></i>
                                <input 
                                    type="password" 
                                    name="confirmPassword" 
                                    class="form-input" 
                                    placeholder="••••••••" 
                                    required
                                    minlength="6"
                                />
                            </div>
                        </div>

                        <!-- Gender -->
                        <div class="form-group full-width">
                            <label class="form-label">
                                Gender <span class="required">*</span>
                            </label>
                            <div class="radio-group-horizontal">
                                <label class="radio-circle-label">
                                    <input type="radio" name="gender" value="Male" required />
                                    <span>Male</span>
                                </label>

                                <label class="radio-circle-label">
                                    <input type="radio" name="gender" value="Female" />
                                    <span>Female</span>
                                </label>

                                <label class="radio-circle-label">
                                    <input type="radio" name="gender" value="Other" />
                                    <span>Other</span>
                                </label>
                            </div>
                        </div>

                        <!-- Avatar -->
                        <div class="form-group full-width">
                            <label class="form-label">Avatar Profile Picture</label>
                            <div class="file-input-wrapper">
                                <input 
                                    type="file" 
                                    id="avatarFile" 
                                    name="avatarFile" 
                                    accept="image/*" 
                                    style="display: none;" 
                                    onchange="updateFileName(this)"
                                />
                                <button type="button" class="btn-file-trigger" onclick="document.getElementById('avatarFile').click()">
                                    <i class="fa-solid fa-cloud-arrow-up"></i> 
                                    Choose Image
                                </button>
                                <span id="file-chosen">No file selected</span>
                            </div>
                            <p class="file-hint">
                                
                                JPEG, PNG, or GIF. Max 2MB.
                            </p>
                        </div>

                        <!-- Bio -->
                        <div class="form-group full-width">
                            <label class="form-label">Short Biography</label>
                            <textarea 
                                name="bio" 
                                class="form-textarea" 
                                placeholder="Tell us about your tech stack or study interests..."
                            ></textarea>
                        </div>

                    </div>

                    <!-- Submit -->
                    <button type="submit" class="btn-submit">
                        
                        Complete Registration
                    </button>

                </form>

                <!-- ===== SWITCH PROMPT ===== -->
                <div class="switch-prompt">
                    Already have an account? 
                    <a href="${pageContext.request.contextPath}/login">Log in here</a>
                </div>

            </div>
        </div>
    </div>

    <!-- ===== SCRIPTS ===== -->
    <script>
        (function() {
            'use strict';

            // ===== File name display =====
            window.updateFileName = function(input) {
                const fileNameDisplay = document.getElementById('file-chosen');
                if (input.files && input.files.length > 0) {
                    const file = input.files[0];
                    
                    // Validate file type
                    const validTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
                    if (!validTypes.includes(file.type)) {
                        alert('Please select a valid image file (JPEG, PNG, GIF, or WEBP).');
                        input.value = '';
                        fileNameDisplay.textContent = 'No file selected';
                        return;
                    }
                    
                    // Validate file size (2MB max)
                    if (file.size > 2 * 1024 * 1024) {
                        alert('File size exceeds 2MB limit. Please choose a smaller image.');
                        input.value = '';
                        fileNameDisplay.textContent = 'No file selected';
                        return;
                    }
                    
                    fileNameDisplay.textContent = file.name;
                } else {
                    fileNameDisplay.textContent = 'No file selected';
                }
            };

            // ===== Password validation on submit =====
            const form = document.querySelector('form');
            if (form) {
                form.addEventListener('submit', function(event) {
                    const password = document.querySelector('input[name="password"]');
                    const confirmPassword = document.querySelector('input[name="confirmPassword"]');

                    if (password && confirmPassword) {
                        const pwd = password.value.trim();
                        const cpwd = confirmPassword.value.trim();

                        if (pwd !== cpwd) {
                            event.preventDefault();
                            alert('Passwords do not match!');
                            confirmPassword.focus();
                            return false;
                        }

                        if (pwd.length > 0 && pwd.length < 6) {
                            event.preventDefault();
                            alert('Password must be at least 6 characters long.');
                            password.focus();
                            return false;
                        }
                    }
                    return true;
                });
            }

        })();
    </script>

</body>
</html>