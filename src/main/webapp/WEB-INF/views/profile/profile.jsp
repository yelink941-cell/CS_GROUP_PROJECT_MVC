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

        .action-group { width: 100%; display: flex; flex-direction: column; gap: 8px; }
        .btn-ui { 
            text-decoration: none; font-size: 14px; font-weight: 600; padding: 10px 16px; 
            border-radius: 10px; display: inline-block; border: none; width: 100%; 
            text-align: center; cursor: pointer; transition: all 0.2s; 
        }
        .edit-btn { color: #ffffff; background: var(--primary); }
        .edit-btn:hover { background: var(--primary-hover); }
        .follow-btn { color: #ffffff; background: #0f172a; }
        .follow-btn:hover { background: #1e293b; }
        .unfollow-btn { color: var(--text-main); background: #ffffff; border: 1px solid var(--border); }
        .unfollow-btn:hover { background: #fff5f5; color: var(--danger); border-color: var(--danger); }

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
                                    
                                    <div class="stats-container">
                                        <div class="stat-item" onclick="scrollToPostsFeed()" style="cursor: pointer;">
                                            <div class="stat-value"><c:out value="${not empty postCount ? postCount : 0}"/></div>
                                            <div class="stat-label">Posts</div>
                                        </div>
                                        <div class="stat-item" onclick="openFollowModal('followersModal')" style="cursor: pointer;">
                                            <div class="stat-value"><c:out value="${not empty followerCount ? followerCount : 0}"/></div>
                                            <div class="stat-label">Followers</div>
                                        </div>
                                        <div class="stat-item" onclick="openFollowModal('followingModal')" style="cursor: pointer;">
                                            <div class="stat-value"><c:out value="${not empty followingCount ? followingCount : 0}"/></div>
                                            <div class="stat-label">Following</div>
                                        </div>
                                    </div>
                                    
                                    <div class="action-group">
                                        <c:choose>
                                            <c:when test="${currentUser.id == userProfile.user.id}">
                                                <a href="${pageContext.request.contextPath}/profile/edit" class="btn-ui edit-btn"><i class="fa-solid fa-pen"></i> Edit Profile</a>
                                            </c:when>
                                            
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
                            <span class="tab" id="tab-saved" onclick="switchProfileTab('saved')">Liked Posts</span>
                            <span class="tab active" id="tab-activity" onclick="switchProfileTab('activity')">
                                <c:choose>
                                    <c:when test="${currentUser.id == userProfile.user.id}">My Posts</c:when>
                                    <c:otherwise>Recent Activity</c:otherwise>
                                </c:choose>
                            </span>
                        </nav>

                        <div id="panel-activity" class="profile-tab-panel">
                            <div class="posts-feed-container">
                                <c:choose>
                                    <c:when test="${not empty userPosts}">
                                        <c:forEach var="post" items="${userPosts}">
                                            <div class="feed-item" style="margin-bottom: 16px; box-shadow: 0 1px 3px rgba(0,0,0,0.02); background: var(--card-bg); border: 1px solid var(--border); border-radius: 12px; padding: 20px; display: flex; flex-direction: column; gap: 12px;">
                                                <div class="feed-header" style="display: flex; justify-content: space-between; align-items: center; color: var(--text-muted); font-size: 13px;">
                                                    <span>📝 Published a cheat sheet</span>
                                                    <span style="background: #e0f2fe; color: #0369a1; padding: 2px 8px; border-radius: 12px; font-weight: 600; text-transform: uppercase; font-size: 10px;">
                                                        <c:out value="${post.category.name}" default="Programming" />
                                                    </span>
                                                </div>
                                                
                                                <h3 style="font-size: 18px; font-weight: 700; margin: 4px 0;">
                                                    <a href="${pageContext.request.contextPath}/user/posts/${post.slug}" style="color: #4038ff; text-decoration: none;">
                                                        <c:out value="${post.title}" />
                                                    </a>
                                                </h3>
                                                
                                                <p style="color: #475569; font-size: 14px; line-height: 1.5;">
                                                    <c:out value="${post.excerpt}" default="Click to view inside this cheat sheet portfolio." />
                                                </p>
                                                
                                                <div style="display: flex; gap: 16px; font-size: 12px; color: #64748b; border-top: 1px solid #f1f5f9; padding-top: 10px; margin-top: 4px;">
                                                    <span>❤️ <strong>${postLikeCounts[post.id] != null ? postLikeCounts[post.id] : 0}</strong> Likes</span>
                                                    <span>⚙️ Status: <strong style="color: ${post.status == 'PUBLISHED' ? '#10b981' : '#f59e0b'}"><c:out value="${post.status}" /></strong></span>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="feed-item" style="text-align: center; padding: 32px; color: #64748b; border: 1px dashed #cbd5e1; background: #f8fafc; margin-bottom: 16px; border-radius: 12px;">
                                            <span style="font-size: 24px; display: block; margin-bottom: 8px;">📂</span>
                                            <p style="font-size: 14px; font-weight: 500;">No cheat sheets published yet.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div id="panel-saved" class="profile-tab-panel" style="display: none;">
                            <div class="posts-feed-container">
                                <c:choose>
                                    <c:when test="${not empty savedPosts}">
                                        <c:forEach var="post" items="${savedPosts}">
                                            <div class="feed-item" style="margin-bottom: 16px; box-shadow: 0 1px 3px rgba(0,0,0,0.02); background: var(--card-bg); border: 1px solid var(--border); border-radius: 12px; padding: 20px; display: flex; flex-direction: column; gap: 12px;">
                                                <div class="feed-header" style="display: flex; justify-content: space-between; align-items: center; color: var(--text-muted); font-size: 13px;">
                                                    <span>❤️ Liked Cheat Sheet</span>
                                                    <span style="background: #eedffc; color: #7c3aed; padding: 2px 8px; border-radius: 12px; font-weight: 600; text-transform: uppercase; font-size: 10px;">
                                                        <c:out value="${post.category.name}" default="Programming" />
                                                    </span>
                                                </div>
                                                
                                                <h3 style="font-size: 18px; font-weight: 700; margin: 4px 0;">
                                                    <a href="${pageContext.request.contextPath}/user/posts/${post.slug}" style="color: #4038ff; text-decoration: none;">
                                                        <c:out value="${post.title}" />
                                                    </a>
                                                </h3>
                                                
                                                <p style="color: #475569; font-size: 14px; line-height: 1.5;">
                                                    <c:out value="${post.excerpt}" default="Click to view inside this document." />
                                                </p>
                                                
                                                <div style="display: flex; gap: 16px; font-size: 12px; color: #64748b; border-top: 1px solid #f1f5f9; padding-top: 10px; margin-top: 4px;">
                                                    <span>❤️ <strong>${postLikeCounts[post.id] != null ? postLikeCounts[post.id] : 0}</strong> Likes</span>
                                                    <span>⚙️ Status: <strong style="color: ${post.status == 'PUBLISHED' ? '#10b981' : '#f59e0b'}"><c:out value="${post.status}" /></strong></span>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
									    <div class="feed-item" style="text-align: center; padding: 40px; color: #64748b; border: 1px dashed #cbd5e1; background: #f8fafc; border-radius: 12px;">
									        <span style="font-size: 28px; display: block; margin-bottom: 8px;">❤️</span>
									        <p style="font-size: 14px; font-weight: 600; color: #0f172a;">Your Liked Posts</p>
									        <p style="font-size: 13px; color: #64748b; margin-top: 4px;">Posts you like across the platform will show up here instantly.</p>
									    </div>
									</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                    </section>
                </div>
            </c:when>
            
            <c:otherwise>
                <div style="max-width: 400px; margin: 100px auto; text-align:center;" class="card">
                    <div class="card-body" style="padding: 40px;">
                        <p style="color: var(--text-muted);">No profile record resolved.</p>
                        <a href="${pageContext.request.contextPath}/" class="btn-ui settings-btn" style="margin-top: 20px; display: inline-block; text-decoration: none;">Return Home</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <div id="followersModal" class="tiktok-modal" style="display: none; position: fixed; z-index: 9999; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); align-items: center; justify-content: center; backdrop-filter: blur(4px);">
        <div style="background: white; width: 100%; max-width: 420px; border-radius: 16px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.15); overflow: hidden;">
            <div style="display: flex; justify-content: space-between; align-items: center; padding: 16px 20px; border-bottom: 1px solid var(--border);">
                <h3 style="font-size: 16px; font-weight: 700;">Followers</h3>
                <span onclick="closeFollowModal('followersModal')" style="cursor: pointer; font-size: 18px; color: var(--secondary);"><i class="fa-solid fa-xmark"></i></span>
            </div>
            <div style="max-height: 380px; overflow-y: auto; padding: 16px 20px;">
                <c:choose>
                    <c:when test="${not empty followersList}">
                        <c:forEach var="followerUser" items="${followersList}">
                            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 14px;">
                                <div style="display: flex; align-items: center; gap: 12px;">
                                    <div style="width: 40px; height: 40px; background: #e0e7ff; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; color: var(--primary);">
                                        <c:out value="${not empty followerUser.profile.fullName ? followerUser.profile.fullName.substring(0,1).toUpperCase() : 'U'}" />
                                    </div>
                                    <div>
                                        <div style="font-size: 14px; font-weight: 600;"><c:out value="${followerUser.profile.fullName}"/></div>
                                        <div style="font-size: 12px; color: var(--text-muted)">@<c:out value="${followerUser.username}"/></div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div style="text-align:center; color:var(--text-muted); padding:20px;">No followers yet.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <div id="followingModal" class="tiktok-modal" style="display: none; position: fixed; z-index: 9999; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); align-items: center; justify-content: center; backdrop-filter: blur(4px);">
        <div style="background: white; width: 100%; max-width: 420px; border-radius: 16px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.15); overflow: hidden;">
            <div style="display: flex; justify-content: space-between; align-items: center; padding: 16px 20px; border-bottom: 1px solid var(--border);">
                <h3 style="font-size: 16px; font-weight: 700;">Following</h3>
                <span onclick="closeFollowModal('followingModal')" style="cursor: pointer; font-size: 18px; color: var(--secondary);"><i class="fa-solid fa-xmark"></i></span>
            </div>
            <div style="max-height: 380px; overflow-y: auto; padding: 16px 20px;">
                <c:choose>
                    <c:when test="${not empty followingList}">
                        <c:forEach var="followedUser" items="${followingList}">
                            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 14px;">
                                <div style="display: flex; align-items: center; gap: 12px;">
                                    <div style="width: 40px; height: 40px; background: #eedffc; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; color: #7c3aed;">
                                        <c:out value="${not empty followedUser.profile.fullName ? followedUser.profile.fullName.substring(0,1).toUpperCase() : 'U'}" />
                                    </div>
                                    <div>
                                        <div style="font-size: 14px; font-weight: 600;"><c:out value="${followedUser.profile.fullName}"/></div>
                                        <div style="font-size: 12px; color: var(--text-muted)">@<c:out value="${followedUser.username}"/></div>
                                    </div>
                                </div>
                                
                                <form action="${pageContext.request.contextPath}/user/unfollow" method="POST" style="margin: 0;">
                                    <input type="hidden" name="targetId" value="${followedUser.id}" />
                                    <button type="submit" style="font-size: 12px; font-weight: 600; padding: 6px 12px; border-radius: 6px; background: #ffffff; border: 1px solid var(--border); cursor: pointer; color: var(--danger);">
                                        Unfollow
                                    </button>
                                </form>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div style="text-align:center; color:var(--text-muted); padding:20px;">Not following anyone yet.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        function switchProfileTab(tabName) {
            document.querySelectorAll('.profile-tab-panel').forEach(function(panel) {
                panel.style.display = 'none';
            });
            
            document.querySelectorAll('.tab').forEach(function(tab) {
                tab.classList.remove('active');
            });
            
            const targetPanel = document.getElementById('panel-' + tabName);
            if (targetPanel) {
                targetPanel.style.display = 'block';
            }
            
            const targetTab = document.getElementById('tab-' + tabName);
            if (targetTab) {
                targetTab.classList.add('active');
            }
        }

        function openFollowModal(modalId) {
            const modal = document.getElementById(modalId);
            if (modal) modal.style.display = 'flex';
        }

        function closeFollowModal(modalId) {
            const modal = document.getElementById(modalId);
            if (modal) modal.style.display = 'none';
        }

        window.onclick = function(event) {
            if (event.target.classList.contains('tiktok-modal')) {
                event.target.style.display = 'none';
            }
        }

        function scrollToPostsFeed() {
            switchProfileTab('activity');
            
            setTimeout(function() {
                const mainContent = document.querySelector('.main-content');
                if (mainContent) {
                    mainContent.scrollIntoView({ 
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            }, 50);
        }
    </script>
</body>
</html>