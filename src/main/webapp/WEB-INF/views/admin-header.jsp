<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .admin-header-nav { background-color: #0f172a; height: 70px; display: flex; align-items: center; justify-content: space-between; padding: 0 40px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
    .admin-logo { color: #ffffff; font-size: 22px; font-weight: bold; text-decoration: none; }
    .admin-menu-list { display: flex; list-style: none; margin: 0; padding: 0; align-items: center; gap: 25px; }
    .admin-menu-item a { color: #cbd5e1; text-decoration: none; font-size: 15px; font-weight: 500; }
    .admin-menu-item a:hover, .admin-menu-item a.active { color: #38bdf8; }
    .btn-admin-logout { background-color: #2563eb; color: white; padding: 6px 16px; text-decoration: none; border-radius: 6px; font-size: 14px; font-weight: 600; }
    .btn-admin-logout:hover { background-color: #1d4ed8; }
</style>

<nav class="admin-header-nav">
    <a href="${pageContext.request.contextPath}/admin-dashboard" class="admin-logo">CheatSheet Hub</a>
    <ul class="admin-menu-list">
        <li class="admin-menu-item"><a href="${pageContext.request.contextPath}/admin-dashboard">Dashboard</a></li>
        <li class="admin-menu-item"><a href="${pageContext.request.contextPath}/admin/categories">Categories</a></li>
        <li class="admin-menu-item"><a href="${pageContext.request.contextPath}/admin/tags">Tags</a></li>
        <li class="admin-menu-item"><a href="${pageContext.request.contextPath}/admin/posts/pending">Pending Posts</a></li>
        <li class="admin-menu-item"><a href="${pageContext.request.contextPath}/logout" class="btn-admin-logout">Logout</a></li>
    </ul>
</nav> --%>