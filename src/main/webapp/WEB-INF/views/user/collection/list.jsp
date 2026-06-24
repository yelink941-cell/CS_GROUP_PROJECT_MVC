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
        /* 📁 Card Relative Layout & Hover Style */
        .folder-card-wrapper {
            position: relative;
        }
        .folder-card-link {
            text-decoration: none;
            color: inherit;
            display: block;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .folder-card-link:hover {
            transform: translateY(-5px);
        }
        .folder-card-link:hover .library-card {
            border-color: #10b981 !important;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.08) !important;
        }

        /* ✏️ 🗑️ Action Buttons Style on Top Right Corner */
        .card-actions {
            position: absolute;
            top: 1.25rem;
            right: 1.25rem;
            display: flex;
            gap: 10px;
            z-index: 15; /* Card Link ရဲ့ အပေါ်မှာ ရှိနေစေရန် */
        }
        .action-icon-btn {
            background: none;
            border: none;
            font-size: 1.1rem;
            cursor: pointer;
            text-decoration: none;
            transition: transform 0.2s;
        }
        .action-icon-btn:hover {
            transform: scale(1.2);
        }

        /* ✨ Layout Adjustments */
        .library-header-container {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 2rem;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 1.5rem;
        }
        .btn-create-folder {
            background-color: #10b981;
            color: white;
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            border: none;
            cursor: pointer;
            transition: background 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-create-folder:hover {
            background-color: #059669;
        }

        /* 📄 Pop-up Modal CSS (Simple & Clean) */
        .modal {
            display: none; 
            position: fixed;
            z-index: 100;
            left: 0; top: 0; width: 100%; height: 100%;
            background-color: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
        }
        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 2rem;
            border-radius: 12px;
            width: 90%;
            max-width: 450px;
            box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 1.25rem;
        }
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #1e293b;
            font-size: 14px;
        }
        .form-control {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            outline: none;
            box-sizing: border-box;
        }
        .form-control:focus {
            border-color: #10b981;
        }
        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 1.5rem;
        }
        .btn-cancel {
            background: #e2e8f0;
            color: #475569;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            border: none;
            font-weight: 600;
        }
    </style>
