<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* ===== ROOT VARIABLES ===== */
        :root {
            --primary: #2563eb;
            --primary-hover: #1d4ed8;
            --primary-light: #dbeafe;
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --text-light: #94a3b8;
            --border: #e2e8f0;
            --danger: #ef4444;
            --danger-bg: #fef2f2;
            --radius: 16px;
            --shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
        }

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
            background: var(--bg);
            color: var(--text-main);
            min-height: 100vh;
            line-height: 1.6;
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

        /* ===== MAIN CONTAINER ===== */
        .edit-container {
            max-width: 560px;
            margin: 40px auto;
            padding: 0 20px;
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* ===== CARD ===== */
        .edit-card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 40px 36px;
            box-shadow: var(--shadow);
            width: 100%;
            transition: box-shadow 0.2s ease;
        }

        .edit-card:hover {
            box-shadow: 0 20px 40px -12px rgba(0, 0, 0, 0.08);
        }

        @media (max-width: 480px) {
            .edit-card {
                padding: 24px 18px;
            }
        }

        /* ===== HEADER ===== */
        .edit-header {
            text-align: center;
            margin-bottom: 28px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--border);
        }

        .edit-header .icon {
            font-size: 40px;
            color: var(--primary);
            margin-bottom: 8px;
            display: block;
        }

        .edit-header h2 {
            font-size: 24px;
            font-weight: 700;
            color: var(--text-main);
            margin: 0 0 4px;
            letter-spacing: -0.025em;
        }

        .edit-header .subtitle {
            color: var(--text-muted);
            font-size: 14px;
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
            border: 1px solid transparent;
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

        .alert-error {
            background-color: var(--danger-bg);
            color: var(--danger);
            border-color: #fee2e2;
        }

        .alert-error i {
            color: #dc2626;
        }

        .alert-success {
            background-color: #ecfdf5;
            color: #065f46;
            border-color: #a7f3d0;
        }

        .alert-success i {
            color: #10b981;
        }

        .alert i {
            font-size: 16px;
            flex-shrink: 0;
        }

        /* ===== FORM ===== */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: var(--text-main);
            font-size: 13px;
            letter-spacing: 0.02em;
        }

        .form-group label .required {
            color: var(--danger);
            margin-left: 2px;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 11px 14px;
            border: 1px solid var(--border);
            border-radius: 10px;
            font-size: 14px;
            background: #fafafa;
            outline: none;
            transition: all 0.25s ease;
            color: var(--text-main);
            font-family: inherit;
            box-sizing: border-box;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            border-color: var(--primary);
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        .form-group input::placeholder,
        .form-group textarea::placeholder {
            color: var(--text-light);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }

        /* ===== AVATAR PREVIEW ===== */
        .avatar-preview-wrapper {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 14px;
            padding: 12px 16px;
            background: var(--bg);
            border-radius: 10px;
            border: 1px solid var(--border);
        }

        .avatar-preview {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--card-bg);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .avatar-preview-placeholder {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            background: linear-gradient(135deg, #dbeafe, #bfdbfe);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            color: var(--primary);
            border: 3px solid var(--card-bg);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .avatar-label {
            font-size: 13px;
            font-weight: 500;
            color: var(--text-muted);
            margin: 0;
        }

        .avatar-label i {
            color: var(--primary);
        }

        /* ===== NEW AVATAR PREVIEW ===== */
        #newAvatarPreview {
            margin-top: 12px;
            padding: 12px 16px;
            background: #eff6ff;
            border-radius: 10px;
            border: 1px solid #bfdbfe;
            display: none;
            align-items: center;
            gap: 16px;
        }

        #newAvatarPreview.show {
            display: flex;
        }

        #newAvatarPreview .preview-label {
            font-size: 12px;
            font-weight: 600;
            color: var(--text-muted);
            margin: 0;
        }

        #newAvatarPreview .avatar-preview {
            border-color: var(--primary);
        }

        /* ===== FILE UPLOAD ===== */
        .file-upload-wrapper {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .file-upload-wrapper input[type="file"] {
            position: absolute;
            opacity: 0;
            width: 0.1px;
            height: 0.1px;
        }

        .file-upload-label {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 18px;
            background: var(--bg);
            border: 1px solid var(--border);
            border-radius: 10px;
            font-size: 13px;
            font-weight: 500;
            color: var(--text-main);
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .file-upload-label:hover {
            background: var(--border);
        }

        .file-upload-label i {
            color: var(--primary);
        }

        .file-name {
            font-size: 13px;
            color: var(--text-muted);
        }

        .file-hint {
            font-size: 11px;
            color: var(--text-muted);
            margin-top: 6px;
            width: 100%;
        }

        .file-hint i {
            color: var(--primary);
            margin-right: 4px;
        }

        /* ===== SECTION DIVIDER ===== */
        .section-divider {
            margin: 28px 0 22px;
            border: 0;
            border-top: 2px dashed var(--border);
        }

        .section-title {
            font-size: 16px;
            font-weight: 600;
            margin: 0 0 4px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--text-main);
        }

        .section-title i {
            color: var(--primary);
        }

        .section-desc {
            font-size: 13px;
            color: var(--text-muted);
            margin: 0 0 16px;
        }

        .section-desc i {
            color: var(--primary);
            margin-right: 4px;
        }

        /* ===== BUTTONS ===== */
        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 28px;
            padding-top: 20px;
            border-top: 1px solid var(--border);
            flex-wrap: wrap;
        }

        .btn-submit {
            padding: 12px 32px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            font-size: 15px;
            transition: all 0.25s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            flex: 1;
            justify-content: center;
            min-width: 140px;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
        }

        .btn-submit:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.35);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        .btn-cancel {
            padding: 12px 32px;
            background: transparent;
            color: var(--text-muted);
            border: 1px solid var(--border);
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            font-size: 15px;
            transition: all 0.25s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            min-width: 120px;
            justify-content: center;
        }

        .btn-cancel:hover {
            background: var(--bg);
            color: var(--text-main);
            border-color: var(--text-muted);
        }

        .btn-cancel i {
            color: var(--text-muted);
        }

        @media (max-width: 480px) {
            .form-actions {
                flex-direction: column;
            }

            .btn-submit,
            .btn-cancel {
                width: 100%;
                justify-content: center;
            }

            .file-upload-wrapper {
                flex-direction: column;
                align-items: stretch;
            }

            .file-upload-label {
                justify-content: center;
            }

            .avatar-preview-wrapper {
                flex-direction: column;
                text-align: center;
            }

            #newAvatarPreview {
                flex-direction: column;
                text-align: center;
            }
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 720px) {
            .page-wrapper {
                margin-top: 120px;
                min-height: calc(100vh - 120px);
            }

            .edit-container {
                padding: 0 16px;
            }

            .edit-header h2 {
                font-size: 20px;
            }
        }

        @media (max-width: 480px) {
            .page-wrapper {
                margin-top: 110px;
                min-height: calc(100vh - 110px);
            }

            .edit-container {
                padding: 0 12px;
                margin: 20px auto;
            }

            .edit-header h2 {
                font-size: 18px;
            }
        }

        @media (min-width: 721px) and (max-width: 968px) {
            .page-wrapper {
                margin-top: 68px;
                min-height: calc(100vh - 68px);
            }
        }
    </style>
