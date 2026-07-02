<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4f46e5;
            --primary-hover: #4338ca;
            --secondary: #64748b;
            --secondary-bg: #f1f5f9;
            --secondary-hover: #e2e8f0;
            --danger: #ef4444;
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        
        body { 
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; 
            background: var(--bg); 
            color: var(--text-main); 
            min-height: 100vh; 
        }

        .profile-container {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 60px 20px;
            width: 100%;
        }

        .card { 
            background: var(--card-bg); 
            border: 1px solid var(--border); 
            border-radius: 20px; 
            width: 100%; 
            max-width: 400px; 
            overflow: hidden;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 10px 10px -5px rgba(0, 0, 0, 0.04); 
        }

        .card-cover {
            height: 100px;
            background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
            position: relative;
        }

        .card-body {
            padding: 0 32px 32px 32px;
            position: relative;
        }

        .profile-header { 
            display: flex; 
            flex-direction: column; 
            align-items: center; 
            text-align: center; 
            margin-top: -55px; 
            margin-bottom: 24px; 
        }

        .avatar { 
            width: 110px; 
            height: 110px; 
            border-radius: 50%; 
            object-fit: cover; 
            border: 4px solid var(--card-bg); 
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1); 
        }

        .avatar-placeholder { 
            width: 110px; 
            height: 110px; 
            border-radius: 50%; 
            background: #e0e7ff; 
            display: inline-flex; 
            align-items: center; 
            justify-content: center; 
            font-size: 38px; 
            color: var(--primary); 
            font-weight: 700; 
            border: 4px solid var(--card-bg); 
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1); 
        }

        .name { 
            font-size: 24px; 
            font-weight: 700; 
            color: var(--text-main); 
            margin: 16px 0 6px 0; 
            letter-spacing: -0.025em;
        }

        .badge-container {
            display: flex;
            gap: 8px;
            justify-content: center;
            margin-bottom: 20px;
        }

        .badge {
            background: #f1f5f9;
            color: var(--text-muted);
            padding: 4px 12px;
            border-radius: 100px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .badge-gender {
            background: #e0f2fe;
            color: #0369a1;
        }
        
        .action-group { width: 100%; display: flex; flex-direction: column; gap: 10px; }
        
        .btn-ui { 
            text-decoration: none; 
            font-size: 14px; 
            font-weight: 600; 
            padding: 12px 24px; 
            border-radius: 12px; 
            display: inline-block; 
            border: none; 
            width: 100%; 
            text-align: center; 
            cursor: pointer; 
            transition: all 0.2s ease; 
            box-sizing: border-box;
        }

        .edit-btn { color: #ffffff; background: var(--primary); }
        .edit-btn:hover { background: var(--primary-hover); transform: translateY(-1px); }
        
        .settings-btn { color: var(--text-main); background: var(--secondary-bg); }
        .settings-btn:hover { background: var(--secondary-hover); }

        .bio { 
            color: #475569; 
            font-size: 14px; 
            margin: 24px 0; 
            line-height: 1.6; 
            text-align: center; 
            background: #fafafa; 
            padding: 16px; 
            border-radius: 14px; 
            border-left: 4px solid #cbd5e1;
            font-style: italic; 
        }

        .info { border-top: 1px solid var(--border); padding-top: 20px; font-size: 14px; }
        .info-row { display: flex; justify-content: space-between; align-items: center; }
        .info-label { color: var(--text-muted); font-weight: 500; }
        .info-value { color: var(--text-main); font-weight: 600; background: #f8fafc; padding: 4px 10px; border-radius: 6px; border: 1px solid var(--border); }
        
        .links-footer { display: flex; justify-content: space-between; align-items: center; margin-top: 28px; border-top: 1px solid var(--border); padding-top: 16px;}
        .footer-link { color: var(--text-muted); font-size: 13px; text-decoration: none; font-weight: 500; transition: color 0.2s; }
        .footer-link:hover { color: var(--text-main); }
        .signout-link { color: var(--danger); }
        .signout-link:hover { color: #b91c1c; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />
    
    <main class="profile-container">
        <div class="card">
            <div class="card-cover"></div>

            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty userProfile}">
                        <div class="profile-header">
                            <c:choose>
                                <c:when test="${not empty avatarImage}">
                                    <img src="data:image/jpeg;base64,${avatarImage}" class="avatar" alt="Avatar">
                                </c:when>
                                <c:otherwise>
                                    <div class="avatar-placeholder">
                                        <c:out value="${not empty userProfile.fullName ? userProfile.fullName.substring(0,1).toUpperCase() : 'U'}" />
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            
                            <div class="name"><c:out value="${userProfile.fullName}"/></div>
                            
                            <div class="badge-container">
                                <span class="badge">✨ Verified User</span>
                                <span class="badge badge-gender">🧬 ${userProfile.gender}</span>
                            </div>
                            
                            <div class="action-group">
							    <c:choose>
							        <%-- CASE A: This is MY profile -> Show settings options --%>
							        <c:when test="${currentUser.id == userProfile.user.id}">
							            <a href="${pageContext.request.contextPath}/profile/edit" class="btn-ui edit-btn">✏️ Edit Profile</a>
							            <a href="${pageContext.request.contextPath}/settings" class="btn-ui settings-btn">⚙️ Account Settings</a>
							        </c:when>
							        
							        <%-- CASE B: This is SOMEONE ELSE'S profile -> Render social buttons --%>
							        <c:otherwise>
							            <c:choose>
							                <c:when test="${isFollowing}">
							                    <form action="${pageContext.request.contextPath}/user/unfollow" method="POST" style="width:100%;">
							                        <input type="hidden" name="targetId" value="${userProfile.user.id}" />
							                        <button type="submit" class="btn-ui unfollow-btn">🤝 Unfollow</button>
							                    </form>
							                </c:when>
							                <c:otherwise>
							                    <form action="${pageContext.request.contextPath}/user/follow" method="POST" style="width:100%;">
							                        <input type="hidden" name="targetId" value="${userProfile.user.id}" />
							                        <button type="submit" class="btn-ui follow-btn">➕ Follow</button>
							                    </form>
							                </c:otherwise>
							            </c:choose>
							        </c:otherwise>
							    </c:choose>
							</div>
                        </div>
                        
                        <p class="bio">"<c:out value="${userProfile.bio}" />"</p>
                        
                        <div class="info">
                            <div class="info-row">
                                <span class="info-label">Account Handle</span>
                                <span class="info-value">@<c:out value="${userProfile.user.username}"/></span>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p style="text-align:center; color: var(--text-muted); padding: 40px 0;">No profile record resolved.</p>
                    </c:otherwise>
                </c:choose>
                
                <div class="links-footer">
                    <a href="${pageContext.request.contextPath}/" class="footer-link">← Home</a>
                    <a href="${pageContext.request.contextPath}/logout" class="footer-link signout-link">Sign Out</a>
                </div>
            </div>
        </div>
    </main>
</body>
</html>