<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
   
    .site-nav {
        background-color: #0f172a;
        padding: 10px 0;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    }

    .nav-inner {
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 100%;
        max-width: 1300px; 
        margin: 0 auto;
        padding: 0 20px;
        flex-wrap: wrap; 
        gap: 15px;
    }
    
    .nav-right-zone {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        gap: 16px;
        flex-grow: 1;
        flex-wrap: wrap;
    }

    /* ============================================
       SEARCH BAR - ORIGINAL STYLE (WIDE)
       ============================================ */
    .nav-search-form {
        display: flex;
        align-items: center;
        width: 300px;
        margin: 0;
    }
    
    .nav-search-input {
        width: 100%;
        padding: 8px 16px;
        border: 1px solid #334155;
        background-color: #1e293b;
        color: #ffffff;
        border-top-left-radius: 20px;
        border-bottom-left-radius: 20px;
        outline: none;
        font-size: 14px;
        transition: border-color 0.2s;
    }
    
    .nav-search-input:focus {
        border-color: #38bdf8;
        background-color: #0f172a;
    }
    
    .nav-search-input::placeholder {
        color: #94a3b8;
    }
    
    .nav-search-button {
        padding: 8px 20px;
        background-color: #0f766e;
        color: white;
        border: none;
        border-top-right-radius: 20px;
        border-bottom-right-radius: 20px;
        cursor: pointer;
        font-weight: 600;
        font-size: 14px;
        transition: background-color 0.2s;
        white-space: nowrap;
    }
    
    .nav-search-button:hover {
        background-color: #0d9488;
    }

    .nav-notifications-btn, .nav-collections-btn {
        text-decoration: none;
        font-weight: 600;
        padding: 6px 14px;
        background: #1e293b;
        border-radius: 20px;
        font-size: 13px;
        display: inline-flex;
        align-items: center;
        white-space: nowrap;
    }
    .nav-collections-btn { color: #10b981; border: 1px solid #065f46; gap: 6px; }
    .nav-notifications-btn { color: #fbbf24; border: 1px solid #92400e; gap: 6px; position: relative; }
    .nav-notif-badge {
        background: #ef4444;
        color: white;
        font-size: 10px;
        font-weight: 700;
        min-width: 18px;
        height: 18px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 0 4px;
    }

    /* ============================================
       USER DROPDOWN
       ============================================ */
    .user-dropdown {
        position: relative;
        display: inline-block;
    }
    
    .user-dropdown-toggle {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 6px 16px 6px 14px;
        background: #1e293b;
        border: 1px solid #334155;
        border-radius: 20px;
        color: #e2e8f0;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s;
        text-decoration: none;
    }
    
    .user-dropdown-toggle:hover {
        background: #334155;
        border-color: #38bdf8;
    }
    
    .user-dropdown-toggle .avatar {
        width: 28px;
        height: 28px;
        border-radius: 50%;
        background: #38bdf8;
        color: #0f172a;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 12px;
        font-weight: 700;
    }
    
    .user-dropdown-toggle .arrow {
        font-size: 12px;
        color: #94a3b8;
        transition: transform 0.2s;
    }
    
    .user-dropdown-toggle .arrow.open {
        transform: rotate(180deg);
    }
    
    .user-dropdown-menu {
        position: absolute;
        top: calc(100% + 8px);
        right: 0;
        background: #1e293b;
        border: 1px solid #334155;
        border-radius: 12px;
        min-width: 220px;
        padding: 6px 0;
        display: none;
        z-index: 9999;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
    }
    
    .user-dropdown-menu.show {
        display: block;
    }
    
    .user-dropdown-menu .menu-item {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 10px 18px;
        color: #e2e8f0;
        text-decoration: none;
        font-size: 14px;
        font-weight: 500;
        transition: background 0.15s;
        border: none;
        background: none;
        width: 100%;
        cursor: pointer;
    }
    
    .user-dropdown-menu .menu-item:hover {
        background: #334155;
    }
    
    .user-dropdown-menu .menu-item .icon {
        font-size: 18px;
        width: 24px;
        text-align: center;
        flex-shrink: 0;
    }
    
    .user-dropdown-menu .menu-divider {
        height: 1px;
        background: #334155;
        margin: 4px 12px;
    }
    
    .user-dropdown-menu .menu-item.logout {
        color: #ef4444;
    }
    
    .user-dropdown-menu .menu-item.logout:hover {
        background: #450a0a;
    }

    .nav-links {
        display: flex;
        align-items: center;
        gap: 12px; 
    }

    .nav-link {
        color: #f8fafc;
        text-decoration: none;
        font-size: 14px;
        font-weight: 500;
        white-space: nowrap;
        transition: color 0.2s;
    }
    .nav-link:hover {
        color: #38bdf8;
    }

    .nav-link-primary {
        background-color: #2563eb;
        padding: 6px 16px;
        border-radius: 8px;
        color: white !important;
        font-weight: 600;
    }
    .nav-link-primary:hover {
        background-color: #1d4ed8;
    }

    .nav-dropdown {
        position: relative;
        align-self: stretch;
        display: flex;
        align-items: center;
    }

    .nav-dropdown-menu {
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        z-index: 9999;
        min-width: 280px;
        padding: 8px 0;
        overflow: hidden;
        border: 1px solid #e5e7eb;
        border-radius: 10px;
        background: #ffffff;
        box-shadow: 0 18px 42px rgba(15, 23, 42, 0.2);
    }

    .nav-dropdown-menu a {
        display: block;
        padding: 11px 18px;
        color: #1e293b;
        background: #ffffff;
        text-decoration: none;
        font-size: 0.92rem;
        font-weight: 500;
        line-height: 1.4;
        white-space: nowrap;
        transition: color 0.15s ease, background 0.15s ease;
    }

    .nav-dropdown-menu a:hover {
        color: #0f172a;
        background: #f1f5f9;
    }

    .nav-dropdown-menu a::before {
        content: "→ ";
        opacity: 0.5;
    }

    .nav-dropdown:hover .nav-dropdown-menu,
    .nav-dropdown:focus-within .nav-dropdown-menu {
        display: block;
    }

    @media (max-width: 768px) {
        .nav-search-form {
            width: 100%;
        }
        
        .nav-inner {
            flex-direction: column;
            align-items: stretch;
        }
        
        .nav-right-zone {
            flex-direction: column;
            align-items: stretch;
        }
        
        .nav-links {
            flex-wrap: wrap;
            justify-content: center;
        }
        
        .user-dropdown-menu {
            right: auto;
            left: 0;
        }
    }
</style>

<nav class="site-nav">
    <div class="nav-inner">
        <a class="brand" href="${pageContext.request.contextPath}/">CheatSheet Hub</a>

        <div class="nav-right-zone">
            
            <c:if test="${not empty sessionScope.currentUser}">
                <a href="${pageContext.request.contextPath}/notifications" class="nav-notifications-btn">
                    🔔 Notifications
                    <c:if test="${unreadNotificationCount > 0}">
                        <span class="nav-notif-badge">${unreadNotificationCount}</span>
                    </c:if>
                </a>
            </c:if>
            
            <c:if test="${not empty sessionScope.userId}">
                <a href="${pageContext.request.contextPath}/user/collections" class="nav-collections-btn">
                    📁 My Collections
                </a>
            </c:if>
            
            <!-- ✅ Search Bar - Original Style (Wide) -->
            <form action="${pageContext.request.contextPath}/doSearch" method="post" class="nav-search-form">
                <input type="text" name="keyword" value="<c:out value='${searchedKeyword}'/>" 
                       class="nav-search-input" placeholder="Search categories, users, posts..." required>
                <button type="submit" class="nav-search-button">Search</button>
            </form>

            <div class="nav-links">
                <c:choose>
                    <c:when test="${sessionScope.role == 'ADMIN'}">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin-dashboard">Dashboard</a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/categories">Categories</a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/tags">Tags</a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/posts/pending">Pending Posts</a>
                        <a class="nav-link nav-link-primary" href="${pageContext.request.contextPath}/logout">Logout</a>
                    </c:when>

                    <c:when test="${sessionScope.role == 'USER'}">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                        
                        <!-- View Posts Dropdown -->
                        <div class="nav-dropdown">
                            <a class="nav-link" href="${pageContext.request.contextPath}/posts/public">View Posts</a>
                            <div class="nav-dropdown-menu">
                                <a href="${pageContext.request.contextPath}/posts/public">📄 All Public Posts</a>
                                <a href="${pageContext.request.contextPath}/posts/categories">📁 Cheat Sheets by Category</a>
                                <a href="${pageContext.request.contextPath}/posts/tags">🏷️ Cheat Sheets by Tag</a>
                                <a href="${pageContext.request.contextPath}/posts/popular">⭐ Popular Cheat Sheets</a>
                                <a href="${pageContext.request.contextPath}/posts/trending">🔥 Trending Cheat Sheets</a>
                                <a href="${pageContext.request.contextPath}/posts/new">🆕 New Cheat Sheets</a>
                            </div>
                        </div>
                        
                        <!-- User Dropdown -->
                        <div class="user-dropdown">
                            <button class="user-dropdown-toggle" id="userDropdownToggle" onclick="toggleUserDropdown()">
                                <span class="avatar">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.currentUser.username}">
                                            ${sessionScope.currentUser.username.charAt(0)}
                                        </c:when>
                                        <c:otherwise>U</c:otherwise>
                                    </c:choose>
                                </span>
                                <span>My Account</span>
                                <span class="arrow" id="dropdownArrow">▼</span>
                            </button>
                            
                            <!-- ✅ My Collections ကို ဒီကနေဖယ်ပါ -->
                            <div class="user-dropdown-menu" id="userDropdownMenu">
                                <a href="${pageContext.request.contextPath}/user/posts" class="menu-item">
                                    <span class="icon">📄</span> My Posts
                                </a>
                                <a href="${pageContext.request.contextPath}/user/posts/new" class="menu-item">
                                    <span class="icon">✏️</span> Create Post
                                </a>
                                <a href="${pageContext.request.contextPath}/user/posts/bookmark" class="menu-item">
                                    <span class="icon">🔖</span> My Bookmarks
                                </a>
                                <!-- ❌ My Collections ကိုဖယ်ပါ (အပြင်မှာပါနေလို့) -->
                                <div class="menu-divider"></div>
                                <a href="${pageContext.request.contextPath}/profile" class="menu-item">
                                    <span class="icon">👤</span> My Profile
                                </a>
                                <a href="${pageContext.request.contextPath}/settings" class="menu-item">
                                    <span class="icon">⚙️</span> Settings
                                </a>
                                <div class="menu-divider"></div>
                                <a href="${pageContext.request.contextPath}/logout" class="menu-item logout">
                                    <span class="icon">🚪</span> Logout
                                </a>
                            </div>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                        <div class="nav-dropdown">
                            <a class="nav-link" href="${pageContext.request.contextPath}/posts/public">View Posts</a>
                            <div class="nav-dropdown-menu">
                                <a href="${pageContext.request.contextPath}/posts/public">📄 All Public Posts</a>
                                <a href="${pageContext.request.contextPath}/posts/categories">📁 Cheat Sheets by Category</a>
                                <a href="${pageContext.request.contextPath}/posts/tags">🏷️ Cheat Sheets by Tag</a>
                                <a href="${pageContext.request.contextPath}/posts/popular">⭐ Popular Cheat Sheets</a>
                                <a href="${pageContext.request.contextPath}/posts/trending">🔥 Trending Cheat Sheets</a>
                                <a href="${pageContext.request.contextPath}/posts/new">🆕 New Cheat Sheets</a>
                            </div>
                        </div>
                        <a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a>
                        <a class="nav-link nav-link-primary" href="${pageContext.request.contextPath}/register">Register</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<script>
    // ============================================
    // USER DROPDOWN TOGGLE
    // ============================================
    function toggleUserDropdown() {
        var menu = document.getElementById('userDropdownMenu');
        var arrow = document.getElementById('dropdownArrow');
        if (menu) {
            menu.classList.toggle('show');
            if (arrow) {
                arrow.classList.toggle('open');
            }
        }
    }

    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        var dropdown = document.querySelector('.user-dropdown');
        if (dropdown && !dropdown.contains(e.target)) {
            var menu = document.getElementById('userDropdownMenu');
            var arrow = document.getElementById('dropdownArrow');
            if (menu) {
                menu.classList.remove('show');
            }
            if (arrow) {
                arrow.classList.remove('open');
            }
        }
    });

    // Close dropdown on Escape
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            var menu = document.getElementById('userDropdownMenu');
            var arrow = document.getElementById('dropdownArrow');
            if (menu) {
                menu.classList.remove('show');
            }
            if (arrow) {
                arrow.classList.remove('open');
            }
        }
    });
</script>