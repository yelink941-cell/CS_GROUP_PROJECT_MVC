<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Categories</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f4f6f9; }
        .sidebar { width: 260px; background-color: #1e293b; color: #fff; position: fixed; height: 100vh; }
        .sidebar-brand { padding: 24px; font-size: 20px; font-weight: bold; background-color: #0f172a; text-align: center; color: #38bdf8; }
        .sidebar-menu { list-style: none; padding: 20px 0; }
        .sidebar-item { margin: 4px 15px; }
        .sidebar-link { display: block; padding: 12px 16px; color: #cbd5e1; text-decoration: none; border-radius: 6px; }
        .sidebar-link.active { background-color: #0284c7; color: #fff; }
        .sidebar-link:hover { background-color: #334155; }
        
        .main-workspace { margin-left: 260px; flex-grow: 1; }
        .top-navbar { height: 70px; background: white; display: flex; align-items: center; padding: 0 30px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); justify-content: space-between; }
        .content-area { padding: 40px; }
        
        /* Table Styles */
        .container-box { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #e2e8f0; padding: 14px; text-align: left; }
        th { background-color: #f8fafc; color: #475569; }
        .btn { padding: 8px 14px; text-decoration: none; border-radius: 6px; font-size: 14px; display: inline-block; }
        .btn-add { background: #0284c7; color: white; }
        .btn-edit { background: #eab308; color: black; margin-right: 5px; }
        .btn-delete { background: #ef4444; color: white; }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="sidebar-brand">CheatSheet Admin Panel 👑</div>
        <ul class="sidebar-menu">
            <li class="sidebar-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link">📊 Core Dashboard</a></li>
            <li class="sidebar-item"><a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link active">🗂️ Category Management</a></li>
            <li class="sidebar-item"><a href="#" class="sidebar-link">📝 Post Management</a></li>
            <li class="sidebar-item"><a href="#" class="sidebar-link">👥 User Management</a></li>
        </ul>
    </aside>

    <div class="main-workspace">
        <header class="top-navbar">
            <div style="font-size: 18px; font-weight: bold; color: #475569;">Database Catalogs</div>
            <a href="${pageContext.request.contextPath}/logout" style="color: #64748b; text-decoration: none; font-size: 14px;">Sign Out</a>
        </header>

        <main class="content-area">
            <div class="container-box">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <h2>Category Records Collection Matrix 🗂️</h2>
                    <a href="${pageContext.request.contextPath}/admin/categories/new" class="btn btn-add">+ Create New Category</a>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Category Name</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="cat" items="${categories}">
                            <tr>
                                <td>${cat.id}</td>
                                <td><strong><c:out value="${cat.name}"/></strong></td>
                                <td><c:out value="${cat.description}"/></td>
                                <td>
                                    <span style="padding: 4px 8px; border-radius: 4px; font-size: 12px; color: white; background: ${cat.isActive ? '#22c55e' : '#94a3b8'}">
                                        ${cat.isActive ? 'Active' : 'Inactive'}
                                    </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/categories/edit/${cat.id}" class="btn btn-edit">Edit</a>
                                    <a href="${pageContext.request.contextPath}/admin/categories/delete/${cat.id}" class="btn btn-delete" onclick="return confirm('Delete category?');">Delete</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

</body>
</html>