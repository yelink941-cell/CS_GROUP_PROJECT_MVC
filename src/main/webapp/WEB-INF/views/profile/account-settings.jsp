<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Account Settings & Preferences</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f8fafc; color: #1e293b; min-height: 100vh; display: flex; justify-content: center; align-items: center; padding: 20px; }
        
        /* Premium Configuration Card Container */
        .preference-wrapper {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            width: 100%;
            max-width: 480px;
            padding: 32px;
            box-shadow: 0 4px 25px rgba(0, 0, 0, 0.04);
        }
        
        .preference-wrapper h2 {
            font-size: 22px;
            color: #0f172a;
            font-weight: 700;
            margin-bottom: 24px;
            border-bottom: 2px solid #f1f5f9;
            padding-bottom: 12px;
            text-align: center;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label.field-label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #475569;
            margin-bottom: 8px;
        }

        /* Styled Input Fields and Select Dropdowns */
        .custom-input, .custom-select {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            color: #1e293b;
            background-color: #ffffff;
            transition: all 0.2s ease;
            outline: none;
        }

        .custom-input:focus, .custom-select:focus {
            border-color: #0284c7;
            box-shadow: 0 0 0 3px rgba(2, 132, 199, 0.15);
        }

        /* Switch Toggles / Checkbox Group Container */
        .toggle-card-group {
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 18px;
            margin: 24px 0;
        }

        .toggle-card-title {
            font-size: 12px;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 14px;
        }

        .checkbox-row {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 12px;
        }

        .checkbox-row:last-child {
            margin-bottom: 0;
        }

        .checkbox-row input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: #0284c7;
            cursor: pointer;
        }

        .checkbox-row label {
            font-size: 14px;
            font-weight: 500;
            color: #334155;
            cursor: pointer;
            user-select: none;
        }

        /* Action Trigger Buttons */
        .btn-submit-preference {
            width: 100%;
            padding: 12px 24px;
            background-color: #0284c7;
            color: #ffffff;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s ease;
            text-align: center;
        }

        .btn-submit-preference:hover {
            background-color: #0369a1;
        }

        .links-footer {
            display: flex;
            flex-direction: column;
            gap: 10px;
            text-align: center;
            margin-top: 24px;
        }
        
        .footer-link {
            color: #94a3b8;
            font-size: 13px;
            text-decoration: none;
            font-weight: 500;
        }
        
        .footer-link:hover {
            color: #475569;
        }
    </style>
</head>
<body>

<div class="preference-wrapper">
    <h2>⚙️ Preferences Configuration</h2>
    
    <form:form action="${pageContext.request.contextPath}/settings/save" method="POST" modelAttribute="userPreference">
        
        <div class="form-group">
            <label class="field-label">UI Theme Canvas:</label>
            <form:select path="theme" class="custom-select">
                <form:option value="SYSTEM">Follow Operating System Default</form:option>
                <form:option value="LIGHT">Standard Light Aspect</form:option>
                <form:option value="DARK">Midnight Eclipse Mode</form:option>
            </form:select>
        </div>

        <div class="form-group">
            <label class="field-label">Localization Language Code:</label>
            <form:input path="languageCode" placeholder="e.g. en, ja, fr" maxlength="10" class="custom-input"/>
        </div>

        <div class="toggle-card-group">
            <div class="toggle-card-title">Communication Triggers</div>
            
            <div class="checkbox-row">
                <form:checkbox path="emailNotifications" id="prefEmail"/>
                <label for="prefEmail">Mail Alerts & Digest Digests</label>
            </div>
            
            <div class="checkbox-row">
                <form:checkbox path="pushNotifications" id="prefPush"/>
                <label for="prefPush">Live Push Browser Triggers</label>
            </div>
            
            <div class="checkbox-row">
                <form:checkbox path="allowMessages" id="prefMsg"/>
                <label for="prefMsg">Direct Platform Messaging Access</label>
            </div>
        </div>

        <div class="form-group">
            <label class="field-label">Privacy Visibility Level:</label>
            <form:select path="profileVisibility" class="custom-select">
                <form:option value="PUBLIC">Discovery Index (Public)</form:option>
                <form:option value="PRIVATE">Hidden Isolation (Private)</form:option>
            </form:select>
        </div>

        <button type="submit" class="btn-submit-preference">Synchronize Preferences</button>
    </form:form>
    
    <div class="links-footer">
        <a href="${pageContext.request.contextPath}/profile" class="footer-link">← Back to Profile Card</a>
    </div>
</div>

</body>
</html>