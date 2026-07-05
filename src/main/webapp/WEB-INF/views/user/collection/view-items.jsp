<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${folder.name} - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    
    <style>
        /* ============================================
           FOLDER DETAIL - SAME COLORS AS CATEGORY
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
        .folder-header {
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
        
        .folder-header::before {
            content: '';
            position: absolute;
            top: -60%;
            right: -10%;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50%;
        }
        
        .folder-header::after {
            content: '';
            position: absolute;
            bottom: -50%;
            left: -5%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.04);
            border-radius: 50%;
        }
        
        .folder-header .header-content {
            position: relative;
            z-index: 1;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .folder-header .back-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #a5b4fc;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            transition: color 0.2s;
            margin-bottom: 12px;
        }
        
        .folder-header .back-link:hover {
            color: #ffffff;
        }
        
        .folder-header span {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: #a5b4fc;
            font-weight: 600;
            display: block;
            margin-bottom: 4px;
        }
        
        .folder-header h1 {
            font-size: 32px;
            font-weight: 800;
            color: #ffffff;
            margin: 0 0 6px 0;
        }
        
        .folder-header h1 .folder-icon {
            background: rgba(255, 255, 255, 0.12);
            padding: 2px 12px;
            border-radius: 8px;
        }
        
        .folder-header .folder-description {
            font-size: 15px;
            color: #c7d2fe;
            margin: 0;
        }
        
        .folder-header .folder-meta {
            display: flex;
            gap: 20px;
            margin-top: 12px;
            flex-wrap: wrap;
        }
        
        .folder-header .folder-meta .meta-item {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(255, 255, 255, 0.1);
            padding: 4px 16px;
            border-radius: 20px;
            font-size: 13px;
            color: #c7d2fe;
        }
        
        .folder-header .folder-meta .meta-item .count {
            color: #ffffff;
            font-weight: 700;
        }
        
        .public-badge {
            display: inline-block;
            padding: 4px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            background: rgba(255, 255, 255, 0.15);
            color: #ffffff;
        }
        
        .public-badge.public {
            background: rgba(34, 197, 94, 0.25);
            color: #86efac;
        }
        
        .public-badge.private {
            background: rgba(148, 163, 184, 0.25);
            color: #94a3b8;
        }
        
        /* ===== ITEMS GRID ===== */
        .items-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 24px;
            margin-top: 10px;
        }
        
        /* ===== POST CARD ===== */
        .cheat-sheet-card-wrapper {
            position: relative;
        }
        
        .cheat-sheet-card {
            background: #ffffff;
            padding: 24px 24px 20px;
            border-radius: 16px;
            border: 1px solid #e8edf4;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            text-decoration: none;
            color: inherit;
            display: block;
            transition: all 0.3s ease;
            padding-right: 4rem;
            min-height: 120px;
        }
        
        .cheat-sheet-card:hover {
            transform: translateY(-4px);
            border-color: #c7d2fe;
            box-shadow: 0 12px 32px -8px rgba(0, 0, 0, 0.10);
        }
        
        .cheat-sheet-card .card-top {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 6px;
        }
        
        .cheat-sheet-card .category-tag {
            background: #dbeafe;
            color: #1d4ed8;
            padding: 2px 12px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .cheat-sheet-card .post-status {
            font-size: 11px;
            font-weight: 600;
            padding: 2px 10px;
            border-radius: 12px;
        }
        
        .cheat-sheet-card .post-status.published {
            background: #dcfce7;
            color: #16a34a;
        }
        
        .cheat-sheet-card .post-status.pending {
            background: #fef3c7;
            color: #92400e;
        }
        
        .cheat-sheet-title {
            color: #1e293b;
            margin: 0 0 6px 0;
            font-size: 18px;
            font-weight: 700;
        }
        
        .cheat-sheet-title:hover {
            color: #4f46e5;
        }
        
        .cheat-sheet-excerpt {
            font-size: 14px;
            color: #64748b;
            margin: 0 0 10px 0;
            line-height: 1.5;
        }
        
        .cheat-sheet-meta {
            display: flex;
            align-items: center;
            gap: 14px;
            font-size: 13px;
            color: #94a3b8;
        }
        
        .cheat-sheet-meta .author {
            color: #1e293b;
            font-weight: 600;
        }
        
        .cheat-sheet-meta .views::before {
            content: "👁️ ";
        }
        
        /* ===== DELETE BUTTON ===== */
        .btn-delete-item {
            position: absolute;
            top: 18px;
            right: 16px;
            background: none;
            border: none;
            font-size: 18px;
            cursor: pointer;
            color: #94a3b8;
            transition: all 0.25s ease;
            text-decoration: none;
            z-index: 10;
            padding: 4px 8px;
            border-radius: 8px;
        }
        
        .btn-delete-item:hover {
            color: #ef4444;
            background: #fee2e2;
            transform: scale(1.1);
        }
        
        /* ===== EMPTY STATE ===== */
        .empty-state {
            grid-column: 1 / -1;
            background: #ffffff;
            border-radius: 16px;
            padding: 60px 30px;
            text-align: center;
            border: 2px dashed #e2e8f0;
        }
        
        .empty-state .icon {
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
            .page-container {
                padding: 0 14px 40px;
            }
            
            .folder-header {
                padding: 30px 16px 25px;
            }
            
            .folder-header h1 {
                font-size: 24px;
            }
            
            .items-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }
            
            .cheat-sheet-card {
                padding: 18px;
                padding-right: 3.5rem;
            }
            
            .cheat-sheet-title {
                font-size: 16px;
            }
            
            .folder-header .folder-meta {
                gap: 10px;
            }
        }
        
        @media (max-width: 480px) {
            .folder-header h1 {
                font-size: 20px;
            }
            
            .folder-header .folder-description {
                font-size: 13px;
            }
            
            .cheat-sheet-card .card-top {
                flex-wrap: wrap;
            }
            
            .cheat-sheet-meta {
                flex-wrap: wrap;
                gap: 8px;
            }
            
            .btn-delete-item {
                top: 14px;
                right: 12px;
                font-size: 16px;
            }
        }
    </style>
