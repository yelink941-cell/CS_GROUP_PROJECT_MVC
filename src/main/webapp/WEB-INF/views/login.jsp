<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Cheatography Reference Engine</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Inter', sans-serif; }
        body { background-color: #f1f5f9; color: #1e293b; min-height: 100vh; display: flex; flex-direction: column; }
        
        /* Matching Global Header Structure */
        header { background-color: #0f172a; padding: 16px 48px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
        .logo { color: #ffffff; font-size: 24px; font-weight: 700; text-decoration: none; display: flex; align-items: center; gap: 8px; }
        .logo span { border-bottom: 3px solid #f39c12; padding-bottom: 2px; }
        .btn-nav { text-decoration: none; padding: 10px 20px; border-radius: 8px; font-weight: 600; font-size: 14px; color: #ffffff; background: #e67e22; transition: all 0.2s; }
        .btn-nav:hover { background: #d35400; }

        /* Auth Layout Panel Box */
        .auth-container { flex-grow: 1; display: flex; align-items: center; justify-content: center; padding: 40px 24px; }
        .auth-card { background: #ffffff; border: 1px solid #e2e8f0; border-radius: 16px; max-width: 420px; width: 100%; padding: 40px 32px; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.05); }
        .auth-header { text-align: center; margin-bottom: 32px; }
        .auth-title { font-size: 28px; font-weight: 800; color: #0f172a; margin-bottom: 8px; }
        .auth-subtitle { color: #64748b; font-size: 14px; }

        /* Input Form Assemblies */
        .form-group { margin-bottom: 20px; display: flex; flex-direction: column; gap: 6px; }
        .form-label { font-size: 14px; font-weight: 600; color: #334155; }
        .input-wrapper { position: relative; display: flex; align-items: center; }
        .input-wrapper i { position: absolute; left: 16px; color: #94a3b8; font-size: 16px; }
        .form-input { width: 100%; padding: 12px 16px 12px 44px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 15px; outline: none; transition: all 0.2s ease; color: #1e293b; }
        .form-input:focus { border-color: #e67e22; box-shadow: 0 0 0 3px rgba(230, 126, 34, 0.15); }

        /* Action Controls */
        .action-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; font-size: 14px; }
        .forgot-link { color: #e67e22; font-weight: 500; text-decoration: none; }
        .forgot-link:hover { text-decoration: underline; }
        .btn-submit { width: 100%; background: #0f172a; color: #ffffff; padding: 14px; border: none; border-radius: 8px; font-weight: 700; font-size: 15px; cursor: pointer; transition: background 0.2s; margin-bottom: 20px; }
        .btn-submit:hover { background: #1e293b; }
        .switch-prompt { text-align: center; font-size: 14px; color: #64748b; }
        .switch-prompt a { color: #e67e22; font-weight: 600; text-decoration: none; }

        /* Error/Info Alerts inside Cards */
        .alert { padding: 12px 16px; border-radius: 8px; font-size: 14px; font-weight: 500; margin-bottom: 20px; display: flex; align-items: center; gap: 8px; }
        .alert-error { background: #fef2f2; color: #991b1b; border: 1px solid #fca5a5; }
        .alert-success { background: #ecfdf5; color: #065f46; border: 1px solid #a7f3d0; }
    </style>
</head>
<body>

    <header>
        <a href="${pageContext.request.contextPath}/" class="logo">
            <i class="fa-solid fa-bolt" style="color: #f39c12;"></i> <span>Cheatography</span>
        </a>
        <a href="${pageContext.request.contextPath}/register" class="btn-nav">Register Instead</a>
    </header>

    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h2 class="auth-title">Welcome Back</h2>
                <p class="auth-subtitle">Access your personal technical references</p>
            </div>

            <% if (request.getParameter("error") != null) { %>
                <div id="authAlert" class="alert alert-error">
                    <i class="fa-solid fa-triangle-exclamation"></i> Invalid credentials. Please try again.
                </div>
            <% } %>
            <% if (request.getParameter("resetSuccess") != null) { %>
                <div id="authAlert" class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i> Password has been updated successfully!
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-envelope"></i>
                        <input type="email" name="email" class="form-input" placeholder="name@example.com" required autocomplete="username">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Password</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" name="password" class="form-input" placeholder="••••••••" required autocomplete="current-password">
                    </div>
                </div>

                <div class="action-row">
                    <div></div>
                    <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-link">Forgot Password?</a>
                </div>

                <button type="submit" class="btn-submit">Login Account</button>
            </form>

            <div class="switch-prompt">
                Don't have an account? <a href="${pageContext.request.contextPath}/register">Create one here</a>
            </div>
        </div>
    </div>

    <script>
        // Clean url param flags after a brief display timeout window
        window.addEventListener('DOMContentLoaded', () => {
            const alertBox = document.getElementById('authAlert');
            if (alertBox && (window.location.search.includes('error=true') || window.location.search.includes('resetSuccess=true'))) {
                setTimeout(() => {
                    alertBox.style.transition = "opacity 0.5s ease";
                    alertBox.style.opacity = "0";
                    setTimeout(() => {
                        alertBox.style.display = "none";
                        const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
                        window.history.replaceState({ path: cleanUrl }, '', cleanUrl);
                    }, 500);
                }, 4000);
            }
        });
    </script>
</body>
</html>