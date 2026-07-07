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
        }

        body {
            margin: 0;
            background: #f0f4f8;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            color: #1e293b;
            min-height: 100vh;
        }

        main {
            background: #f0f4f8;
        }

        /* ===== HERO - CLEAN VERSION ===== */
        .library-header {
            width: 100%;
            margin: 0;
            padding: 42px 20px;
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 45%, #4f46e5 100%);
            color: #ffffff;
            text-align: center;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 25px rgba(79, 70, 229, 0.22);
            border-radius: 0 0 28px 28px;
        }

        .library-header .header-content {
            max-width: 900px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        .library-header .header-icon {
            font-size: 40px;
            display: block;
            margin-bottom: 10px;
        }

        .library-header .header-badge {
            display: block;
            margin-bottom: 10px;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 2.5px;
            text-transform: uppercase;
            color: #c7d2fe;
        }

        .library-header h1 {
            margin: 0 0 10px;
            font-size: 32px;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.4px;
        }

        .library-header h1 span {
            display: inline-block;
            padding: 6px 18px;
            border-radius: 14px;
            background: rgba(255, 255, 255, 0.12);
            font-size: 32px;
        }

        .library-header p {
            margin: 0;
            font-size: 16px;
            color: #c7d2fe;
            line-height: 1.6;
        }

        /* ===== PAGE CONTAINER ===== */
        .page-container {
            max-width: 1280px;
            margin: 0 auto;
            padding: 36px 24px 64px;
        }

        /* ===== BACK LINK ===== */
        .back-link-wrapper {
            margin-bottom: 26px;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 16px;
            background: #ffffff;
            border: 1px solid #e8edf4;
            border-radius: 12px;
            color: #64748b;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            box-shadow: 0 2px 8px rgba(15, 23, 42, 0.04);
            transition: all 0.2s ease;
        }

        .back-link:hover {
            color: #4f46e5;
            border-color: #c7d2fe;
            transform: translateX(-3px);
            box-shadow: 0 6px 16px rgba(79, 70, 229, 0.12);
        }

        /* ===== PAGE HEADER ===== */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px;
            margin-bottom: 28px;
            flex-wrap: wrap;
        }

        .page-title-block h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 800;
            color: #1e293b;
            letter-spacing: -0.03em;
        }

        .page-title-block p {
            margin: 5px 0 0;
            color: #64748b;
            font-size: 15px;
        }

        .btn-mark-all {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 11px 22px;
            background: #4f46e5;
            color: #ffffff;
            border: none;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 800;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(79, 70, 229, 0.22);
            transition: all 0.2s ease;
        }

        .btn-mark-all:hover {
            background: #4338ca;
            transform: translateY(-2px);
            box-shadow: 0 8px 22px rgba(79, 70, 229, 0.32);
        }

        /* ===== FLASH ===== */
        .flash {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px 18px;
            border-radius: 14px;
            margin-bottom: 24px;
            font-size: 14px;
            font-weight: 700;
            animation: slideDown 0.25s ease;
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
            from {
                opacity: 0;
                transform: translateY(-8px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* ===== NOTIFICATION GRID ===== */
        .notification-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(420px, 1fr));
            gap: 22px;
        }

        .notification-card {
            position: relative;
            height: 100%;
            background: #ffffff;
            border-radius: 18px;
            padding: 24px;
            border: 1px solid #e8edf4;
            box-shadow: 0 3px 10px rgba(15, 23, 42, 0.04);
            transition: all 0.22s ease;
        }

        .notification-card:hover {
            transform: translateY(-3px);
            border-color: #c7d2fe;
            box-shadow: 0 14px 34px rgba(15, 23, 42, 0.08);
        }

        .notification-card.unread {
            border-left: 5px solid #4f46e5;
            background: #fafafe;
        }

        .notification-title {
            margin: 0 0 9px;
            font-size: 17px;
            font-weight: 800;
            color: #1e293b;
            line-height: 1.4;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .notification-message {
            margin: 0 0 16px;
            color: #475569;
            line-height: 1.65;
            font-size: 14px;
        }

        .notification-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            color: #94a3b8;
            font-size: 12px;
            flex-wrap: wrap;
            padding-top: 14px;
            border-top: 1px solid #f1f5f9;
        }

        .notification-meta-left {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .badge-type {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 5px 13px;
            border-radius: 999px;
            font-weight: 800;
            font-size: 11px;
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

        .btn-read {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            color: #475569;
            padding: 7px 15px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 800;
            transition: all 0.2s ease;
        }

        .btn-read:hover {
            background: #e2e8f0;
            color: #1e293b;
            transform: translateY(-2px);
        }

        /* ===== EMPTY ===== */
        .empty-state {
            grid-column: 1 / -1;
            background: #ffffff;
            border-radius: 18px;
            padding: 60px 30px;
            text-align: center;
            border: 2px dashed #dbeafe;
            box-shadow: 0 4px 14px rgba(15, 23, 42, 0.04);
        }

        .empty-state .empty-icon {
            display: block;
            margin-bottom: 14px;
            font-size: 56px;
        }

        .empty-state h2 {
            margin: 0 0 8px;
            font-size: 22px;
            color: #1e293b;
        }

        .empty-state p {
            margin: 0;
            color: #64748b;
            font-size: 15px;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 1024px) {
            .notification-list {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .library-header {
                padding: 34px 16px;
                border-radius: 0 0 22px 22px;
            }

            .library-header .header-icon {
                font-size: 34px;
            }

            .library-header h1,
            .library-header h1 span {
                font-size: 27px;
            }

            .library-header p {
                font-size: 14px;
            }

            .page-container {
                padding: 28px 14px 44px;
            }

            .page-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .btn-mark-all {
                width: 100%;
            }

            .notification-card {
                padding: 20px;
            }

            .notification-meta {
                align-items: flex-start;
                flex-direction: column;
            }
        }

        @media (max-width: 480px) {
            .library-header {
                padding: 28px 14px;
            }

            .library-header h1,
            .library-header h1 span {
                font-size: 22px;
            }

            .library-header .header-icon {
                font-size: 30px;
            }

            .library-header p {
                font-size: 13px;
            }

            .page-title-block h1 {
                font-size: 23px;
            }

            .notification-list {
                grid-template-columns: 1fr;
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

<jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

<main>
    <header class="library-header">
        <div class="header-content">
            <span class="header-icon">🔔</span>
            <span class="header-badge">Stay updated</span>
            <h1><span>Notifications</span></h1>
            <p>Important event announcements and notifications for you</p>
        </div>
    </header>

    <div class="page-container">

        <div class="back-link-wrapper">
            <a href="${pageContext.request.contextPath}/" class="back-link">
                <i class="fas fa-arrow-left"></i> Back to Home
            </a>
        </div>

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

                            <p class="notification-message">
                                <c:out value="${n.message}"/>
                            </p>

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