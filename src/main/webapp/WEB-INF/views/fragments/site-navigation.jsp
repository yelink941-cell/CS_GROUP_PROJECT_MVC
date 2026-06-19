<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="site-nav">
    <div class="nav-inner">
        <a class="brand" href="${pageContext.request.contextPath}/">CheatSheet Hub</a>

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
                    <a class="nav-link" href="${pageContext.request.contextPath}/">View Posts</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/user/posts">My Posts</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/user/posts/new">Create Post</a>
                    <a class="nav-link nav-link-primary" href="${pageContext.request.contextPath}/logout">Logout</a>
                </c:when>
                <c:otherwise>
                    <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/">View Posts</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a>
                    <a class="nav-link nav-link-primary" href="${pageContext.request.contextPath}/register">Register</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>
