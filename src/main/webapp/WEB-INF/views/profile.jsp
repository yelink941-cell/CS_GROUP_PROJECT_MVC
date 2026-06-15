<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; 
            background: #f8fafc; 
            color: #1e293b;
            min-height: 100vh;
            display: flex; 
            justify-content: center; 
            align-items: center;
            padding: 20px;
        }
        .card { 
            background: #ffffff; 
            border: 1px solid #e2e8f0; 
            border-radius: 16px; 
            width: 100%;
            max-width: 380px; 
            padding: 32px; 
            box-shadow: 0 4px 25px rgba(0, 0, 0, 0.04); 
        }
        .profile-header {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            margin-bottom: 24px;
        }
        .avatar { 
            width: 100px; 
            height: 100px; 
            border-radius: 50%; 
            object-fit: cover; 
            border: 3px solid #f1f5f9;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        .avatar-placeholder {
            width: 100px; 
            height: 100px; 
            border-radius: 50%; 
            background: #e2e8f0; 
            display: inline-block; 
            line-height: 100px; 
            font-size: 36px; 
            color: #475569;
            font-weight: bold;
            border: 3px solid #f1f5f9;
        }
        .name { 
            font-size: 24px; 
            font-weight: 700; 
            color: #0f172a;
            margin: 14px 0 4px 0; 
        }
        .country {
            color: #64748b; 
            font-size: 14px; 
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .edit-btn { 
            color: #0284c7; 
            text-decoration: none; 
            font-size: 13px; 
            font-weight: 600; 
            background: #f0f9ff; 
            padding: 6px 18px; 
            border-radius: 20px; 
            display: inline-block;
            margin-top: 12px;
            transition: all 0.2s ease;
            border: 1px solid #e0f2fe;
        }
        .edit-btn:hover {
            background: #e0f2fe;
            transform: translateY(-1px);
        }
        .bio { 
            color: #475569; 
            font-size: 14px; 
            margin: 24px 0; 
            line-height: 1.6; 
            text-align: center;
            background: #f8fafc;
            padding: 12px 16px;
            border-radius: 12px;
            font-style: italic;
        }
        .info { 
            border-top: 1px solid #f1f5f9; 
            padding-top: 20px; 
            font-size: 14px; 
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }
        .info-row:last-child {
            margin-bottom: 0;
        }
        .info-label {
            color: #64748b;
            font-weight: 500;
        }
        .info-value {
            color: #1e293b;
            font-weight: 600;
        }
        .home-link {
            display: block;
            text-align: center; 
            margin-top: 24px;
            color: #94a3b8;
            font-size: 13px;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s ease;
        }
        .home-link:hover {
            color: #475569;
        }
        .error-msg {
            text-align: center;
            color: #94a3b8;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="card">
        <c:choose>
            <c:when test="${not empty userProfile}">
                <div class="profile-header">
                    <c:choose>
                        <c:when test="${not empty avatarImage}">
                            <img src="data:image/jpeg;base64,${avatarImage}" class="avatar">
                        </c:when>
                        <c:otherwise>
                            <div class="avatar-placeholder">
                                <c:out value="${userProfile.fullName.charAt(0)}" />
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="name"><c:out value="${userProfile.fullName}"/></div>
                    <div class="country">📍 <c:out value="${userProfile.country}"/></div>
                    
                    <a href="${pageContext.request.contextPath}/profile/edit" class="edit-btn">
                        ✏️ Edit Profile
                    </a>
                </div>
                
                <p class="bio">"<c:out value="${userProfile.bio}" />"</p>
                
                <div class="info">
                    <div class="info-row">
                        <span class="info-label">Account:</span>
                        <span class="info-value">@<c:out value="${userProfile.user.username}"/></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Birthday:</span>
                        <span class="info-value"><c:out value="${userProfile.dobDay}/${userProfile.dobMonth}/${userProfile.dobYear}"/></span>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <p class="error-msg">No profile session found.</p>
            </c:otherwise>
        </c:choose>
        <a href="./" class="home-link">Back to Home</a>
    </div>
</body>
</html>