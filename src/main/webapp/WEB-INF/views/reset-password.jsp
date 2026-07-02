<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New Password</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif; }
        body { display: flex; justify-content: center; align-items: center; min-height: 100vh; background: #f4f6f9; padding: 20px; }
        .reset-card { background: white; padding: 40px; border-radius: 16px; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.05); width: 100%; max-width: 420px; border: 1px solid #e2e8f0; }
        h2 { font-size: 22px; color: #0f172a; font-weight: 700; margin-bottom: 8px; text-align: center; }
        p { color: #64748b; font-size: 14px; margin-bottom: 24px; text-align: center; }
        .input-group { margin-bottom: 20px; }
        label { font-size: 12px; font-weight: 700; color: #475569; display: block; margin-bottom: 6px; text-transform: uppercase; }
        input { width: 100%; padding: 12px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 15px; color: #0f172a; outline: none; }
        input:focus { border-color: #0284c7; }
        .btn { width: 100%; padding: 14px; background: #10b981; color: white; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; font-size: 14px; }
        .btn:hover { background: #059669; }
        .error-msg { background: #fef2f2; color: #ef4444; font-size: 13px; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #fee2e2; }
    </style>
</head>
<body>

    <div class="reset-card">
        <h2>Reset Password</h2>
        <p>Please type your new account password structure below.</p>
        
        <% if(request.getAttribute("error") != null) { %>
            <div class="error-msg">⚠️ <%= request.getAttribute("error") %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/reset-password" method="POST">
            <input type="hidden" name="token" value="${token}" />
            
            <div class="input-group">
                <label>New Password</label>
                <input type="password" name="password" required placeholder="••••••••" minlength="6"/>
            </div>
            
            <div class="input-group">
                <label>Confirm New Password</label>
                <input type="password" name="confirmPassword" required placeholder="••••••••" minlength="6"/>
            </div>
            
            <button type="submit" class="btn">Update Password</button>
        </form>
    </div>

</body>
</html>