</head>
<body class="public-list-page">

    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container">
        
        <!-- ===== HEADER - FULL WIDTH ===== -->
        <header class="folder-header">
            <div class="header-content">
                <a href="${pageContext.request.contextPath}/user/collections" class="back-link">
                    ⬅ Back to Folders
                </a>
                
                <span>📁 Collection Folder</span>
                <h1><span class="folder-icon">📂</span> <c:out value="${folder.name}"/></h1>
                <p class="folder-description"><c:out value="${folder.description}"/></p>
                
                <div class="folder-meta">
                    <span class="meta-item">
                        📄 <span class="count"><c:out value="${savedPosts != null ? savedPosts.size() : 0}" /></span> items
                    </span>
                    <span class="public-badge ${folder.isPublic ? 'public' : 'private'}">
                        ${folder.isPublic ? '🌍 Public' : '🔒 Private'}
                    </span>
                    <span class="meta-item">
                        📅 Created: <span class="count">
                            <fmt:formatDate value="${folder.createdAt}" pattern="yyyy-MM-dd" />
                        </span>
                    </span>
                </div>
            </div>
        </header>

        <!-- ===== ITEMS GRID ===== -->
        <section class="items-grid">
            <c:choose>
                <c:when test="${empty savedPosts}">
                    <div class="empty-state">
                        <span class="icon">📁</span>
                        <h2>No cheat sheets yet</h2>
                        <p>No cheat sheets saved in this folder yet. Start adding your favorites!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="post" items="${savedPosts}">
                        <div class="cheat-sheet-card-wrapper">
                            
                            <!-- Post Card -->
                            <a href="${pageContext.request.contextPath}/posts/${post.slug}" class="cheat-sheet-card">
                                <div class="card-top">
                                    <span class="category-tag">📁 <c:out value="${post.category.name}" /></span>
                                    <span class="post-status ${post.status == 'PUBLISHED' ? 'published' : 'pending'}">
                                        <c:out value="${post.status}" />
                                    </span>
                                </div>
                                <h3 class="cheat-sheet-title">📄 <c:out value="${post.title}" /></h3>
                                <p class="cheat-sheet-excerpt">
                                    <c:choose>
                                        <c:when test="${not empty post.excerpt}">
                                            <c:out value="${post.excerpt}" />
                                        </c:when>
                                        <c:otherwise>
                                            A concise guide designed for quick reference.
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <div class="cheat-sheet-meta">
                                    <span class="author">by <c:out value="${post.author.username}" /></span>
                                    <span class="views"><c:out value="${empty post.viewCount ? 0 : post.viewCount}" /></span>
                                </div>
                            </a>
                            
                            <!-- Delete Button -->
                            <a href="${pageContext.request.contextPath}/user/collections/${folder.id}/remove-post/${post.id}" 
                               class="btn-delete-item" 
                               onclick="return confirm('Are you sure you want to remove this item from this folder?');"
                               title="Remove from folder">
                                🗑️
                            </a>
                            
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </section>
    </main>

</body>
</html>