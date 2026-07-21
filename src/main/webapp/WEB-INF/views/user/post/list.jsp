<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Posts - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-list.css?v=9">
     <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
    
    <style>
        /* ============================================
           MY POSTS PAGE - FULL MODERN STYLE
           ============================================ */
        
        * {
            box-sizing: border-box;
        }
        
        body {
            background: #f0f4f8;
        }
        
        .page-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px 60px;
        }
        
        /* ===== HEADER - FULL WIDTH ===== */
        .my-posts-header {
            width: 100vw;
            margin-left: calc(-50vw + 50%);
            padding: 40px 20px 35px;
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 40%, #4f46e5 100%);
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 30px rgba(79, 70, 229, 0.25);
            margin-bottom: 30px;
        }
        
        .my-posts-header::before {
            content: '';
            position: absolute;
            top: -60%;
            right: -10%;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50%;
        }
        
        .my-posts-header::after {
            content: '';
            position: absolute;
            bottom: -50%;
            left: -5%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.04);
            border-radius: 50%;
        }
        
        .my-posts-header .header-content {
            position: relative;
            z-index: 1;
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }
        
        .my-posts-header .header-left span {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: #a5b4fc;
            font-weight: 600;
            display: block;
            margin-bottom: 4px;
        }
        
        .my-posts-header .header-left h1 {
            font-size: 32px;
            font-weight: 800;
            color: #ffffff;
            margin: 0 0 4px 0;
        }
        
        .my-posts-header .header-left h1 .emoji {
            background: rgba(255, 255, 255, 0.12);
            padding: 2px 10px;
            border-radius: 8px;
            font-size: 24px;
        }
        
        .my-posts-header .header-left p {
            font-size: 15px;
            color: #c7d2fe;
            margin: 0;
        }
        
        .my-posts-header .header-right {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        
        .my-posts-header .header-right .total-badge {
            background: rgba(255, 255, 255, 0.12);
            padding: 6px 18px;
            border-radius: 20px;
            font-size: 14px;
            color: #c7d2fe;
            border: 1px solid rgba(255, 255, 255, 0.08);
        }
        
        .my-posts-header .header-right .total-badge strong {
            color: #ffffff;
            font-size: 18px;
        }
        
        .btn-create {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 28px;
            background: #ffffff;
            color: #4f46e5;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.25s ease;
            cursor: pointer;
        }
        
        .btn-create:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        }
        
        /* ===== POST GRID ===== */
        .my-posts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 24px;
        }
        
        /* ===== POST CARD ===== */
        .my-post-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 0;
            border: 1px solid #e8edf4;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        
        .my-post-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 16px 40px -8px rgba(0, 0, 0, 0.12);
            border-color: #c7d2fe;
        }
        
        /* Status Top Bar */
        .my-post-card .status-bar {
            height: 4px;
            flex-shrink: 0;
        }
        
        .my-post-card.is-published .status-bar { background: #22c55e; }
        .my-post-card.is-pending .status-bar { background: #f59e0b; }
        .my-post-card.is-rejected .status-bar { background: #ef4444; }
        .my-post-card.is-draft .status-bar { background: #94a3b8; }
        
        .my-post-card .card-body {
            padding: 20px 22px 18px;
            display: flex;
            flex-direction: column;
            flex: 1;
        }
        
        .my-post-card-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 10px;
            gap: 8px;
            flex-wrap: wrap;
        }
        
        .my-category {
            background: #dbeafe;
            color: #1d4ed8;
            padding: 3px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            white-space: nowrap;
        }
        
        .badge-row {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }
        
        .visibility-badge {
            padding: 2px 12px;
            border-radius: 12px;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        
        .visibility-public {
            background: #dcfce7;
            color: #16a34a;
        }
        
        .visibility-private {
            background: #f1f5f9;
            color: #475569;
        }
        
        .status-badge {
            padding: 2px 12px;
            border-radius: 12px;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        
        .status-published {
            background: #dcfce7;
            color: #16a34a;
        }
        
        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }
        
        .status-rejected {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .status-draft {
            background: #f1f5f9;
            color: #475569;
        }
        
        .my-post-card h2 {
            font-size: 19px;
            font-weight: 700;
            color: #1e293b;
            margin: 0 0 2px 0;
            line-height: 1.3;
        }
        
        .my-post-card h2 a {
            color: #1e293b;
            text-decoration: none;
            transition: color 0.2s;
        }
        
        .my-post-card h2 a:hover {
            color: #4f46e5;
        }
        
        .my-post-slug {
            font-size: 13px;
            color: #94a3b8;
            margin: 0 0 12px 0;
            font-family: 'Courier New', monospace;
        }
        
        .my-post-meta-row {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 10px;
            flex-wrap: wrap;
        }
        
        .my-view-summary {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            color: #64748b;
            text-decoration: none;
            padding: 4px 0;
        }
        
        .my-view-summary:hover {
            color: #4f46e5;
        }
        
        .my-view-summary strong {
            color: #1e293b;
        }
        
        .my-post-date {
            font-size: 12px;
            color: #94a3b8;
        }
        
        .my-post-date::before {
            content: "📅 ";
        }
        
        .rejection-reason {
            font-size: 13px;
            color: #991b1b;
            background: #fee2e2;
            padding: 8px 12px;
            border-radius: 8px;
            margin: 6px 0 12px 0;
            border-left: 3px solid #ef4444;
        }
        
        /* ===== ACTIONS ===== */
        .my-post-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-top: 14px;
            padding-top: 14px;
            border-top: 1px solid #f1f5f9;
        }
        
        .my-action-link {
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
            background: #f1f5f9;
            color: #475569;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        
        .my-action-link:hover {
            background: #e2e8f0;
            color: #0f172a;
        }
        
        .my-action-link.primary {
            background: #dbeafe;
            color: #1d4ed8;
        }
        
        .my-action-link.primary:hover {
            background: #bfdbfe;
        }
        
        .my-action-link.danger {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .my-action-link.danger:hover {
            background: #fecaca;
        }
        
        .my-action-link .icon {
            font-size: 13px;
        }
        
        /* ===== EMPTY STATE ===== */
        .empty-state {
            background: #ffffff;
            border-radius: 16px;
            padding: 80px 30px;
            text-align: center;
            border: 2px dashed #e2e8f0;
            margin-top: 20px;
        }
        
        .empty-state .icon {
            font-size: 64px;
            display: block;
            margin-bottom: 16px;
        }
        
        .empty-state h2 {
            font-size: 24px;
            color: #1e293b;
            margin: 0 0 8px 0;
        }
        
        .empty-state p {
            color: #64748b;
            font-size: 16px;
            margin: 0 0 20px 0;
        }
        
        .empty-state .btn-create-empty {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 32px;
            background: #4f46e5;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.25s ease;
        }
        
        .empty-state .btn-create-empty:hover {
            background: #4338ca;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(79, 70, 229, 0.3);
        }
        
        /* ===== RESPONSIVE ===== */
        @media (max-width: 1024px) {
            .my-posts-grid {
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            }
        }
        
        @media (max-width: 768px) {
            .page-container {
                padding: 0 14px 40px;
            }
            
            .my-posts-header {
                padding: 30px 16px 25px;
            }
            
            .my-posts-header .header-content {
                flex-direction: column;
                align-items: stretch;
                gap: 12px;
            }
            
            .my-posts-header .header-left h1 {
                font-size: 24px;
            }
            
            .my-posts-header .header-right {
                justify-content: space-between;
            }
            
            .my-posts-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }
            
            .my-post-card .card-body {
                padding: 16px 18px;
            }
            
            .my-post-actions {
                gap: 4px;
            }
            
            .my-action-link {
                font-size: 11px;
                padding: 5px 10px;
            }
            
            .btn-create {
                padding: 8px 18px;
                font-size: 13px;
            }
        }
        
        @media (max-width: 480px) {
            .my-posts-header .header-left h1 {
                font-size: 20px;
            }
            
            .my-posts-header .header-left p {
                font-size: 13px;
            }
            
            .my-post-card h2 {
                font-size: 16px;
            }
            
            .my-post-meta-row {
                flex-direction: column;
                align-items: flex-start;
                gap: 4px;
            }
            
            .my-post-actions {
                flex-wrap: wrap;
            }
            
            .my-action-link {
                font-size: 10px;
                padding: 4px 8px;
            }
        }
    </style>
</head>
<body class="my-posts-page">

    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container my-posts-container">
        
        <!-- ===== HEADER - FULL WIDTH ===== -->
        <header class="my-posts-header">
            <div class="header-content">
                <div class="header-left">
                    <span>📂 Workspace</span>
                    <c:choose>
                        <c:when test="${activeTab == 'bookmarks'}">
                            <h1><span class="emoji">🔖</span> My Bookmarks</h1>
                            <p>Manage your saved and bookmarked cheat sheets.</p>
                        </c:when>
                        <c:otherwise>
                            <h1><span class="emoji">📄</span> My Posts</h1>
                            <p>Manage your drafts, submissions, published guides, and private notes.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="header-right">
                    <span class="total-badge">
                        📊 <strong><c:out value="${fn:length(posts)}" /></strong> total items
                    </span>
                    <c:if test="${activeTab != 'bookmarks'}">
                        <c:choose>
                            <c:when test="${dbUser.postBanned}">
                                <span class="btn-create" style="opacity: 0.6; cursor: not-allowed; background: #e2e8f0; color: #64748b;" title="Posting restricted">➕ Create Post</span>
                            </c:when>
                            <c:otherwise>
                                <a class="btn-create" href="${pageContext.request.contextPath}/user/posts/new">➕ Create Post</a>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                </div>
            </div>
        </header>

        <c:if test="${not empty errorMessage}">
            <div style="margin-bottom: 24px; font-weight: 600; font-size: 0.92rem; display: flex; align-items: center; gap: 10px; background-color: #fef2f2; border: 1px solid #fecaca; border-left: 4px solid #ef4444; color: #991b1b; padding: 14px 18px; border-radius: 10px; box-shadow: 0 4px 12px rgba(239, 68, 68, 0.1);">
                <span style="font-size: 1.1rem; color: #dc2626;">⚠️</span>
                <span><c:out value="${errorMessage}" /></span>
            </div>
        </c:if>

        <!-- ===== EMPTY STATE ===== -->
        <c:if test="${empty posts}">
            <section class="empty-state">
                <span class="icon">📄</span>
                <h2>No posts found</h2>
                <p>Create your first cheat sheet to start building your collection.</p>
                <c:if test="${activeTab != 'bookmarks'}">
                    <c:choose>
                        <c:when test="${dbUser.postBanned}">
                            <span class="btn-create-empty" style="opacity: 0.6; cursor: not-allowed; background: #e2e8f0; color: #64748b;" title="Posting restricted">➕ Create Your First Post</span>
                        </c:when>
                        <c:otherwise>
                            <a class="btn-create-empty" href="${pageContext.request.contextPath}/user/posts/new">➕ Create Your First Post</a>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </section>
        </c:if>

        <!-- ===== POST GRID ===== -->
        <c:if test="${not empty posts}">
            <section class="my-posts-grid" aria-label="My posts">
                <c:forEach var="post" items="${posts}">
                    <c:choose>
                        <c:when test="${post.status == 'PUBLISHED'}"><c:set var="statusClass" value="is-published" /></c:when>
                        <c:when test="${post.status == 'PENDING'}"><c:set var="statusClass" value="is-pending" /></c:when>
                        <c:when test="${post.status == 'REJECTED'}"><c:set var="statusClass" value="is-rejected" /></c:when>
                        <c:when test="${post.status == 'ARCHIVED'}"><c:set var="statusClass" value="is-draft" /></c:when>
                        <c:when test="${post.status == 'REMOVED'}"><c:set var="statusClass" value="is-rejected" /></c:when>
                        <c:otherwise><c:set var="statusClass" value="is-draft" /></c:otherwise>
                    </c:choose>

                    <article class="my-post-card ${statusClass}">
                        <!-- Status Bar -->
                        <div class="status-bar"></div>
                        
                        <div class="card-body">
                            <div class="my-post-card-top">
                                <span class="my-category">📁 <c:out value="${post.category.name}" /></span>
                                <div class="badge-row">
                                    <span class="visibility-badge ${post.visibility == 'PUBLIC' ? 'visibility-public' : 'visibility-private'}">
                                        ${post.visibility == 'PUBLIC' ? '🌍' : '🔒'} <c:out value="${post.visibility}" />
                                    </span>
                                    <span class="status-badge status-${fn:toLowerCase(post.status)}">
                                        <c:out value="${post.status}" />
                                    </span>
                                </div>
                            </div>

                            <h2>
                                <a href="${pageContext.request.contextPath}/posts/${post.slug}"><c:out value="${post.title}" /></a>
                            </h2>
                            <p class="my-post-slug">🔗 /<c:out value="${post.slug}" /></p>

                            <div class="my-post-meta-row">
                                <a class="my-view-summary" href="${pageContext.request.contextPath}/user/posts/${post.id}/views">
                                    <span>👁️</span>
                                    <strong><c:out value="${empty post.viewCount ? 0 : post.viewCount}" /></strong> Views
                                </a>
                                <span class="my-post-date"><c:out value="${post.createdAt}" /></span>
                            </div>

                            <c:if test="${post.status == 'REJECTED' && not empty post.rejectionReason}">
                                <p class="rejection-reason"><strong>⚠️ Reason:</strong> <c:out value="${post.rejectionReason}" /></p>
                            </c:if>

                            <c:if test="${post.status == 'REMOVED' && not empty post.removalReason}">
                                <p class="rejection-reason"><strong>Removal Reason:</strong> <c:out value="${post.removalReason}" /></p>
                            </c:if>

                            <div class="my-post-actions">
                                <a class="my-action-link primary" href="${pageContext.request.contextPath}/user/posts/${post.id}/contents">
                                    <span class="icon">📝</span> Sections
                                </a>
                               <%--  <a class="my-action-link" href="${pageContext.request.contextPath}/user/posts/${post.id}/files">
                                    <span class="icon">📎</span> Files
                                </a> --%>
                                <a class="my-action-link" href="${pageContext.request.contextPath}/posts/${post.slug}/download-pdf">
                                    <span class="icon">📄</span> PDF
                                </a>
                                <a class="my-action-link" href="${pageContext.request.contextPath}/user/posts/${post.id}/views">
                                    <span class="icon">👤</span> View Users
                                </a>
                                <a class="my-action-link" href="${pageContext.request.contextPath}/user/posts/edit/${post.id}">
                                    <span class="icon">✏️</span> Edit
                                </a>
                                <a class="my-action-link danger" href="${pageContext.request.contextPath}/user/posts/delete/${post.id}"
                                   onclick="return confirm('Delete this post?');">
                                    <span class="icon">🗑️</span> Delete
                                </a>
                            </div>
                        </div>
                    </article>
                </c:forEach>
            </section>
        </c:if>
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
</body>
</html>