</head>
<body>

    <!-- ===== NAVIGATION ===== -->
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <!-- ===== PAGE WRAPPER ===== -->
    <div class="page-wrapper">
        <div class="edit-container">

            <div class="edit-card">

                <!-- ===== HEADER ===== -->
                <div class="edit-header">
                    <span class="icon">
                        <i class="fa-regular fa-pen-to-square"></i>
                    </span>
                    <h2>Edit Profile</h2>
                    <p class="subtitle">Update your profile information and security settings</p>
                </div>

                <!-- ===== ALERTS ===== -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        ${errorMessage}
                    </div>
                </c:if>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fa-solid fa-circle-check"></i>
                        ${successMessage}
                    </div>
                </c:if>

                <!-- ===== FORM ===== -->
                <form:form 
                    action="${pageContext.request.contextPath}/profile/update" 
                    method="POST" 
                    modelAttribute="userProfile" 
                    enctype="multipart/form-data"
                >

                    <!-- Full Name -->
                    <div class="form-group">
                        <label for="fullName">
                            Full Display Name <span class="required">*</span>
                        </label>
                        <form:input 
                            path="fullName" 
                            id="fullName"
                            required="required" 
                            placeholder="Enter your display name" 
                        />
                    </div>

                    <!-- Bio -->
                    <div class="form-group">
                        <label for="bio">Short Biography</label>
                        <form:textarea 
                            path="bio" 
                            id="bio"
                            rows="3" 
                            placeholder="Tell us about yourself..." 
                        />
                    </div>

                    <!-- ===== AVATAR UPLOAD WITH PREVIEW ===== -->
                    <div class="form-group">
                        <label>Update Avatar</label>
                        
                        <!-- Current Avatar Preview -->
                        <div class="avatar-preview-wrapper">
                            <c:choose>
                                <c:when test="${not empty avatarImage}">
                                    <img src="data:image/jpeg;base64,${avatarImage}" class="avatar-preview" alt="Current Avatar" />
                                </c:when>
                                <c:otherwise>
                                    <div class="avatar-preview-placeholder">
                                        <i class="fa-regular fa-user"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <p class="avatar-label">
                                <c:choose>
                                    <c:when test="${not empty avatarImage}">
                                        <i class="fa-regular fa-circle-check"></i>
                                        Current Avatar
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fa-regular fa-circle-xmark"></i>
                                        No Avatar Set
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        
                        <!-- File Upload -->
                        <div class="file-upload-wrapper">
                            <input 
                                type="file" 
                                name="avatarFile" 
                                id="avatarFile"
                                accept="image/*" 
                                onchange="previewAvatar(this)"
                            />
                            <label for="avatarFile" class="file-upload-label">
                                <i class="fa-regular fa-image"></i>
                                Choose New Avatar
                            </label>
                            <span class="file-name" id="fileName">No file chosen</span>
                            <span class="file-hint">
                                
                                JPEG, PNG, or GIF. Max 2MB.
                            </span>
                        </div>
                        
                        <!-- New Avatar Preview (shows after selection) -->
                        <div id="newAvatarPreview">
                            <span class="preview-label">
                                <i class="fa-regular fa-eye"></i>
                                New Avatar Preview:
                            </span>
                            <img id="newAvatarImg" class="avatar-preview" alt="New Avatar Preview" />
                        </div>
                    </div>

                    <!-- ===== SECURITY SECTION ===== -->
                    <hr class="section-divider" />

                    <div class="section-title">
                        <i class="fa-solid fa-shield-halved"></i>
                        Security Settings
                    </div>
                    <p class="section-desc">
                        
                        Leave password fields blank if you don't want to change your password.
                    </p>

                    <!-- Current Password -->
                    <div class="form-group">
                        <label for="currentPassword">Current Password</label>
                        <input 
                            type="password" 
                            name="currentPassword" 
                            id="currentPassword"
                            placeholder="Enter current password to make changes" 
                            autocomplete="current-password"
                        />
                    </div>

                    <!-- New Password -->
                    <div class="form-group">
                        <label for="newPassword">New Password</label>
                        <input 
                            type="password" 
                            name="newPassword" 
                            id="newPassword"
                            placeholder="Minimum 6 characters" 
                            minlength="6" 
                            autocomplete="new-password"
                        />
                    </div>

                    <!-- Confirm Password -->
                    <div class="form-group">
                        <label for="confirmPassword">Confirm New Password</label>
                        <input 
                            type="password" 
                            name="confirmPassword" 
                            id="confirmPassword"
                            placeholder="Repeat new password" 
                            autocomplete="new-password"
                        />
                    </div>

                    <!-- ===== FORM ACTIONS ===== -->
                    <div class="form-actions">
                        <button type="submit" class="btn-submit">
                            <i class="fa-regular fa-floppy-disk"></i>
                            Save Changes
                        </button>
                        <a href="${pageContext.request.contextPath}/profile" class="btn-cancel">
                            
                            Cancel
                        </a>
                    </div>

                </form:form>

            </div>

        </div>
    </div>

    <!-- ===== SCRIPTS ===== -->
    <script>
        (function() {
            'use strict';

            // ===== File preview function =====
            window.previewAvatar = function(input) {
                const fileName = document.getElementById('fileName');
                const newPreviewDiv = document.getElementById('newAvatarPreview');
                const newPreviewImg = document.getElementById('newAvatarImg');
                
                if (input.files && input.files.length > 0) {
                    const file = input.files[0];
                    
                    // Validate file type
                    const validTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
                    if (!validTypes.includes(file.type)) {
                        alert('Please select a valid image file (JPEG, PNG, GIF, or WEBP).');
                        input.value = '';
                        fileName.textContent = 'No file chosen';
                        fileName.style.color = 'var(--text-muted)';
                        newPreviewDiv.classList.remove('show');
                        newPreviewImg.src = '';
                        return;
                    }
                    
                    // Validate file size (2MB max)
                    if (file.size > 2 * 1024 * 1024) {
                        alert('File size exceeds 2MB limit. Please choose a smaller image.');
                        input.value = '';
                        fileName.textContent = 'No file chosen';
                        fileName.style.color = 'var(--text-muted)';
                        newPreviewDiv.classList.remove('show');
                        newPreviewImg.src = '';
                        return;
                    }
                    
                    // Update file name
                    fileName.textContent = file.name;
                    fileName.style.color = 'var(--text-main)';
                    
                    // Show preview
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        newPreviewImg.src = e.target.result;
                        newPreviewDiv.classList.add('show');
                    };
                    reader.readAsDataURL(file);
                    
                } else {
                    fileName.textContent = 'No file chosen';
                    fileName.style.color = 'var(--text-muted)';
                    newPreviewDiv.classList.remove('show');
                    newPreviewImg.src = '';
                }
            };

            // ===== Auto-hide alerts =====
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

            // ===== Password validation =====
            const form = document.querySelector('form');
            if (form) {
                form.addEventListener('submit', function(event) {
                    const currentPassword = document.getElementById('currentPassword');
                    const newPassword = document.getElementById('newPassword');
                    const confirmPassword = document.getElementById('confirmPassword');

                    if (newPassword && confirmPassword) {
                        const np = newPassword.value.trim();
                        const cp = confirmPassword.value.trim();

                        // If both are empty, it's fine (no password change)
                        if (np === '' && cp === '') {
                            return true;
                        }

                        // Check if current password is provided when changing password
                        if (np.length > 0 && (!currentPassword || currentPassword.value.trim() === '')) {
                            event.preventDefault();
                            alert('Please enter your current password to change it.');
                            if (currentPassword) currentPassword.focus();
                            return false;
                        }

                        // Check if new password is at least 6 characters
                        if (np.length > 0 && np.length < 6) {
                            event.preventDefault();
                            alert('New password must be at least 6 characters long.');
                            newPassword.focus();
                            return false;
                        }

                        // Check if passwords match
                        if (np !== cp) {
                            event.preventDefault();
                            alert('New password and confirmation do not match.');
                            confirmPassword.focus();
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