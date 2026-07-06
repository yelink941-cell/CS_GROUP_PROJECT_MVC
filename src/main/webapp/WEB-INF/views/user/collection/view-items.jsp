<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${folder.name} - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
    
    <style>
        /* ============================================
           STYLE FROM POPULAR.JSP
           ============================================ */
        
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
        .folder-header {
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
            max-width: 800px;
            margin: 0 auto;
        }
        
        .folder-header .header-icon {
            font-size: 48px;
            display: block;
            margin-bottom: 12px;
        }
        
        .folder-header .header-badge {
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 3px;
            opacity: 0.7;
            display: block;
            margin-bottom: 8px;
            color: #c7d2fe;
        }
        
        .folder-header h1 {
            font-size: 40px;
            font-weight: 800;
            margin: 0 0 12px 0;
            color: #ffffff;
            letter-spacing: -0.5px;
        }
        
        .folder-header h1 span {
            background: rgba(255, 255, 255, 0.12);
            padding: 4px 16px;
            border-radius: 12px;
            display: inline-block;
            letter-spacing: 0;
            text-transform: none;
            font-size: 40px;
        }
        
        .folder-header p {
            font-size: 18px;
            opacity: 0.85;
            margin: 0;
            color: #c7d2fe;
            line-height: 1.6;
        }
        
        .folder-header .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #c7d2fe;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 16px;
            padding: 8px 16px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.10);
            transition: all 0.3s ease;
        }
        
        .folder-header .back-link:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.15);
            transform: translateX(-4px);
        }
        
        .folder-header .folder-meta {
            display: flex;
            gap: 16px;
            justify-content: center;
            margin-top: 16px;
            flex-wrap: wrap;
        }
        
        .folder-header .folder-meta .meta-item {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(255, 255, 255, 0.08);
            padding: 6px 18px;
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
            padding: 6px 18px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            background: rgba(255, 255, 255, 0.08);
            color: #c7d2fe;
        }
        
        .public-badge.public {
            background: rgba(34, 197, 94, 0.20);
            color: #86efac;
        }
        
        .public-badge.private {
            background: rgba(148, 163, 184, 0.20);
            color: #94a3b8;
        }
        
        /* ===== PAGE CONTAINER ===== */
        .page-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px 60px;
        }
        
        /* ===== ITEMS GRID (SAME AS POPULAR GRID) ===== */
        .items-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 24px;
            margin-top: 35px;
        }
        
        /* ===== POST CARD (SAME AS POPULAR CARD) ===== */
        .cheat-sheet-card-wrapper {
            position: relative;
            height: 100%;
        }
        
        .cheat-sheet-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 24px;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            border: 1px solid #e8edf4;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            text-decoration: none;
            color: inherit;
            height: 100%;
            padding-right: 60px;
            min-height: 180px;
        }
        
        .cheat-sheet-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 32px -8px rgba(0, 0, 0, 0.12);
            border-color: #c7d2fe;
        }
        
        /* ===== CATEGORY LABEL (SAME AS POPULAR) ===== */
        .cheat-sheet-card .card-top {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 10px;
            flex-wrap: wrap;
        }
        
        .cheat-sheet-card .category-tag {
            background: #dbeafe;
            color: #1d4ed8;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .cheat-sheet-card .post-status {
            font-size: 11px;
            font-weight: 600;
            padding: 4px 12px;
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
            font-size: 20px;
            font-weight: 700;
            color: #1e293b;
            text-decoration: none;
            margin: 0 0 8px 0;
            line-height: 1.3;
            transition: color 0.2s;
        }
        
        .cheat-sheet-title:hover {
            color: #4f46e5;
        }
        
        .cheat-sheet-excerpt {
            font-size: 14px;
            color: #64748b;
            line-height: 1.6;
            margin: 0 0 16px 0;
            flex: 1;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .cheat-sheet-meta {
            display: flex;
            align-items: center;
            gap: 14px;
            font-size: 13px;
            color: #94a3b8;
            padding-top: 14px;
            border-top: 1px solid #f1f5f9;
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
            top: 16px;
            right: 14px;
            background: none;
            border: none;
            font-size: 18px;
            cursor: pointer;
            color: #94a3b8;
            transition: all 0.25s ease;
            text-decoration: none;
            z-index: 10;
            padding: 6px 10px;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(4px);
        }
        
        .btn-delete-item:hover {
            color: #ef4444;
            background: #fee2e2;
            transform: scale(1.15);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.20);
        }
        
        /* ===== EMPTY STATE (SAME AS POPULAR) ===== */
        .empty-state {
            background: #ffffff;
            border-radius: 16px;
            padding: 60px 30px;
            text-align: center;
            border: 2px dashed #e2e8f0;
            grid-column: 1 / -1;
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
            .folder-header {
                padding: 40px 16px 35px;
            }
            
            .folder-header h1 {
                font-size: 28px;
            }
            
            .folder-header h1 span {
                font-size: 28px;
            }
            
            .folder-header p {
                font-size: 15px;
            }
            
            .page-container {
                padding: 0 14px 40px;
            }
            
            .items-grid {
                grid-template-columns: 1fr;
                gap: 18px;
            }
            
            .cheat-sheet-card {
                padding: 20px;
                padding-right: 50px;
            }
            
            .cheat-sheet-title {
                font-size: 17px;
            }
            
            .folder-header .folder-meta {
                gap: 10px;
            }
        }
        
        @media (max-width: 480px) {
            .folder-header {
                padding: 30px 14px 25px;
            }
            
            .folder-header h1 {
                font-size: 22px;
            }
            
            .folder-header h1 span {
                font-size: 22px;
            }
            
            .folder-header .header-icon {
                font-size: 32px;
            }
            
            .folder-header p {
                font-size: 13px;
            }
            
            .cheat-sheet-card {
                padding: 16px;
                padding-right: 44px;
            }
            
            .cheat-sheet-card .card-top {
                flex-wrap: wrap;
            }
            
            .cheat-sheet-meta {
                flex-wrap: wrap;
                gap: 8px;
            }
            
            .btn-delete-item {
                top: 12px;
                right: 10px;
                font-size: 16px;
            }
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main>
        
        <!-- ===== HERO - FULL WIDTH (SAME AS POPULAR.JSP) ===== -->
        <header class="folder-header">
            <div class="header-content">
                <a href="${pageContext.request.contextPath}/user/collections" class="back-link">
                    ⬅ Back to Folders
                </a>
                
                <span class="header-icon">📁</span>
                <span class="header-badge">Collection Folder</span>
                <h1><span><c:out value="${folder.name}"/></span></h1>
                <p><c:out value="${folder.description}"/></p>
                
                <div class="folder-meta">
                    <span class="meta-item">
                        📄 <span class="count">${savedPosts != null ? savedPosts.size() : 0}</span> items
                    </span>
                    <span class="public-badge ${folder.isPublic ? 'public' : 'private'}">
                        ${folder.isPublic ? '🌍 Public' : '🔒 Private'}
                    </span>
                    <span class="meta-item">
                        📅 Created: <span class="count">
                            ${folder.createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))}
                        </span>
                    </span>
                </div>
            </div>
        </header>

        <div class="page-container">
            
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
                                        <span class="category-tag">${post.category.name}</span>
                                        <span class="post-status ${post.status == 'PUBLISHED' ? 'published' : 'pending'}">
                                            ${post.status}
                                        </span>
                                    </div>
                                    <h3 class="cheat-sheet-title"><c:out value="${post.title}"/></h3>
                                    <p class="cheat-sheet-excerpt">
                                        <c:choose>
                                            <c:when test="${not empty post.excerpt}">
                                                <c:out value="${post.excerpt}"/>
                                            </c:when>
                                            <c:otherwise>
                                                A concise guide designed for quick reference.
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    <div class="cheat-sheet-meta">
                                        <span class="author">by <c:out value="${post.author.username}"/></span>
                                        <span class="views">${empty post.viewCount ? 0 : post.viewCount}</span>
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
        </div>
    </main>
<!-- ===== FOOTER - DARK THEME (SAME AS POPULAR.JSP STYLE) ===== -->
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
        // Auto-hide flash messages if any
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