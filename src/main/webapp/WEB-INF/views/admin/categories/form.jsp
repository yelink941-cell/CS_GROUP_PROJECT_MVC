<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Category Form</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
    
    <style>
        /* ============================================
           ADDITIONAL FORM STYLES
           ============================================ */
        .form-container {
            background: #ffffff;
            padding: 35px 40px;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
            max-width: 720px;
            margin-top: 20px;
        }
        
        .form-container .form-title {
            font-size: 20px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f1f5f9;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 6px;
            font-size: 14px;
        }
        
        .form-group label .required {
            color: #ef4444;
            margin-left: 2px;
        }
        
        .form-group input[type="text"],
        .form-group textarea {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 15px;
            font-family: inherit;
            transition: border-color 0.2s, box-shadow 0.2s;
            box-sizing: border-box;
        }
        
        .form-group input[type="text"]:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }
        
        .form-group .error-text {
            color: #dc2626;
            font-size: 13px;
            margin-top: 4px;
            display: block;
        }
        
        /* Checkbox Style */
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: #3b82f6;
            cursor: pointer;
        }
        
        .checkbox-group label {
            font-weight: 600;
            color: #1e293b;
            font-size: 14px;
            cursor: pointer;
            margin: 0;
        }
        
        /* Form Actions */
        .form-actions {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #f1f5f9;
        }
        
        .btn-save {
            padding: 10px 32px;
            background: #3b82f6;
            color: #ffffff;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-save:hover {
            background: #2563eb;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.35);
        }
        
        .btn-save:active {
            transform: scale(0.97);
        }
        
        .btn-cancel {
            padding: 10px 24px;
            color: #64748b;
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            text-decoration: none;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.2s;
        }
        
        .btn-cancel:hover {
            background: #e2e8f0;
            color: #1e293b;
        }
        
        /* Error Alert */
        .alert-error {
            background: #fee2e2;
            color: #dc2626;
            padding: 14px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #dc2626;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-error::before {
            content: "❌";
            font-size: 18px;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .form-container {
                padding: 25px 20px;
            }
            
            .form-actions {
                flex-wrap: wrap;
            }
            
            .btn-save,
            .btn-cancel {
                width: 100%;
                text-align: center;
                justify-content: center;
            }
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-brand">CheatSheet Admin Panel 👑</div>
        <ul class="sidebar-menu">
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link">
                    <span>📊 Core Dashboard</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link active">
                    <span>📁 Category Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/posts" class="sidebar-link">
                    <span>📄 Post Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/posts/pending" class="sidebar-link">
                    <span>⏳ Pending Posts</span>
                </a>
            </li>
           
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link">
                    <span>👥 User Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/announcements" class="sidebar-link">
                    <span>&#128364; Event Announcements</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet" class="sidebar-link">
                    <span>&#128196; CheatSheet Report</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/reports" class="sidebar-link">
                    <span>📊 Report Logs</span>
                </a>
            </li>
        </ul>
    </aside>

    <!-- Main Workspace -->
    <div class="main-workspace">
        
        <!-- Top Navbar -->
        <header class="top-navbar">
            <div class="nav-title">
                <c:if test="${category.id == null}">📝 Create Category</c:if>
                <c:if test="${category.id != null}">✏️ Edit Category</c:if>
            </div>
            <div class="user-profile-badge">
                <span>Welcome, <strong>Admin</strong></span>
                <span class="badge">ADMIN</span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sign Out</a>
            </div>
        </header>

        <!-- Content Area -->
        <main class="content-area">
            
            <!-- Welcome Card -->
            <div class="welcome-card">
                <h2>
                    <c:if test="${category.id == null}">📝 Create New Category</c:if>
                    <c:if test="${category.id != null}">✏️ Edit Category</c:if>
                </h2>
                <p>
                    <c:if test="${category.id == null}">Fill in the details below to create a new category.</c:if>
                    <c:if test="${category.id != null}">Update the category details below.</c:if>
                </p>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">
                    ${errorMessage}
                </div>
            </c:if>

            <!-- Form -->
            <div class="form-container">
                
                <c:set var="formAction" value="${pageContext.request.contextPath}/admin/categories" />
                <c:if test="${category.id != null}">
                    <c:set var="formAction" value="${pageContext.request.contextPath}/admin/categories/update/${category.id}" />
                </c:if>

                <form action="${formAction}" method="post">
                    
                    <!-- Hidden ID for update -->
                    <c:if test="${category.id != null}">
                        <input type="hidden" name="id" value="${category.id}" />
                    </c:if>

                    <!-- Name -->
                    <div class="form-group">
                        <label for="name">Category Name <span class="required">*</span></label>
                        <input type="text" id="name" name="name" value="${category.name}" 
                               placeholder="Enter category name..." required>
                    </div>

                    <!-- Description -->
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" rows="5" 
                                  placeholder="Enter category description..."><c:out value="${category.description}" /></textarea>
                    </div>

                    <!-- Active Checkbox -->
                   <%--  <div class="checkbox-group">
                        <input type="checkbox" id="isActive" name="isActive" value="true"
                               <c:if test="${category.isActive == true || category.id == null}">checked</c:if>>
                        <label for="isActive">Active Category</label>
                    </div> --%>

                    <!-- Form Actions -->
                    <div class="form-actions">
                        <button type="submit" class="btn-save">
                            <c:if test="${category.id == null}">💾 Create Category</c:if>
                            <c:if test="${category.id != null}">💾 Update Category</c:if>
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/categories" class="btn-cancel">↩️ Cancel</a>
                    </div>

                </form>
            </div>

        </main>
    </div>

</body>
</html>