</head>
<body class="public-list-page">
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container" style="padding: 2rem; max-width: 1200px; margin: 0 auto;">
        
        <div class="library-header-container">
            <header class="library-header" style="margin: 0;">
                <span>Dashboard</span>
                <h1 style="margin: 0.2rem 0;">My Collection Folders</h1>
                <p style="margin: 0; color: #64748b;">Manage your saved public cheat sheets in personalized folders.</p>
            </header>
            
            <button class="btn-create-folder" onclick="openCreateModal()">
                ➕ Create New Folder
            </button>
        </div>

        <!-- 📁 Folders Grid Section -->
        <section style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 1.5rem;">
            <c:choose>
                <c:when test="${empty collections}">
                    <div style="grid-column: 1/-1; background: #f8fafc; color: #64748b; padding: 3rem; border-radius: 8px; text-align: center; border: 2px dashed #cbd5e1;">
                        You haven't created any collection folders yet. Click "Create New Folder" to start!
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="folder" items="${collections}">
                        <div class="folder-card-wrapper">
                            
                            <!-- 🛠️ ✏️ 🗑️ Edit & Delete ခလုတ်လေးများ -->
                            <div class="card-actions">
                                <!-- ✏️ Edit Button -->
                                <button class="action-icon-btn" 
                                        onclick="openEditModal('${folder.id}', '${folder.name}', '${folder.description}', ${folder.isPublic})" 
                                        title="Edit Folder">✏️</button>
                                
                                <!-- 🗑️ Delete Button -->
                                <a href="${pageContext.request.contextPath}/user/collections/delete/${folder.id}" 
                                   class="action-icon-btn" 
                                   onclick="return confirm('Are you sure you want to delete this folder entirely? This cannot be undone.');"
                                   title="Delete Folder">🗑️</a>
                            </div>

                            <!-- 📁 Folder Item ကို သွားမည့် ကတ်ပြားလင့်ခ် -->
                            <a href="${pageContext.request.contextPath}/user/collections/${folder.id}" class="folder-card-link">
                                <article class="library-card" style="background: white; padding: 1.5rem; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); border: 1px solid #eee; min-height: 140px; padding-right: 4.5rem;">
                                    <h3 style="color: #2b5cb8; margin-top: 0; font-size: 1.35rem; padding-right: 1rem;">📁 <c:out value="${folder.name}"/></h3>
                                    <p style="color: #666; font-size: 0.95rem; line-height: 1.4; margin: 0.5rem 0 1rem;"><c:out value="${folder.description}"/></p>
                                    <span class="public-label" style="background: ${folder.isPublic ? '#e6f4ea' : '#f1f3f4'}; color: ${folder.isPublic ? '#137333' : '#3c4043'}; padding: 0.25rem 0.5rem; font-size: 0.8rem; border-radius: 4px; font-weight: bold;">
                                        ${folder.isPublic ? 'Public' : 'Private'}
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
    <!-- 📄 ➕ (၁) Create Folder Modal Form -->
    <!-- ========================================== -->
    <div id="createModal" class="modal">
        <div class="modal-content">
            <h2 style="margin-top:0; color: #1e293b; border-bottom: 1px solid #e2e8f0; padding-bottom: 10px;">New Folder</h2>
            <form action="${pageContext.request.contextPath}/user/collections/new" method="post">
                <div class="form-group">
                    <label for="createName">Folder Name</label>
                    <input type="text" id="createName" name="name" class="form-control" placeholder="e.g., Spring Boot Advance" required>
                </div>
                <div class="form-group">
                    <label for="createDesc">Description</label>
                    <textarea id="createDesc" name="description" class="form-control" rows="3" placeholder="Brief details about this collection..."></textarea>
                </div>
                <div class="form-group" style="display: flex; align-items: center; gap: 8px;">
                    <input type="checkbox" id="createPublic" name="isPublic" value="true">
                    <label for="createPublic" style="margin: 0; cursor: pointer;">Make this folder Public</label>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn-cancel" onclick="closeModal('createModal')">Cancel</button>
                    <button type="submit" class="btn-create-folder" style="padding: 8px 16px;">Create</button>
                </div>
            </form>
        </div>
    </div>

    <!-- ========================================== -->
    <!-- 📄 ✏️ (၂) Edit Folder Modal Form -->
    <!-- ========================================== -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <h2 style="margin-top:0; color: #1e293b; border-bottom: 1px solid #e2e8f0; padding-bottom: 10px;">Edit Folder</h2>
            <form action="${pageContext.request.contextPath}/user/collections/edit" method="post">
                <!-- Hidden Input for Folder ID -->
                <input type="hidden" id="editId" name="id">
                
                <div class="form-group">
                    <label for="editName">Folder Name</label>
                    <input type="text" id="editName" name="name" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="editDesc">Description</label>
                    <textarea id="editDesc" name="description" class="form-control" rows="3"></textarea>
                </div>
                <div class="form-group" style="display: flex; align-items: center; gap: 8px;">
                    <input type="checkbox" id="editPublic" name="isPublic" value="true">
                    <label for="editPublic" style="margin: 0; cursor: pointer;">Make this folder Public</label>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn-cancel" onclick="closeModal('editModal')">Cancel</button>
                    <button type="submit" class="btn-create-folder" style="padding: 8px 16px; background-color: #3b82f6;">Update</button>
                </div>
            </form>
        </div>
    </div>

    <!-- 📜 JavaScript to Manage Forms Logic -->
    <script>
        function openCreateModal() {
            document.getElementById("createModal").style.display = "block";
        }

        // ✏️ Edit ခလုတ်နှိပ်လျှင် မူရင်းဒေတာများကို ဖြည့်ပြီး Pop-up ဖွင့်ပေးမည့်လုပ်ဆောင်ချက်
        function openEditModal(id, name, description, isPublic) {
            document.getElementById("editId").value = id;
            document.getElementById("editName").value = name;
            document.getElementById("editDesc").value = description;
            document.getElementById("editPublic").checked = isPublic;
            document.getElementById("editModal").style.display = "block";
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = "none";
        }

        // Pop-up မျက်နှာပြင်အပြင်ဘက်ကို ကလစ်နှိပ်လျှင် ပိတ်ပေးရန်
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