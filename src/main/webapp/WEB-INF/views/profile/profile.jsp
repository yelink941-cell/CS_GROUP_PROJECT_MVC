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

        /* 🌟 Realworld App Layout Grid */
        .profile-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 360px 1fr;
            gap: 30px;
        }

        @media (max-width: 900px) {
            .profile-container { grid-template-columns: 1fr; }
        }

        /* Sidebar & Cards Layout */
        .profile-sidebar { display: flex; flex-direction: column; gap: 20px; }
        .card { 
            background: var(--card-bg); 
            border: 1px solid var(--border); 
            border-radius: 16px; 
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); 
        }

        .card-cover {
            height: 120px;
            background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
        }

        .card-body { padding: 0 24px 24px 24px; }

        .profile-header { 
            display: flex; 
            flex-direction: column; 
            align-items: center; 
            text-align: center; 
            margin-top: -60px; 
            margin-bottom: 20px; 
        }

        .avatar, .avatar-placeholder { 
            width: 120px; height: 120px; border-radius: 50%; object-fit: cover; 
            border: 4px solid var(--card-bg); box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); 
        }
        .avatar-placeholder {
            background: #e0e7ff; display: inline-flex; align-items: center; 
            justify-content: center; font-size: 42px; color: var(--primary); font-weight: 700;
        }

        .name { font-size: 24px; font-weight: 700; margin: 12px 0 4px 0; letter-spacing: -0.025em; }
        .username { color: var(--text-muted); font-size: 15px; margin-bottom: 16px; }

        /* Realworld Stat Counters */
        .stats-container {
            display: flex;
            justify-content: auto;
            gap: 24px;
            padding: 16px 0;
            border-top: 1px solid var(--border);
            border-bottom: 1px solid var(--border);
            margin: 20px 0;
        }
        .stat-item { text-align: center; flex: 1; }
        .stat-value { font-size: 18px; font-weight: 700; color: var(--text-main); }
        .stat-label { font-size: 12px; color: var(--text-muted); font-weight: 500; text-transform: uppercase; }

        .bio { color: #475569; font-size: 14px; line-height: 1.6; text-align: center; margin-bottom: 20px; }

        /* Buttons Setup */
        .action-group { width: 100%; display: flex; flex-direction: column; gap: 8px; }
        .btn-ui { 
            text-decoration: none; font-size: 14px; font-weight: 600; padding: 10px 16px; 
            border-radius: 10px; display: inline-block; border: none; width: 100%; 
            text-align: center; cursor: pointer; transition: all 0.2s; 
        }
        .edit-btn { color: #ffffff; background: var(--primary); }
        .edit-btn:hover { background: var(--primary-hover); }
        .settings-btn { color: var(--text-main); background: var(--secondary-bg); }
        .settings-btn:hover { background: var(--secondary-hover); }
        .follow-btn { color: #ffffff; background: #0f172a; }
        .follow-btn:hover { background: #1e293b; }
        .unfollow-btn { color: var(--text-main); background: #ffffff; border: 1px solid var(--border); }
        .unfollow-btn:hover { background: #fff5f5; color: var(--danger); border-color: var(--danger); }

        /* Main Right Content Section */
        .main-content { display: flex; flex-direction: column; gap: 20px; }
        .tabs { display: flex; gap: 20px; border-bottom: 2px solid var(--border); padding-bottom: 2px; }
        .tab { 
            font-size: 15px; font-weight: 600; color: var(--text-muted); 
            padding: 12px 4px; cursor: pointer; text-decoration: none; border-bottom: 2px solid transparent;
        }
        .tab.active { color: var(--primary); border-bottom-color: var(--primary); }

        .feed-item {
            background: var(--card-bg); border: 1px solid var(--border);
            border-radius: 12px; padding: 20px; display: flex; flex-direction: column; gap: 12px;
        }
        .feed-header { display: flex; justify-content: space-between; align-items: center; color: var(--text-muted); font-size: 13px; }
    </style>
</head>
<body>
    
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main>
        <c:choose>
            <c:when test="${not empty userProfile}">
                <div class="profile-container">
                    
                    <aside class="profile-sidebar">
                        <div class="card">
                            <div class="card-cover"></div>
                            <div class="card-body">
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
                                    <div class="username">@<c:out value="${userProfile.user.username}"/></div>
                                    
                                    <p class="bio">"<c:out value="${userProfile.bio}" />"</p>
                                    
                                    <div class="stats-container">
                                        <div class="stat-item">
                                            <div class="stat-value"><c:out value="${not empty postCount ? postCount : 0}"/></div>
                                            <div class="stat-label">Posts</div>
                                        </div>
                                        <div class="stat-item">
                                            <div class="stat-value"><c:out value="${not empty followerCount ? followerCount : 0}"/></div>
                                            <div class="stat-label">Followers</div>
                                        </div>
                                        <div class="stat-item">
                                            <div class="stat-value"><c:out value="${not empty followingCount ? followingCount : 0}"/></div>
                                            <div class="stat-label">Following</div>
                                        </div>
                                    </div>
                                    
                                    <div class="action-group">
                                        <c:choose>
                                            <%-- CASE A: This is MY profile -> Show settings options --%>
                                            <c:when test="${currentUser.id == userProfile.user.id}">
                                                <a href="${pageContext.request.contextPath}/profile/edit" class="btn-ui edit-btn"><i class="fa-solid fa-pen"></i> Edit Profile</a>
                                                <a href="${pageContext.request.contextPath}/settings" class="btn-ui settings-btn"><i class="fa-solid fa-gear"></i> Settings</a>
                                            </c:when>
                                            
                                            <%-- CASE B: This is someone else's profile -> Check login session status to toggle follow actions --%>
                                            <c:when test="${not empty currentUser}">
                                                <c:choose>
                                                    <c:when test="${isFollowing}">
                                                        <form action="${pageContext.request.contextPath}/user/unfollow" method="POST" style="width: 100%;">
                                                            <input type="hidden" name="targetId" value="${userProfile.user.id}" />
                                                            <button type="submit" class="btn-ui unfollow-btn">
                                                                <i class="fa-solid fa-user-minus"></i> Unfollow User
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form action="${pageContext.request.contextPath}/user/follow" method="POST" style="width: 100%;">
                                                            <input type="hidden" name="targetId" value="${userProfile.user.id}" />
                                                            <button type="submit" class="btn-ui follow-btn">
                                                                <i class="fa-solid fa-user-plus"></i> Follow User
                                                            </button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </aside>

                    <section class="main-content">
                        <nav class="tabs">
                            <span class="tab active">Recent Activity</span>
                            <span class="tab">Saved Sheets</span>
                            <span class="tab">About Info</span>
                        </nav>

                        <div class="feed-item">
                            <div class="feed-header">
                                <span>📝 Shared a code snippet</span>
                                <span>Just now</span>
                            </div>
                            <h3>Welcome to my MVC CheatSheet Profile!</h3>
                            <p style="color: var(--text-muted); font-size: 14px; line-height: 1.5;">
                                This area is dedicated to rendering dynamic content lists using loop components like <code>&lt;c:forEach&gt;</code> tags.
                            </p>
                        </div>
                    </section>
                    
                </div>
            </c:when>
            <c:otherwise>
                <div style="max-width: 400px; margin: 100px auto; text-align:center;" class="card">
                    <div class="card-body" style="padding: 40px;">
                        <p style="color: var(--text-muted);">No profile record resolved.</p>
                        <a href="${pageContext.request.contextPath}/" class="btn-ui settings-btn" style="margin-top: 20px;">Return Home</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</body>
</html>