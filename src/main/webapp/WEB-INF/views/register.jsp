<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - Cheatography Reference Engine</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Inter', sans-serif; }
        body { background-color: #f1f5f9; color: #1e293b; min-height: 100vh; display: flex; flex-direction: column; }
        header { background-color: #0f172a; padding: 16px 48px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
        .logo { color: #ffffff; font-size: 24px; font-weight: 700; text-decoration: none; display: flex; align-items: center; gap: 8px; }
        .logo span { border-bottom: 3px solid #f39c12; padding-bottom: 2px; }
        .btn-nav { text-decoration: none; padding: 10px 20px; border-radius: 8px; font-weight: 600; font-size: 14px; color: #f8fafc; background: rgba(255,255,255,0.1); transition: all 0.2s; }
        .btn-nav:hover { background: rgba(255,255,255,0.2); }
        .auth-container { flex-grow: 1; display: flex; align-items: center; justify-content: center; padding: 50px 24px; }
        .auth-card { background: #ffffff; border: 1px solid #e2e8f0; border-radius: 16px; max-width: 650px; width: 100%; padding: 40px; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.05); }
        .auth-header { text-align: center; margin-bottom: 32px; }
        .auth-title { font-size: 28px; font-weight: 800; color: #0f172a; margin-bottom: 8px; }
        .auth-subtitle { color: #64748b; font-size: 14px; }
        .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 20px; margin-bottom: 24px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group.full-width { grid-column: span 2; }
        @media(max-width: 600px) { .form-group.full-width { grid-column: span 1; } }
        .form-label { font-size: 14px; font-weight: 600; color: #334155; }
        .input-wrapper { position: relative; display: flex; align-items: center; }
        .input-wrapper i { position: absolute; left: 16px; color: #94a3b8; font-size: 16px; }
        .form-input, .form-textarea { width: 100%; padding: 12px 16px 12px 44px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 15px; outline: none; transition: all 0.2s; color: #1e293b; }
        .form-textarea { padding-left: 16px; resize: none; min-height: 80px; }
        .form-input:focus, .form-textarea:focus { border-color: #e67e22; box-shadow: 0 0 0 3px rgba(230, 126, 34, 0.15); }
        .radio-group-horizontal { display: flex; gap: 24px; margin-top: 6px; flex-wrap: wrap; }
        .radio-circle-label { display: flex; align-items: center; gap: 8px; font-size: 15px; font-weight: 500; color: #475569; cursor: pointer; user-select: none; }
        .radio-circle-label input[type="radio"] { appearance: none; -webkit-appearance: none; width: 20px; height: 20px; border: 2px solid #cbd5e1; border-radius: 50%; background-color: #ffffff; outline: none; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.2s ease-in-out; }
        .radio-circle-label input[type="radio"]:checked { border-color: #e67e22; }
        .radio-circle-label input[type="radio"]:checked::before { content: ""; width: 10px; height: 10px; background-color: #e67e22; border-radius: 50%; display: block; }
        .file-input-wrapper { display: flex; align-items: center; gap: 12px; margin-top: 4px; }
        .btn-file-trigger { background: #f1f5f9; border: 1px solid #cbd5e1; color: #475569; padding: 10px 16px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; display: inline-flex; align-items: center; gap: 8px; }
        .btn-file-trigger:hover { background: #e2e8f0; }
        #file-chosen { font-size: 14px; color: #64748b; text-overflow: ellipsis; overflow: hidden; white-space: nowrap; }
        .btn-submit { width: 100%; background: #e67e22; color: #ffffff; padding: 14px; border: none; border-radius: 8px; font-weight: 700; font-size: 15px; cursor: pointer; transition: all 0.2s; margin-top: 12px; margin-bottom: 20px; box-shadow: 0 4px 12px rgba(230, 126, 34, 0.2); }
        .btn-submit:hover { background: #d35400; transform: translateY(-1px); }
        .switch-prompt { text-align: center; font-size: 14px; color: #64748b; }
        .switch-prompt a { color: #e67e22; font-weight: 600; text-decoration: none; }
        .alert-error { padding: 12px 16px; background: #fef2f2; color: #991b1b; border: 1px solid #fca5a5; border-radius: 8px; font-size: 14px; font-weight: 500; margin-bottom: 24px; display: flex; align-items: center; gap: 8px; }
    </style>
</head>
<body>
    <header>
        <a href="${pageContext.request.contextPath}/" class="logo">
            <i class="fa-solid fa-bolt" style="color: #f39c12;"></i> <span>Cheatography</span>
        </a>
        <a href="${pageContext.request.contextPath}/login" class="btn-nav">Sign In</a>
    </header>

    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h2 class="auth-title">Create Your Reference Profile</h2>
                <p class="auth-subtitle">Join thousands of engineers and study groups globally</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert-error">
                    <i class="fa-solid fa-triangle-exclamation"></i> <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/register" method="POST" enctype="multipart/form-data">
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Username</label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-user"></i>
                            <input type="text" name="username" class="form-input" placeholder="johndoe" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Full Name</label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-id-card"></i>
                            <input type="text" name="fullName" class="form-input" placeholder="John Doe" required>
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label">Email Address</label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-envelope"></i>
                            <input type="email" name="email" class="form-input" placeholder="john@example.com" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Password</label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-lock"></i>
                            <input type="password" name="password" class="form-input" placeholder="********" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Confirm Password</label>
                        <div class="input-wrapper">
                            <i class="fa-solid fa-shield-halved"></i>
                            <input type="password" name="confirmPassword" class="form-input" placeholder="********" required>
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label">Gender Selection</label>
                        <div class="radio-group-horizontal">
                            <label class="radio-circle-label">
                                <input type="radio" name="gender" value="Male" required>
                                <span>Male</span>
                            </label>
                            <label class="radio-circle-label">
                                <input type="radio" name="gender" value="Female">
                                <span>Female</span>
                            </label>
                            <label class="radio-circle-label">
                                <input type="radio" name="gender" value="Other">
                                <span>Other</span>
                            </label>
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label">Avatar Profile Picture</label>
                        <div class="file-input-wrapper">
                            <input type="file" id="avatarFile" name="avatarFile" accept="image/*" style="display: none;" onchange="updateFileName(this)">
                            <button type="button" class="btn-file-trigger" onclick="document.getElementById('avatarFile').click()">
                                <i class="fa-solid fa-cloud-arrow-up"></i> Choose Image
                            </button>
                            <span id="file-chosen">No file selected</span>
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label">Short Biography (Bio)</label>
                        <textarea name="bio" class="form-textarea" placeholder="Tell us about your tech stack or study interests..."></textarea>
                    </div>
                </div>

                <button type="submit" class="btn-submit">Complete Registration</button>
            </form>

            <div class="switch-prompt">
                Already have an account? <a href="${pageContext.request.contextPath}/login">Log in here</a>
            </div>
        </div>
    </div>

    <script>
        function updateFileName(input) {
            const fileNameDisplay = document.getElementById('file-chosen');
            if (input.files && input.files.length > 0) {
                fileNameDisplay.textContent = input.files[0].name;
            } else {
                fileNameDisplay.textContent = 'No file selected';
            }
        }
    </script>
</body>
</html>
