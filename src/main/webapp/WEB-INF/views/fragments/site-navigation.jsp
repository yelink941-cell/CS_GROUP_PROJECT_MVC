  <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .nav-inner {
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 100%;
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
    }
    
    .nav-right-zone {
        display: flex;
        align-items: center;
        gap: 20px;
    }

    /* 🔎 Search Form Layout */
    .nav-search-form {
        display: flex;
        align-items: center;
        width: 260px;
        margin: 0;
    }
    .nav-search-input {
        width: 100%;
        padding: 6px 14px;
        border: 1px solid #334155;
        background-color: #1e293b;
        color: #ffffff;
        border-top-left-radius: 20px;
        border-bottom-left-radius: 20px;
        outline: none;
        font-size: 13px;
        transition: all 0.2s;
    }
    .nav-search-input:focus {
        border-color: #38bdf8;
        background-color: #0f172a;
    }
    .nav-search-button {
        padding: 6px 16px;
        background-color: #0f766e;
        color: white;
        border: none;
        border-top-right-radius: 20px;
        border-bottom-right-radius: 20px;
        cursor: pointer;
        font-weight: 600;
        font-size: 13px;
        transition: background-color 0.2s;
    }
    .nav-search-button:hover {
        background-color: #0d615a;
    }

    /* 🕒 Inline History Button Style */
    .nav-history-btn {
        text-decoration: none;
        color: #38bdf8; /* Bright tone to look distinct in the dark bar */
        font-weight: 600;
        padding: 6px 14px;
        background: #1e293b;
        border: 1px solid #334155;
        border-radius: 20px;
        font-size: 13px;
        transition: all 0.2s;
        white-space: nowrap;
    }
    .nav-history-btn:hover {
        background: #334155;
        color: #ffffff;
    }

    /* 📁 🌟 Elegant Style for Collections Button */
    .nav-collections-btn {
        text-decoration: none;
        color: #10b981; /* Emerald green accent for a premium modern look */
        font-weight: 600;
        padding: 6px 14px;
        background: #1e293b;
        border: 1px solid #065f46;
        border-radius: 20px;
        font-size: 13px;
        transition: all 0.2s;
        white-space: nowrap;
        display: inline-flex;
        align-items: center;
        gap: 6px;
    }
    .nav-collections-btn:hover {
        background: #065f46;
        color: #ffffff;
        border-color: #10b981;
    }
</style>

<nav class="site-nav">
    <div class="nav-inner">
        <a class="brand" href="${pageContext.request.contextPath}/">CheatSheet Hub</a>

        <div class="nav-right-zone">
            
            <!-- 🕒 History Button (User ရှိမှ ပြမည်) -->
            <c:if test="${not empty sessionScope.currentUser}">
                <a href="${pageContext.request.contextPath}/history" class="nav-history-btn">🕒 History</a>
            </c:if>
            
            <!-- 📁 🌟 ပြင်ဆင်ပြီးသား အမိုက်စား My Collections Button (User Login ဝင်ထားမှ ပေါ်မည်) -->
            <c:if test="${not empty sessionScope.userId}">
                <a href="${pageContext.request.contextPath}/user/collections" class="nav-collections-btn">
                    📁 My Collections
                </a>
            </c:if>
            
            <!-- 🔎 Search Form -->
            <form action="${pageContext.request.contextPath}/doSearch" method="post" class="nav-search-form">
                <input type="text" name="keyword" value="<c:out value='${searchedKeyword}'/>" class="nav-search-input" placeholder="Search categories or users..." required>
                <button type="submit" class="nav-search-button">Search</button>
            </form>

            <!-- 🔗 Role Based Links -->
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
                    <div class="nav-item nav-dropdown">
                        <a class="nav-link" href="${pageContext.request.contextPath}/posts/public">View Posts</a>
                        <div class="nav-dropdown-menu">
                            <a href="${pageContext.request.contextPath}/posts/public">&#128196; All Public Posts</a>
                            <a href="${pageContext.request.contextPath}/posts/categories">&#128218; Cheat Sheets by Category</a>
                            <a href="${pageContext.request.contextPath}/posts/tags">&#127991; Cheat Sheets by Tag</a>
                            <a href="${pageContext.request.contextPath}/posts/popular">&#11088; Popular Cheat Sheets</a>
                            <a href="${pageContext.request.contextPath}/posts/trending">&#128293; Trending Cheat Sheets</a>
                            <a href="${pageContext.request.contextPath}/posts/new">&#127381; New Cheat Sheets</a>
                        </div>
                    </div>
                    <a class="nav-link" href="${pageContext.request.contextPath}/user/posts">My Posts</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/user/posts/new">Create Post</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/user/posts/bookmark">My Bookmarks</a>
                    <a class="nav-link nav-link-primary" href="${pageContext.request.contextPath}/logout">Logout</a>
                </c:when>

                <c:otherwise>
                    <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                    <div class="nav-item nav-dropdown">
                        <a class="nav-link" href="${pageContext.request.contextPath}/posts/public">View Posts</a>
                        <div class="nav-dropdown-menu">
                            <a href="${pageContext.request.contextPath}/posts/public">&#128196; All Public Posts</a>
                            <a href="${pageContext.request.contextPath}/posts/categories">&#128218; Cheat Sheets by Category</a>
                            <a href="${pageContext.request.contextPath}/posts/tags">&#127991; Cheat Sheets by Tag</a>
                            <a href="${pageContext.request.contextPath}/posts/popular">&#11088; Popular Cheat Sheets</a>
                            <a href="${pageContext.request.contextPath}/posts/trending">&#128293; Trending Cheat Sheets</a>
                            <a href="${pageContext.request.contextPath}/posts/new">&#127381; New Cheat Sheets</a>
                        </div>
                    </div>
                    <a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a>
                    <a class="nav-link nav-link-primary" href="${pageContext.request.contextPath}/register">Register</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>