<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Collections - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    
    <style>
        /* ============================================
           MY COLLECTIONS - SAME COLORS AS CATEGORY
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
        .library-header-container {
            width: 100vw;
            margin-left: calc(-50vw + 50%);
            padding: 40px 20px 30px;
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 40%, #4f46e5 100%);
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 30px rgba(79, 70, 229, 0.25);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }
        
        .library-header-container::before {
            content: '';
            position: absolute;
            top: -60%;
            right: -10%;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50%;
        }
        
        .library-header-container::after {
            content: '';
            position: absolute;
            bottom: -50%;
            left: -5%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.04);
            border-radius: 50%;
        }
        
        .library-header {
            position: relative;
            z-index: 1;
        }
        
        .library-header span {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: #a5b4fc;
            font-weight: 600;
            display: block;
            margin-bottom: 4px;
        }
        
        .library-header h1 {
            font-size: 32px;
            font-weight: 800;
            color: #ffffff;
            margin: 0 0 4px 0;
        }
        
        .library-header h1::before {
            content: "📁 ";
        }
        
        .library-header p {
            font-size: 15px;
            color: #c7d2fe;
            margin: 0;
        }
        
        .btn-create-folder {
            position: relative;
            z-index: 1;
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
        
        .btn-create-folder:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        }
        
        /* ===== FOLDER GRID ===== */
        .folder-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 24px;
        }
        
        /* ===== FOLDER CARD ===== */
        .folder-card-wrapper {
            position: relative;
        }
        
        .folder-card-link {
            text-decoration: none;
            color: inherit;
            display: block;
            transition: transform 0.25s ease, box-shadow 0.25s ease;
        }
        
        .folder-card-link:hover {
            transform: translateY(-5px);
        }
        
        .folder-card-link:hover .library-card {
            border-color: #c7d2fe !important;
            box-shadow: 0 12px 32px -8px rgba(0, 0, 0, 0.12) !important;
        }
        
        .library-card {
            background: #ffffff;
            padding: 24px 24px 20px;
            border-radius: 16px;
            border: 1px solid #e8edf4;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            min-height: 140px;
            padding-right: 4.5rem;
            transition: all 0.3s ease;
        }
        
        .library-card h3 {
            color: #1e293b;
            margin: 0 0 6px 0;
            font-size: 20px;
            font-weight: 700;
        }
        
        .library-card h3 .folder-icon {
            margin-right: 6px;
        }
        
        .library-card .folder-description {
            color: #64748b;
            font-size: 14px;
            line-height: 1.6;
            margin: 6px 0 12px 0;
        }
        
        .public-label {
            display: inline-block;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .public-label.public {
            background: #dcfce7;
            color: #16a34a;
        }
        
        .public-label.private {
            background: #f1f5f9;
            color: #475569;
        }
        
        /* ===== CARD ACTIONS (Top Right) ===== */
        .card-actions {
            position: absolute;
            top: 16px;
            right: 16px;
            display: flex;
            gap: 8px;
            z-index: 15;
        }
        
        .action-icon-btn {
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid #e2e8f0;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #64748b;
        }
        
        .action-icon-btn:hover {
            background: #ffffff;
            transform: scale(1.1);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        .action-icon-btn.edit:hover {
            border-color: #4f46e5;
            color: #4f46e5;
        }
        
        .action-icon-btn.delete:hover {
            border-color: #ef4444;
            color: #ef4444;
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
        
        /* ===== MODAL ===== */
        .modal {
            display: none;
            position: fixed;
            z-index: 100;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
        }
        
        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 32px;
            border-radius: 16px;
            width: 90%;
            max-width: 480px;
            box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1);
            animation: modalSlideIn 0.3s ease;
        }
        
        @keyframes modalSlideIn {
            from {
                transform: translateY(-30px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        .modal-content h2 {
            margin: 0 0 20px 0;
            color: #1e293b;
            font-size: 22px;
            font-weight: 700;
            border-bottom: 2px solid #f1f5f9;
            padding-bottom: 12px;
        }
        
        .form-group {
            margin-bottom: 18px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #1e293b;
            font-size: 14px;
        }
        
        .form-control {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #d1d9e6;
            border-radius: 8px;
            outline: none;
            font-size: 14px;
            transition: border-color 0.2s;
            box-sizing: border-box;
            background: #fafcff;
        }
        
        .form-control:focus {
            border-color: #4f46e5;
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.12);
        }
        
        .form-control::placeholder {
            color: #94a3b8;
        }
        
        textarea.form-control {
            resize: vertical;
            min-height: 80px;
        }
        
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: #4f46e5;
            cursor: pointer;
        }
        
        .checkbox-group label {
            margin: 0;
            cursor: pointer;
            font-weight: 500;
        }
        
        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 20px;
            padding-top: 16px;
            border-top: 1px solid #f1f5f9;
        }
        
        .btn-cancel {
            background: #f1f5f9;
            color: #475569;
            padding: 8px 20px;
            border-radius: 8px;
            cursor: pointer;
            border: 1px solid #e2e8f0;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.2s;
        }
        
        .btn-cancel:hover {
            background: #e2e8f0;
            color: #0f172a;
        }
        
        .btn-submit {
            background: #4f46e5;
            color: white;
            padding: 8px 24px;
            border-radius: 8px;
            cursor: pointer;
            border: none;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.25s ease;
        }
        
        .btn-submit:hover {
            background: #4338ca;
            transform: translateY(-2px);
            box-shadow: 0 4px 16px rgba(79, 70, 229, 0.3);
        }
        
        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .page-container {
                padding: 0 14px 40px;
            }
            
            .library-header-container {
                flex-direction: column;
                align-items: stretch;
                gap: 12px;
                padding: 30px 16px 25px;
            }
            
            .library-header h1 {
                font-size: 24px;
            }
            
            .btn-create-folder {
                justify-content: center;
            }
            
            .folder-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }
            
            .library-card {
                padding: 18px;
                padding-right: 3.5rem;
            }
            
            .modal-content {
                margin: 20% auto;
                padding: 24px;
            }
        }
        
        @media (max-width: 480px) {
            .library-header h1 {
                font-size: 20px;
            }
            
            .library-header p {
                font-size: 13px;
            }
            
            .library-card h3 {
                font-size: 17px;
            }
            
            .card-actions {
                top: 12px;
                right: 12px;
            }
            
            .action-icon-btn {
                width: 28px;
                height: 28px;
                font-size: 12px;
            }
        }
    </style>
