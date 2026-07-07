<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications — CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
   <link rel="preconnect" href="https://fonts.googleapis.com"> 
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        
        body {
            background: #f0f4f8;
            font-family: 'Inter', -apple-system, sans-serif;
            color: #1e293b;
            min-height: 100vh;
        }
        
        /* ===== HERO - FULL WIDTH (SAME AS POPULAR.JSP) ===== */
        .library-header {
            width: 100vw;
            margin-left: calc(-50vw + 50%);
            padding: 60px 20px 50px;
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 40%, #4f46e5 100%);
            color: white;
            text-align: center;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 30px rgba(79, 70, 229, 0.25);
        }
        
        .library-header::before {
            content: '';
            position: absolute;
            top: -60%;
            right: -10%;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50%;
        }
        
        .library-header::after {
            content: '';
            position: absolute;
            bottom: -50%;
            left: -5%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.04);
            border-radius: 50%;
        }
        
        .library-header .header-content {
            position: relative;
            z-index: 1;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .library-header .header-icon {
            font-size: 48px;
            display: block;
            margin-bottom: 12px;
        }
        
        .library-header .header-badge {
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 3px;
            opacity: 0.7;
            display: block;
            margin-bottom: 8px;
            color: #c7d2fe;
        }
        
        .library-header h1 {
            font-size: 40px;
            font-weight: 800;
            margin: 0 0 12px 0;
            color: #ffffff;
            letter-spacing: -0.5px;
        }
        
        .library-header h1 span {
            background: rgba(255, 255, 255, 0.12);
            padding: 4px 16px;
            border-radius: 12px;
            display: inline-block;
            letter-spacing: 0;
            text-transform: none;
            font-size: 40px;
        }
        
        .library-header p {
            font-size: 18px;
            opacity: 0.85;
            margin: 0;
            color: #c7d2fe;
            line-height: 1.6;
        }
        
        /* ===== PAGE CONTAINER ===== */
        .page-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px 60px;
        }
        
        /* ===== BACK LINK ===== */
        .back-link-wrapper {
            margin-top: 35px;
            margin-bottom: 24px;
        }
        
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 600;
            color: #64748b;
            text-decoration: none;
            transition: all 0.2s ease;
            padding: 8px 16px;
            background: #ffffff;
            border-radius: 10px;
            border: 1px solid #e8edf4;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }
        
        .back-link:hover {
            color: #4f46e5;
            transform: translateX(-4px);
            border-color: #c7d2fe;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.10);
        }
        
        /* ===== PAGE HEADER ===== */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
            flex-wrap: wrap;
            gap: 16px;
        }
        
        .page-title-block h1 {
            font-size: 28px;
            font-weight: 800;
            color: #1e293b;
            letter-spacing: -0.03em;
            margin: 0;
        }
        
        .page-title-block p {
            font-size: 15px;
            color: #64748b;
            margin: 4px 0 0 0;
        }
        
        /* ===== MARK ALL BUTTON (SAME AS READ LINK) ===== */
        .btn-mark-all {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            background: #4f46e5;
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(79, 70, 229, 0.20);
            text-decoration: none;
        }
        
        .btn-mark-all:hover {
            background: #4338ca;
            transform: translateY(-3px);
            box-shadow: 0 8px 28px rgba(79, 70, 229, 0.35);
        }
        
        /* ===== FLASH MESSAGES ===== */
        .flash {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 28px;
            font-size: 14px;
            font-weight: 600;
            animation: slideDown 0.3s ease;
        }
        
        .flash-success {
            background: #ecfdf5;
            border: 1px solid #a7f3d0;
            color: #047857;
        }
        
        .flash-error {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #b91c1c;
        }
        
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        /* ===== NOTIFICATION LIST ===== */
        .notification-list {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        
        /* ===== NOTIFICATION CARD (SAME AS POPULAR CARD) ===== */
        .notification-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 24px;
            border: 1px solid #e8edf4;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            transition: all 0.3s ease;
            position: relative;
        }
        
        .notification-card:hover {
            border-color: #c7d2fe;
            box-shadow: 0 12px 32px -8px rgba(0, 0, 0, 0.08);
        }
        
        .notification-card.unread {
            border-left: 4px solid #4f46e5;
            background: #fafafe;
        }
        
        .notification-title {
            font-size: 17px;
            font-weight: 700;
            color: #1e293b;
            margin: 0 0 8px 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .notification-message {
            color: #475569;
            margin: 0 0 14px 0;
            line-height: 1.6;
            font-size: 14px;
        }
        
        .notification-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            color: #94a3b8;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .notification-meta-left {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        /* ===== BADGE TYPES (SAME AS CATEGORY LABEL) ===== */
        .badge-type {
            padding: 4px 14px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 11px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        
        .badge-event {
            background: #dbeafe;
            color: #1d4ed8;
        }
        
        .badge-announcement {
            background: #fce7f3;
            color: #be185d;
        }
        
        .badge-system {
            background: #fef3c7;
            color: #92400e;
        }
        
        .badge-default {
            background: #f1f5f9;
            color: #475569;
        }
        
        /* ===== MARK READ BUTTON ===== */
        .btn-read {
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            color: #475569;
            padding: 6px 16px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-read:hover {
            background: #e2e8f0;
            color: #1e293b;
            transform: translateY(-2px);
        }
        
        /* ===== EMPTY STATE (SAME AS POPULAR) ===== */
        .empty-state {
            background: #ffffff;
            border-radius: 16px;
            padding: 60px 30px;
            text-align: center;
            border: 2px dashed #e2e8f0;
        }
        
        .empty-state .empty-icon {
            font-size: 56px;
            display: block;
            margin-bottom: 14px;
        }
        
        .empty-state h2 {
            font-size: 22px;
            color: #1e293b;
            margin: 0 0 8px 0;
        }
        
        .empty-state p {
            color: #64748b;
            font-size: 15px;
            margin: 0;
        }
        
        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .library-header {
                padding: 40px 16px 35px;
            }
            
            .library-header h1 {
                font-size: 28px;
            }
            
            .library-header h1 span {
                font-size: 28px;
            }
            
            .library-header p {
                font-size: 15px;
            }
            
            .page-container {
                padding: 0 14px 40px;
            }
            
            .page-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .btn-mark-all {
                width: 100%;
                justify-content: center;
            }
            
            .notification-card {
                padding: 20px;
            }
            
            .notification-meta {
                flex-direction: column;
                align-items: flex-start;
            }
        }
        
        @media (max-width: 480px) {
            .library-header {
                padding: 30px 14px 25px;
            }
            
            .library-header h1 {
                font-size: 22px;
            }
            
            .library-header h1 span {
                font-size: 22px;
            }
            
            .library-header .header-icon {
                font-size: 32px;
            }
            
            .library-header p {
                font-size: 13px;
            }
            
            .notification-card {
                padding: 16px;
            }
            
            .notification-title {
                font-size: 15px;
            }
        }
    </style>
</head>
<body>

<!-- ===== SITE NAVIGATION WITH NOTIFICATIONS BADGE ===== -->
<jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

<main>
    
    <!-- ===== HERO - FULL WIDTH (SAME AS POPULAR.JSP) ===== -->
    <header class="library-header">
        <div class="header-content">
            <span class="header-icon">🔔</span>
            <span class="header-badge">Stay updated</span>
            <h1><span>Notifications</span></h1>
            <p>Important event announcements and notifications for you</p>
        </div>
    </header>

    <div class="page-container">
        
        <!-- ===== BACK LINK TO HOME ===== -->
        <div class="back-link-wrapper">
            <a href="${pageContext.request.contextPath}/" class="back-link">
                <i class="fas fa-arrow-left"></i> Back to Home
            </a>
        </div>

        <!-- ===== BACK LINK TO COLLECTIONS (ADDED) ===== -->
        <div style="margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/user/collections" class="back-link" style="
                display: inline-flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
                font-weight: 600;
                color: #64748b;
                text-decoration: none;
                transition: all 0.2s ease;
                padding: 8px 16px;
                background: #ffffff;
                border-radius: 10px;
                border: 1px solid #e8edf4;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            ">
            </a>
        </div>

        <!-- ===== PAGE HEADER ===== -->
        <div class="page-header">
            <div class="page-title-block">
                <h1><i class="fa-solid fa-bell" style="color: #4f46e5;"></i> All Notifications</h1>
                <p>Stay updated with the latest announcements and events</p>
            </div>
            <c:if test="${unreadCount > 0}">
                <form action="${pageContext.request.contextPath}/notifications/read-all" method="POST" style="margin:0;">
                    <button type="submit" class="btn-mark-all">
                        <i class="fas fa-check-double"></i> Mark all as read
                    </button>
                </form>
            </c:if>
        </div>

        <!-- ===== FLASH MESSAGES ===== -->
        <c:if test="${not empty success}">
            <div class="flash flash-success">
                <i class="fas fa-check-circle"></i> <c:out value="${success}"/>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="flash flash-error">
                <i class="fas fa-exclamation-circle"></i> <c:out value="${error}"/>
            </div>
        </c:if>

        <!-- ===== NOTIFICATION LIST ===== -->
        <div class="notification-list">
            <c:choose>
                <c:when test="${empty notifications}">
                    <div class="empty-state">
                        <span class="empty-icon">📬</span>
                        <h2>No notifications yet</h2>
                        <p>When admin broadcasts or moderation updates arrive, they will appear here.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="n" items="${notifications}">
                        <div class="notification-card ${n.isRead ? '' : 'unread'}">
                            <h3 class="notification-title">
                                <c:out value="${n.title}"/>
                            </h3>
                            <p class="notification-message"><c:out value="${n.message}"/></p>
                            <div class="notification-meta">
                                <div class="notification-meta-left">
                                    <span class="badge-type 
                                        ${n.type == 'EVENT' ? 'badge-event' : 
                                          (n.type == 'ANNOUNCEMENT' ? 'badge-announcement' : 
                                           (n.type == 'SYSTEM' ? 'badge-system' : 'badge-default'))}">
                                        <c:out value="${n.type}"/>
                                    </span>
                                    <span>·</span>
                                    <span><c:out value="${n.createdAt}"/></span>
                                </div>
                                <c:if test="${!n.isRead}">
                                    <form action="${pageContext.request.contextPath}/notifications/${n.id}/read" method="POST" style="margin:0;">
                                        <button type="submit" class="btn-read">
                                            <i class="fas fa-check"></i> Mark read
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>
<footer class="site-footer">
    <div class="footer-container">
        <div class="footer-brand">
            <h2>📚 CheatSheet Hub</h2>
            <p>Community-built cheat sheets for quick learning, practical references, and clean knowledge sharing. Your go-to resource for developer guides and technical references.</p>
        </div>
        <div class="footer-links">
            <h3>Quick Links</h3>
            <nav>
                <a href="${pageContext.request.contextPath}/">🏠 Home</a>
                <a href="${pageContext.request.contextPath}/posts/public">📄 View Posts</a>
                <a href="${pageContext.request.contextPath}/posts/categories">📁 Categories</a>
                <a href="${pageContext.request.contextPath}/posts/popular">🔥 Popular</a>
                <a href="${pageContext.request.contextPath}/posts/trending">📈 Trending</a>
            </nav>
        </div>
    </div>
    <div class="footer-bottom">
        <small>&copy; 2026 CheatSheet Hub. All rights reserved.</small>
        <div class="footer-legal">
            <a href="#"><i class="fas fa-lock"></i> Privacy Policy</a>
            <a href="#"><i class="fas fa-file-contract"></i> Terms of Service</a>
            <a href="#"><i class="fas fa-envelope"></i> Contact</a>
        </div>
    </div>
</footer>
<script>
    // Auto-hide flash messages after 4 seconds
    setTimeout(() => {
        document.querySelectorAll('.flash').forEach(el => {
            el.style.transition = 'opacity 0.5s ease';
            el.style.opacity = '0';
            setTimeout(() => el.remove(), 500);
        });
    }, 4000);
</script>

</body>
</html>