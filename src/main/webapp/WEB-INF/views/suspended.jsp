<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Account Suspended - CheatSheet</title>
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
            max-width: 520px;
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
            font-size: 16px;
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
            margin-top: 28px;
            padding-top: 24px;
            border-top: 1px solid #e2e8f0;
        }
        .contact-section p {
            font-size: 14px;
            color: #64748b;
            margin-bottom: 16px;
        }
        .btn-contact {
            display: inline-block;
            padding: 12px 28px;
            background: #0284c7;
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.2s;
        }
        .btn-contact:hover {
            background: #0369a1;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(2, 132, 199, 0.3);
        }
        .footer-text {
            margin-top: 32px;
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
            Your account has been suspended due to a violation of our community guidelines.
            During this time, you will not be able to access your account or perform any actions.
        </p>

        <div class="reason-box">
            <h4>Possible Reasons</h4>
            <p>
                This action was taken by an administrator after reviewing reported content or behavior
                that violated our terms of service. The suspension may be temporary or permanent
                depending on the severity of the violation.
            </p>
        </div>

        <ul class="info-list">
            <li><span class="bullet"></span> Your posts and comments may have been removed</li>
            <li><span class="bullet"></span> Your account session has been terminated</li>
            <li><span class="bullet"></span> Your profile is no longer visible to other users</li>
            <li><span class="bullet"></span> This action has been logged for administrative review</li>
        </ul>

        <div class="contact-section">
            <p>If you believe this is a mistake, please contact our support team.</p>
            <a href="mailto:admin@cheatsheet.com" class="btn-contact">Contact Support</a>
        </div>

        <div class="footer-text">
            &copy; 2026 CheatSheet &mdash; Community Guidelines Enforcement
        </div>
    </div>

</body>
</html>