</head>
<body class="public-list-page">

    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container">
        
        <!-- ===== HEADER - FULL WIDTH ===== -->
        <div class="library-header-container">
            <header class="library-header">
                <span>📂 Dashboard</span>
                <h1>My Collection Folders</h1>
                <p>Manage your saved public cheat sheets in personalized folders.</p>
            </header>
            
            <button class="btn-create-folder" onclick="openCreateModal()">
                ➕ Create New Folder
            </button>
        </div>

        <!-- ===== FOLDERS GRID ===== -->
        <section class="folder-grid">
            <c:choose>
                <c:when test="${empty collections}">
                    <div class="empty-state">
                        <span class="icon">📁</span>
                        <h2>No folders yet</h2>
                        <p>Create your first collection folder to start saving cheat sheets.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="folder" items="${collections}">
                        <div class="folder-card-wrapper">
                            
                            <!-- Action Buttons -->
                            <div class="card-actions">
                                <button class="action-icon-btn edit" 
                                        onclick="openEditModal('${folder.id}', '${folder.name}', '${folder.description}', ${folder.isPublic})" 
                                        title="Edit Folder">✏️</button>
                                
                                <a href="${pageContext.request.contextPath}/user/collections/delete/${folder.id}" 
                                   class="action-icon-btn delete" 
                                   onclick="return confirm('Are you sure you want to delete this folder entirely? This cannot be undone.');"
                                   title="Delete Folder">🗑️</a>
                            </div>

                            <!-- Folder Link -->
                            <a href="${pageContext.request.contextPath}/user/collections/${folder.id}" class="folder-card-link">
                                <article class="library-card">
                                    <h3><span class="folder-icon">📁</span> <c:out value="${folder.name}"/></h3>
                                    <p class="folder-description"><c:out value="${folder.description}"/></p>
                                    <span class="public-label ${folder.isPublic ? 'public' : 'private'}">
                                        ${folder.isPublic ? '🌍 Public' : '🔒 Private'}
                                    </span>
                                </article>
                            </a>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </section>
    </main>

    <!-- ========================================== -->
    <!-- 📄 ➕ CREATE FOLDER MODAL -->
    <!-- ========================================== -->
    <div id="createModal" class="modal">
        <div class="modal-content">
            <h2>📁 Create New Folder</h2>
            <form action="${pageContext.request.contextPath}/user/collections/new" method="post">
                <div class="form-group">
                    <label for="createName">Folder Name <span style="color: #ef4444;">*</span></label>
                    <input type="text" id="createName" name="name" class="form-control" placeholder="e.g., Spring Boot Advance" required>
                </div>
                <div class="form-group">
                    <label for="createDesc">Description</label>
                    <textarea id="createDesc" name="description" class="form-control" rows="3" placeholder="Brief details about this collection..."></textarea>
                </div>
                <div class="form-group checkbox-group">
                    <input type="checkbox" id="createPublic" name="isPublic" value="true">
                    <label for="createPublic">Make this folder Public</label>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn-cancel" onclick="closeModal('createModal')">Cancel</button>
                    <button type="submit" class="btn-submit">Create Folder</button>
                </div>
            </form>
        </div>
    </div>

    <!-- ========================================== -->
    <!-- 📄 ✏️ EDIT FOLDER MODAL -->
    <!-- ========================================== -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <h2>✏️ Edit Folder</h2>
            <form action="${pageContext.request.contextPath}/user/collections/edit" method="post">
                <input type="hidden" id="editId" name="id">
                
                <div class="form-group">
                    <label for="editName">Folder Name <span style="color: #ef4444;">*</span></label>
                    <input type="text" id="editName" name="name" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="editDesc">Description</label>
                    <textarea id="editDesc" name="description" class="form-control" rows="3"></textarea>
                </div>
                <div class="form-group checkbox-group">
                    <input type="checkbox" id="editPublic" name="isPublic" value="true">
                    <label for="editPublic">Make this folder Public</label>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn-cancel" onclick="closeModal('editModal')">Cancel</button>
                    <button type="submit" class="btn-submit">Update Folder</button>
                </div>
            </form>
        </div>
    </div>

    <!-- ========================================== -->
    <!-- 📜 JAVASCRIPT -->
    <!-- ========================================== -->
    <script>
        function openCreateModal() {
            document.getElementById("createModal").style.display = "block";
        }

        function openEditModal(id, name, description, isPublic) {
            document.getElementById("editId").value = id;
            document.getElementById("editName").value = name;
            document.getElementById("editDesc").value = description || '';
            document.getElementById("editPublic").checked = isPublic;
            document.getElementById("editModal").style.display = "block";
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = "none";
        }

        window.onclick = function(event) {
            var createModal = document.getElementById("createModal");
            var editModal = document.getElementById("editModal");
            if (event.target == createModal) {
                createModal.style.display = "none";
            }
            if (event.target == editModal) {
                editModal.style.display = "none";
            }
        }
    </script>

</body>
</html>