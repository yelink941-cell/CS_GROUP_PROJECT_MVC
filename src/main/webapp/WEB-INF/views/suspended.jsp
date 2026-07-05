<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Account Suspended - CheatSheet</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #334155 100%);
            color: #e2e8f0;
            padding: 20px;
        }
        .suspended-card {
            background: white;
            border-radius: 20px;
            padding: 48px;
            max-width: 540px;
            width: 100%;
            text-align: center;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.4);
            position: relative;
            overflow: hidden;
        }
        .suspended-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: linear-gradient(90deg, #ef4444, #f59e0b);
        }
        .icon-wrapper {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: #fee2e2;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 24px;
            font-size: 48px;
        }
        .suspended-card h1 {
            font-size: 28px;
            color: #0f172a;
            margin-bottom: 12px;
            font-weight: 700;
        }
        .suspended-card .subtitle {
            font-size: 15px;
            color: #64748b;
            margin-bottom: 24px;
            line-height: 1.6;
        }
        .reason-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-left: 4px solid #ef4444;
            border-radius: 10px;
            padding: 16px 20px;
            margin-bottom: 24px;
            text-align: left;
        }
        .reason-box h4 {
            font-size: 13px;
            color: #ef4444;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
            font-weight: 700;
        }
        .reason-box p {
            font-size: 14px;
            color: #475569;
            line-height: 1.5;
        }
        .info-list {
            text-align: left;
            margin-bottom: 28px;
            padding: 0;
            list-style: none;
        }
        .info-list li {
            font-size: 14px;
            color: #475569;
            padding: 8px 0;
            border-bottom: 1px solid #f1f5f9;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .info-list li:last-child { border-bottom: none; }
        .info-list .bullet {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #0284c7;
            flex-shrink: 0;
        }
        .contact-section {
            margin-top: 24px;
            padding-top: 20px;
            border-top: 1px solid #e2e8f0;
        }
        .button-group {
            display: flex;
            gap: 10px;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
            margin-top: 16px;
        }
        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 10px 20px;
            background: #e2e8f0;
            color: #1e293b;
            text-decoration: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s;
        }
        .btn-back:hover {
            background: #cbd5e1;
            color: #0f172a;
            transform: translateY(-1px);
        }
        .btn-contact {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 10px 20px;
            background: #0284c7;
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s;
        }
        .btn-contact:hover {
            background: #0369a1;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(2, 132, 199, 0.3);
        }
        .btn-logout-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 10px 20px;
            background: #fee2e2;
            color: #991b1b;
            text-decoration: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s;
        }
        .btn-logout-link:hover {
            background: #fecaca;
            color: #7f1d1d;
            transform: translateY(-1px);
        }
        .footer-text {
            margin-top: 28px;
            font-size: 12px;
            color: #94a3b8;
        }
    </style>
</head>
<body>

    <div class="suspended-card">
        <div class="icon-wrapper">&#128683;</div>
        <h1>Account Suspended</h1>
        <p class="subtitle">
            Your account permissions have been restricted due to a moderation action.
        </p>

        <% if (session.getAttribute("error") != null) { %>
            <div class="reason-box" style="background:#fef2f2; border-left-color:#ef4444;">
                <h4>Restriction Reason</h4>
                <p style="font-weight:600; color:#991b1b;"><%= session.getAttribute("error") %></p>
            </div>
            <% session.removeAttribute("error"); %>
        <% } else { %>
            <div class="reason-box">
                <h4>Possible Reasons</h4>
                <p>
                    This action was taken by an administrator after reviewing reported content or behavior that violated our community guidelines.
                </p>
            </div>
        <% } %>

        <ul class="info-list">
            <li><span class="bullet"></span> Post creation or commenting features may be restricted</li>
            <li><span class="bullet"></span> Your active restrictions will automatically expire when the ban period ends</li>
            <li><span class="bullet"></span> This moderation event is logged in admin report records</li>
        </ul>

        <div class="contact-section">
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Back to Home
                </a>
                <a href="mailto:admin@cheatsheet.com" class="btn-contact">
                    <i class="fas fa-envelope"></i> Contact Support
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout-link">
                    <i class="fas fa-sign-out-alt"></i> Sign Out
                </a>
            </div>
        </div>

        <div class="footer-text">
            &copy; 2026 CheatSheet &mdash; Community Guidelines Enforcement
        </div>
    </div>

</body>
</html>
