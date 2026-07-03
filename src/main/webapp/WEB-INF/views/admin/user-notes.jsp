<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hibernate.entity.User" %>
<%@ page import="com.hibernate.entity.UserNote" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - User Notes</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f8fafc; color: #1e293b; }
        .sidebar { width: 260px; background-color: #1e293b; color: #fff; display: flex; flex-direction: column; position: fixed; height: 100vh; }
        .sidebar-brand { padding: 24px; font-size: 20px; font-weight: bold; background-color: #0f172a; text-align: center; color: #38bdf8; }
        .sidebar-menu { list-style: none; flex-grow: 1; padding: 20px 0; }
        .sidebar-item { margin: 4px 15px; }
        .sidebar-link { display: flex; align-items: center; padding: 12px 16px; color: #cbd5e1; text-decoration: none; border-radius: 6px; font-size: 15px; transition: all 0.2s; }
        .sidebar-link:hover { background-color: #334155; color: #fff; }
        .sidebar-link.active { background-color: #0284c7; color: #fff; font-weight: 600; }
        .main-workspace { margin-left: 260px; flex-grow: 1; display: flex; flex-direction: column; }
        .top-navbar { height: 70px; background-color: #ffffff; display: flex; align-items: center; justify-content: space-between; padding: 0 30px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .nav-title { font-size: 18px; font-weight: 600; color: #475569; }
        .user-profile-badge { display: flex; align-items: center; gap: 10px; }
        .badge { background-color: #ef4444; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; text-transform: uppercase; }
        .content-area { padding: 40px; max-width: 1200px; width: 100%; margin: 0 auto; }

        .section-card { background: white; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; margin-bottom: 30px; overflow: hidden; }
        .section-header { background: #0f172a; color: white; padding: 18px 24px; font-size: 18px; font-weight: 600; display: flex; justify-content: space-between; align-items: center; }
        .section-body { padding: 24px; }

        .target-user-info { display: flex; align-items: center; gap: 16px; padding: 16px 20px; background: #f1f5f9; border-radius: 8px; margin-bottom: 20px; }
        .target-user-info .avatar { width: 48px; height: 48px; border-radius: 50%; background: #0284c7; color: white; display: flex; align-items: center; justify-content: center; font-size: 20px; font-weight: bold; }
        .target-user-info .user-details h3 { font-size: 16px; color: #0f172a; font-weight: 600; }
        .target-user-info .user-details p { font-size: 13px; color: #64748b; }

        /* Add Note Form */
        .add-note-form { background: #f8fafc; border: 2px dashed #cbd5e1; border-radius: 12px; padding: 24px; margin-bottom: 24px; }
        .add-note-form h4 { font-size: 15px; color: #475569; margin-bottom: 14px; }
        .form-group { margin-bottom: 12px; }
        .form-group label { display: block; font-size: 13px; font-weight: 600; color: #64748b; margin-bottom: 6px; }
        .form-group input, .form-group textarea { width: 100%; padding: 10px 14px; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 14px; color: #1e293b; font-family: inherit; transition: border-color 0.2s; }
        .form-group input:focus, .form-group textarea:focus { outline: none; border-color: #0284c7; box-shadow: 0 0 0 3px rgba(2, 132, 199, 0.1); }
        .form-group textarea { resize: vertical; min-height: 80px; }
        .btn { padding: 10px 20px; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s; display: inline-flex; align-items: center; }
        .btn-add { background-color: #0284c7; color: white; }
        .btn-add:hover { background-color: #0369a1; }
        .btn-edit { background-color: #f59e0b; color: white; padding: 6px 12px; font-size: 12px; }
        .btn-edit:hover { background-color: #d97706; }
        .btn-delete { background-color: #ef4444; color: white; padding: 6px 12px; font-size: 12px; }
        .btn-delete:hover { background-color: #dc2626; }
        .btn-back { background-color: #64748b; color: white; padding: 8px 16px; text-decoration: none; border-radius: 6px; font-size: 14px; display: inline-block; margin-bottom: 20px; }
        .btn-back:hover { background-color: #475569; color: white; }
        .btn-logout { background-color: #64748b; color: white; padding: 8px 16px; text-decoration: none; border-radius: 6px; font-size: 14px; }
        .btn-logout:hover { background-color: #475569; }

        /* Notes List */
        .note-card { background: white; border: 1px solid #e2e8f0; border-radius: 10px; padding: 20px; margin-bottom: 16px; border-left: 4px solid #0284c7; transition: box-shadow 0.2s; }
        .note-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        .note-card-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 10px; }
        .note-title { font-size: 16px; font-weight: 600; color: #0f172a; }
        .note-meta { font-size: 12px; color: #64748b; margin-top: 4px; }
        .note-content { font-size: 14px; color: #475569; line-height: 1.6; margin-top: 10px; padding-top: 10px; border-top: 1px solid #f1f5f9; }
        .note-actions { display: flex; gap: 8px; margin-top: 12px; }
        .no-data { padding: 40px; text-align: center; color: #64748b; font-style: italic; }
        .success-msg { background: #dcfce7; color: #166534; padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-size: 14px; border: 1px solid #bbf7d0; }
        .error-msg { background: #fee2e2; color: #991b1b; padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-size: 14px; border: 1px solid #fecaca; }

        /* Edit Modal */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.6); z-index: 1000; justify-content: center; align-items: center; }
        .modal-overlay.active { display: flex; }
        .modal-box { background: white; border-radius: 16px; padding: 32px; width: 90%; max-width: 500px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1); }
        .modal-box h3 { font-size: 18px; color: #0f172a; margin-bottom: 20px; }
        .modal-box .btn { margin-right: 8px; }
        .btn-cancel { background-color: #e2e8f0; color: #334155; }
        .btn-cancel:hover { background-color: #cbd5e1; }
    </style>
</head>
<body>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    String displayUsername = (currentUser != null) ? currentUser.getUsername() : "ADMIN";
    String displayRole = (currentUser != null) ? currentUser.getRole().name() : "ADMIN";

    User targetUser = (User) request.getAttribute("targetUser");
    List<UserNote> notes = (List<UserNote>) request.getAttribute("notes");

    String successMsg = (String) request.getAttribute("success");
    String errorMsg = (String) request.getAttribute("error");
%>

    <aside class="sidebar">
        <div class="sidebar-brand">CheatSheet Admin Panel &#128081;</div>
        <ul class="sidebar-menu">
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link">
                    <span>&#128202; Core Dashboard</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link">
                    <span>&#128451; Category Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/posts" class="sidebar-link">
                    <span>&#128221; Post Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/posts/pending" class="sidebar-link">
                    <span>&#9203; Pending Posts</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/comments" class="sidebar-link">
                    <span>&#128172; Comment Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link active">
                    <span>&#128101; User Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/reports" class="sidebar-link">
                    <span>&#128680; Report Logs</span>
                </a>
            </li>
        </ul>
    </aside>

    <div class="main-workspace">
        <header class="top-navbar">
            <div class="nav-title">Admin Notes for User Profile</div>
            <div class="user-profile-badge">
                <span>Welcome, <strong><%= displayUsername %></strong></span>
                <span class="badge"><%= displayRole %></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sign Out</a>
            </div>
        </header>

        <main class="content-area">

            <% if (successMsg != null) { %>
                <div class="success-msg"><%= successMsg %></div>
            <% } %>
            <% if (errorMsg != null) { %>
                <div class="error-msg"><%= errorMsg %></div>
            <% } %>

            <a href="${pageContext.request.contextPath}/admin/users" class="btn-back">&#8592; Back to User Management</a>

            <% if (targetUser != null) { %>
                <div class="target-user-info">
                    <div class="avatar">
                        <%= targetUser.getUsername() != null ? targetUser.getUsername().substring(0, 1).toUpperCase() : "U" %>
                    </div>
                    <div class="user-details">
                        <h3>@<%= targetUser.getUsername() %></h3>
                        <p><%= targetUser.getEmail() %> &bull; Role: <%= targetUser.getRole().name() %> &bull; Status: <%= targetUser.getStatus().name() %></p>
                    </div>
                </div>
            <% } %>

            <!-- ADD NOTE FORM -->
            <div class="add-note-form">
                <h4>&#9998; Add New Note</h4>
                <form action="${pageContext.request.contextPath}/admin/users/<%= targetUser != null ? targetUser.getId() : "" %>/notes/add" method="POST">
                    <div class="form-group">
                        <label for="title">Note Title</label>
                        <input type="text" id="title" name="title" placeholder="e.g., Warning for spam behavior" required />
                    </div>
                    <div class="form-group">
                        <label for="content">Note Content</label>
                        <textarea id="content" name="content" placeholder="Write your internal note about this user..." required></textarea>
                    </div>
                    <button type="submit" class="btn btn-add">Add Note</button>
                </form>
            </div>

            <!-- NOTES LIST -->
            <div class="section-card">
                <div class="section-header">
                    <span>&#128203; Internal Notes (<%= notes != null ? notes.size() : 0 %>)</span>
                </div>
                <div class="section-body">
                    <% if (notes == null || notes.isEmpty()) { %>
                        <div class="no-data">No admin notes found for this user.</div>
                    <% } else { %>
                        <% for (UserNote note : notes) { %>
                            <div class="note-card">
                                <div class="note-card-header">
                                    <div>
                                        <div class="note-title"><%= note.getTitle() %></div>
                                        <div class="note-meta">
                                            By <strong><%= note.getAdmin() != null ? note.getAdmin().getUsername() : "System" %></strong>
                                            &bull; Created: <%= note.getCreatedAt() != null ? note.getCreatedAt().toString().substring(0, 19) : "N/A" %>
                                            <% if (note.getUpdatedAt() != null && !note.getUpdatedAt().equals(note.getCreatedAt())) { %>
                                                &bull; Updated: <%= note.getUpdatedAt().toString().substring(0, 19) %>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                                <div class="note-content"><%= note.getContent() %></div>
                                <div class="note-actions">
                                    <button type="button" class="btn btn-edit" onclick="openEditModal(<%= note.getId() %>, '<%= note.getTitle().replace("'", "\\'") %>', '<%= note.getContent().replace("'", "\\'").replace("\n", "\\n") %>')">&#9998; Edit</button>
                                    <form action="${pageContext.request.contextPath}/admin/users/<%= targetUser.getId() %>/notes/<%= note.getId() %>/delete" method="POST" style="display:inline;">
                                        <button type="submit" class="btn btn-delete" onclick="return confirm('Delete this note permanently?')">&#128465; Delete</button>
                                    </form>
                                </div>
                            </div>
                        <% } %>
                    <% } %>
                </div>
            </div>

        </main>
    </div>

    <!-- EDIT NOTE MODAL -->
    <div class="modal-overlay" id="editModal">
        <div class="modal-box">
            <h3>&#9998; Edit Note</h3>
            <form action="${pageContext.request.contextPath}/admin/users/<%= targetUser != null ? targetUser.getId() : "" %>/notes/edit" method="POST" id="editForm">
                <input type="hidden" name="noteId" id="editNoteId" />
                <div class="form-group">
                    <label for="editTitle">Title</label>
                    <input type="text" id="editTitle" name="title" required />
                </div>
                <div class="form-group">
                    <label for="editContent">Content</label>
                    <textarea id="editContent" name="content" required></textarea>
                </div>
                <button type="submit" class="btn btn-edit" style="padding: 10px 20px; font-size: 14px;">Update Note</button>
                <button type="button" class="btn btn-cancel" onclick="closeEditModal()" style="padding: 10px 20px; font-size: 14px;">Cancel</button>
            </form>
        </div>
    </div>

    <script>
        function openEditModal(noteId, title, content) {
            document.getElementById('editNoteId').value = noteId;
            document.getElementById('editTitle').value = title;
            document.getElementById('editContent').value = content;
            document.getElementById('editModal').classList.add('active');
        }

        function closeEditModal() {
            document.getElementById('editModal').classList.remove('active');
        }

        // Close modal on outside click
        document.getElementById('editModal').addEventListener('click', function(e) {
            if (e.target === this) closeEditModal();
        });
    </script>

</body>
</html>
