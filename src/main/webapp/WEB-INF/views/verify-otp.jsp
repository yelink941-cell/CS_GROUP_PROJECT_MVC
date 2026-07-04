<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify OTP Security Challenge</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif; }
        body { display: flex; justify-content: center; align-items: center; min-height: 100vh; background: #f4f6f9; color: #1e293b; padding: 20px; }
        .otp-card { background: white; padding: 40px; border-radius: 16px; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.05); width: 100%; max-width: 420px; text-align: center; border: 1px solid #e2e8f0; }
        .icon { font-size: 48px; margin-bottom: 16px; display: inline-block; }
        h2 { font-size: 22px; color: #0f172a; font-weight: 700; margin-bottom: 8px; }
        p { color: #64748b; font-size: 14px; line-height: 1.5; margin-bottom: 24px; }
        .input-group { margin-bottom: 24px; text-align: left; }
        label { font-size: 12px; font-weight: 700; color: #475569; display: block; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px; }
        input { width: 100%; padding: 14px; border: 2px solid #cbd5e1; border-radius: 8px; font-size: 24px; text-align: center; letter-spacing: 6px; font-weight: bold; color: #0f172a; outline: none; transition: border-color 0.2s; }
        input:focus { border-color: #0284c7; }
        .btn { width: 100%; padding: 14px; background: #0284c7; color: white; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; font-size: 14px; transition: background 0.2s; }
        .btn:hover { background: #0369a1; }
        .error-msg { background: #fef2f2; color: #ef4444; font-size: 13px; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #fee2e2; font-weight: 500; text-align: left; }
    </style>
</head>
<body>

    <div class="otp-card">
        <div class="icon">🔒</div>
        <h2>Enter Verification Code</h2>
        <p>We've sent a 6-digit secure verification code to your email inbox. Enter it below to proceed.</p>
        
        <% if(request.getAttribute("error") != null) { %>
            <div class="error-msg">⚠️ <%= request.getAttribute("error") %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/verify-otp" method="POST">
            <input type="hidden" name="email" value="${email}" />
            
            <div class="input-group">
                <label>6-Digit Security OTP</label>
                <input type="text" name="otp" pattern="\d{6}" maxlength="6" placeholder="000000" required autocomplete="off" autofocus/>
            </div>
            
            <button type="submit" class="btn">Verify Code & Continue</button>
        </form>
    </div>

</body>
</html>