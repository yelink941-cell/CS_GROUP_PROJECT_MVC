<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tag Form</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
    
    <style>
        /* ============================================
           TAG FORM - ADDITIONAL STYLES
           ============================================ */
        
        .form-container {
            background: #ffffff;
            padding: 35px 40px;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
            max-width: 600px;
            margin-top: 20px;
        }
        
        .form-container .form-title {
            font-size: 20px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f1f5f9;
            display: flex;
            align-items: center;
            gap: 10px;
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
        
        .form-group input[type="text"] {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 15px;
            font-family: inherit;
            transition: border-color 0.2s, box-shadow 0.2s;
            box-sizing: border-box;
        }
        
        .form-group input[type="text"]:focus {
            outline: none;
            border-color: #8b5cf6;
            box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.1);
        }
        
        .form-group .help-text {
            font-size: 12px;
            color: #94a3b8;
            margin-top: 4px;
        }
        
        .form-group .error-text {
            color: #dc2626;
            font-size: 13px;
            margin-top: 4px;
            display: block;
        }
        
        /* Alert Messages */
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
        
        .alert-success {
            background: #dcfce7;
            color: #16a34a;
            padding: 14px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #16a34a;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-success::before {
            content: "✅";
            font-size: 18px;
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
            background: #8b5cf6;
            color: #ffffff;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-save:hover {
            background: #7c3aed;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(139, 92, 246, 0.35);
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
        
        /* Welcome Card */
        .welcome-card {
            background: #ffffff;
            padding: 30px 35px;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border-left: 8px solid #8b5cf6;
            margin-bottom: 30px;
        }
        
        .welcome-card h2 {
            font-size: 24px;
            color: #1e293b;
            margin: 0 0 8px 0;
        }
        
        .welcome-card p {
            color: #64748b;
            margin: 0;
            font-size: 15px;
            line-height: 1.6;
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
                <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link">
                    <span>📁 Category Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/tags" class="sidebar-link active">
                    <span>🏷️ Tags Management</span>
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
                <a href="${pageContext.request.contextPath}/admin/comments" class="sidebar-link">
                    <span>💬 Comment Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link">
                    <span>👥 User Management</span>
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
                <c:if test="${tag.id == null}">🏷️ Create New Tag</c:if>
                <c:if test="${tag.id != null}">✏️ Edit Tag</c:if>
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
                    <c:if test="${tag.id == null}">🏷️ Create New Tag</c:if>
                    <c:if test="${tag.id != null}">✏️ Edit Tag</c:if>
                </h2>
                <p>
                    <c:if test="${tag.id == null}">Fill in the details below to create a new tag.</c:if>
                    <c:if test="${tag.id != null}">Update the tag details below.</c:if>
                </p>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>
            
            <!-- Success Message -->
            <c:if test="${not empty successMessage}">
                <div class="alert-success">${successMessage}</div>
            </c:if>

            <!-- Form -->
            <div class="form-container">
                
                <c:set var="formAction" value="${pageContext.request.contextPath}/admin/tags" />
                <c:if test="${tag.id != null}">
                    <c:set var="formAction" value="${pageContext.request.contextPath}/admin/tags/update/${tag.id}" />
                </c:if>

                <div class="form-title">
                    <c:if test="${tag.id == null}">📝 New Tag</c:if>
                    <c:if test="${tag.id != null}">📝 Edit Tag</c:if>
                </div>

                <form action="${formAction}" method="post">
                    
                    <!-- Hidden ID for update -->
                    <c:if test="${tag.id != null}">
                        <input type="hidden" name="id" value="${tag.id}" />
                    </c:if>

                    <!-- Name -->
                    <div class="form-group">
                        <label for="name">Tag Name <span class="required">*</span></label>
                        <input type="text" id="name" name="name" value="${tag.name}" 
                               placeholder="Enter tag name..." required>
                        <div class="help-text">Example: Java, Spring, Hibernate, etc.</div>
                    </div>

                    <!-- Form Actions -->
                    <div class="form-actions">
                        <button type="submit" class="btn-save">
                            <c:if test="${tag.id == null}">💾 Create Tag</c:if>
                            <c:if test="${tag.id != null}">💾 Update Tag</c:if>
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/tags" class="btn-cancel">↩️ Cancel</a>
                    </div>

                </form>
            </div>

        </main>
    </div>

</body>
</html>