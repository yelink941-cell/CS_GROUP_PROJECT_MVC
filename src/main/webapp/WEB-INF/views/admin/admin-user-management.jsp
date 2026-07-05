<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hibernate.entity.User" %>
<%@ page import="com.hibernate.entity.UserProfile" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Panel - User Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* ===== GLOBAL RESETS ===== */
        * { 
            box-sizing: border-box; 
            margin: 0; 
            padding: 0; 
            font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, 'Helvetica Neue', Arial, sans-serif; 
        }
        
        body { 
            display: flex; 
            min-height: 100vh; 
            background: #f0f2f5; 
            color: #1a2332;
        }
        
        /* ===== SIDEBAR NAVIGATION ===== */
        .sidebar { 
            width: 260px; 
            background: linear-gradient(180deg, #1a2332 0%, #0f1724 100%);
            color: #fff; 
            position: fixed; 
            height: 100vh;
            box-shadow: 4px 0 20px rgba(0,0,0,0.15);
        }
        
        .sidebar-brand { 
            padding: 28px 24px; 
            font-size: 20px; 
            font-weight: 700; 
            background: rgba(255,255,255,0.03);
            text-align: center; 
            color: #60a5fa;
            letter-spacing: 0.5px;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        
        .sidebar-menu { 
            list-style: none; 
            padding: 16px 0; 
        }
        
        .sidebar-link { 
            display: block; 
            padding: 12px 20px; 
            color: #94a3b8; 
            text-decoration: none; 
            margin: 4px 12px; 
            border-radius: 10px; 
            font-size: 14px;
            font-weight: 500;
            transition: all 0.25s ease;
        }
        
        .sidebar-link:hover { 
            background: rgba(255,255,255,0.08); 
            color: #fff;
            transform: translateX(4px);
        }
        
        .sidebar-link.active { 
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: #fff; 
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(59,130,246,0.3);
        }
        
        /* ===== MAIN WORKSPACE CONTAINER ===== */
        .main-workspace { 
            margin-left: 260px; 
            flex-grow: 1; 
            padding: 32px 40px;
            background: #f0f2f5;
        }
        
        h2 { 
            font-size: 26px; 
            color: #0f1724; 
            font-weight: 700; 
            margin-bottom: 24px;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        h2::before {
            content: "👥";
            font-size: 28px;
        }

        /* Flash messages */
        .flash-msg {
            padding: 14px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 14px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .flash-success { background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; }
        .flash-error { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
        
        /* ===== TOP UTILITY ACTION BAR ===== */
        .utility-bar { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 28px;
            gap: 20px;
        }
        
        .search-container { 
            position: relative; 
            width: 100%; 
            max-width: 480px; 
        }
        
        .search-container i { 
            position: absolute; 
            left: 16px; 
            top: 50%; 
            transform: translateY(-50%); 
            color: #94a3b8; 
            font-size: 15px; 
        }
        
        .search-input { 
            width: 100%; 
            padding: 12px 16px 12px 46px; 
            border: 1px solid #cbd5e1; 
            border-radius: 12px; 
            outline: none; 
            font-size: 14px;
            background: #fff;
            transition: all 0.25s ease;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        }
        
        .search-input:focus { 
            border-color: #3b82f6; 
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.15); 
            background: #fff;
        }
        
        .user-metric-badge {
            background: #fff;
            padding: 10px 20px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            color: #475569;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
            border: 1px solid #e2e8f0;
        }
        
        .user-metric-badge span { color: #3b82f6; font-size: 16px; font-weight: 700; }
        
        /* ===== DATA TABLE CARD WRAPPER ===== */
        .table-container { 
            background: #ffffff; 
            border-radius: 16px; 
            box-shadow: 0 4px 20px rgba(0,0,0,0.04); 
            border: 1px solid #e2e8f0; 
            overflow: hidden; 
        }
        
        table { 
            width: 100%; 
            border-collapse: collapse; 
            text-align: left; 
        }
        
        th { 
            background: #f8fafc; 
            padding: 16px 20px; 
            font-size: 12px; 
            font-weight: 700; 
            color: #64748b; 
            text-transform: uppercase; 
            letter-spacing: 0.8px; 
            border-bottom: 1px solid #e2e8f0; 
        }
        
        td { 
            padding: 16px 20px; 
            border-bottom: 1px solid #f1f5f9; 
            font-size: 14px; 
            color: #334155;
            vertical-align: middle;
        }
        
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #f8fafc; }
        
        /* ===== AVATAR & USER BADGES ===== */
        .mini-avatar { 
            width: 44px; 
            height: 44px; 
            border-radius: 50%; 
            object-fit: cover; 
            border: 2px solid #e2e8f0;
            box-shadow: 0 2px 6px rgba(0,0,0,0.06);
        }
        
        .avatar-letter { 
            width: 44px; 
            height: 44px; 
            border-radius: 50%; 
            background: linear-gradient(135deg, #3b82f6, #6366f1); 
            color: #fff; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-weight: 700; 
            font-size: 18px; 
            box-shadow: 0 2px 6px rgba(59,130,246,0.3);
        }
        
        select { 
            padding: 8px 12px; 
            border: 1px solid #cbd5e1; 
            border-radius: 8px; 
            outline: none; 
            font-weight: 600; 
            font-size: 13px; 
            background: #f8fafc;
            color: #334155;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        select:hover { border-color: #3b82f6; }
        select:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.1); }
        
        /* ===== BUTTON COMPONENT UI ===== */
        .btn { 
            padding: 6px 16px; 
            border: none; 
            border-radius: 8px; 
            font-weight: 600; 
            cursor: pointer; 
            text-decoration: none; 
            font-size: 12px; 
            display: inline-flex; 
            align-items: center; 
            gap: 6px;
            transition: all 0.2s ease;
        }
        
        .btn-update { background: #d1fae5; color: #065f46; }
        .btn-update:hover { 
            background: #a7f3d0; 
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(16,185,129,0.2);
        }
        
        .btn-view { background: #dbeafe; color: #1e40af; }
        .btn-view:hover { 
            background: #bfdbfe; 
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(59,130,246,0.2);
        }

        .btn-ban { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
        .btn-ban:hover { background: #fee2e2; transform: translateY(-1px); }

        .btn-unban { background: #ecfdf5; color: #047857; border: 1px solid #a7f3d0; }
        .btn-unban:hover { background: #d1fae5; transform: translateY(-1px); }

        .badge-banned {
            background: #fef2f2;
            color: #991b1b;
            padding: 4px 10px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 11px;
            border: 1px solid #fecaca;
            display: inline-block;
        }

        /* ===== MODAL DISPLAY SYSTEM ===== */
        .modal-mask { 
            position: fixed; 
            top:0; left:0; width:100vw; height:100vh; 
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(8px);
            display: flex; align-items: center; justify-content: center; 
            opacity: 0; pointer-events: none; 
            transition: opacity 0.3s ease; z-index: 999; 
        }
        
        .modal-mask.open { opacity: 1; pointer-events: auto; }
        
        .modal-body { 
            background: #ffffff;
            width: 100%; max-width: 520px; padding: 36px 40px; border-radius: 20px; 
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25);
            transform: scale(0.95) translateY(10px); 
            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            position: relative; 
        }
        
        .modal-mask.open .modal-body { transform: scale(1) translateY(0); }
        
        .modal-close-x { 
            position: absolute; top: 16px; right: 20px; background: #f1f4f9;
            border: none; width: 36px; height: 36px; border-radius: 50%;
            font-size: 18px; color: #64748b; cursor: pointer;
            transition: all 0.2s ease; display: flex; align-items: center; justify-content: center;
        }
        
        .modal-close-x:hover { background: #e2e8f0; transform: rotate(90deg); }
        
        .modal-header-profile { display: flex; align-items: center; gap: 20px; margin-bottom: 24px; border-bottom: 2px solid #f1f4f9; padding-bottom: 20px; }
        .modal-avatar { width: 76px; height: 76px; border-radius: 50%; object-fit: cover; border: 3px solid #e8edf3; }
        
        .modal-avatar-letter { 
            width: 76px; height: 76px; border-radius: 50%; 
            background: linear-gradient(135deg, #3b82f6, #6366f1);
            display: inline-flex; align-items: center; justify-content: center; 
            font-weight: 700; color: #fff; border: 3px solid #e8edf3; font-size: 30px; 
        }
        
        .modal-name { font-size: 22px; font-weight: 700; color: #0f1724; }
        .modal-username { color: #3b82f6; font-weight: 600; font-size: 14px; }
        .modal-section-title { font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.8px; margin: 20px 0 10px 0; display: block; }
        
        .modal-bio { 
            font-size: 14px; color: #475569; font-style: italic; background: #f8fafc; 
            padding: 14px 18px; border-radius: 12px; line-height: 1.6; min-height: 44px;
            border-left: 3px solid #3b82f6;
        }
        
        .modal-info-grid { 
            display: grid; grid-template-columns: 1fr 1fr; gap: 12px; font-size: 14px; 
            background: #f8fafc; padding: 16px 18px; border-radius: 12px; 
        }
        
        .modal-info-row { display: flex; flex-direction: column; gap: 2px; }
        .modal-label { color: #64748b; font-weight: 500; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px; }
        .modal-val { color: #0f1724; font-weight: 600; }
        
        /* ===== RESPONSIVE MEDIA BREAKPOINTS ===== */
        @media (max-width: 768px) {
            .main-workspace { padding: 20px; }
            .modal-body { padding: 28px 24px; margin: 16px; }
            .modal-info-grid { grid-template-columns: 1fr; }
            td, th { padding: 12px 14px; font-size: 13px; }
        }
        
        @media (max-width: 480px) {
            .sidebar { width: 220px; }
            .main-workspace { margin-left: 220px; padding: 16px; }
            .table-container { border-radius: 12px; }
            .modal-header-profile { flex-direction: column; text-align: center; }
        }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="sidebar-brand">CheatSheet Hub</div>
        <ul class="sidebar-menu">
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link">
                    <span>📊 Core Dashboard</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link">
                    <span>🗂 Category Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/posts" class="sidebar-link">
                    <span>📝 Post Management</span>
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
                <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link active">
                    <span>👥 User Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/announcements" class="sidebar-link">
                    <span>📢 Event Announcements</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet" class="sidebar-link">
                    <span>📄 CheatSheet Report</span>
                </a>
            </li>
        </ul>
    </aside>

    <main class="main-workspace">
        <h2>User Management Directory</h2>

        <% if (request.getAttribute("success") != null || session.getAttribute("success") != null) { %>
            <div class="flash-msg flash-success">
                <i class="fas fa-check-circle"></i> <%= request.getAttribute("success") != null ? request.getAttribute("success") : session.getAttribute("success") %>
            </div>
            <% session.removeAttribute("success"); %>
        <% } %>
        <% if (request.getAttribute("error") != null || session.getAttribute("error") != null) { %>
            <div class="flash-msg flash-error">
                <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") != null ? request.getAttribute("error") : session.getAttribute("error") %>
            </div>
            <% session.removeAttribute("error"); %>
        <% } %>
        
        <div class="utility-bar">
            <form action="${pageContext.request.contextPath}/admin/users" method="GET" class="search-container">
                <i class="fas fa-search"></i>
                <input type="text" 
                       name="search" 
                       class="search-input" 
                       placeholder="Search by Username, Email, or Full Name..." 
                       value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" />
            </form>
            
            <% 
                List<User> usersList = (List<User>) request.getAttribute("users");
                int userCount = (usersList != null) ? usersList.size() : 0;
            %>
            <div class="user-metric-badge">
                Active Users Listed: <span><%= userCount %></span>
            </div>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th style="width: 70px;">Avatar</th>
                        <th>User Account</th>
                        <th>Full Name</th>
                        <th>Gender</th>
                        <th>Status & Ban Remaining</th>
                        <th style="text-align: right;">Action Menu</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        if (usersList == null || usersList.isEmpty()) {
                    %>
                    <tr>
                        <td colspan="6" style="text-align:center; padding:40px; color:#64748b;">
                            No registered users found matching the search criteria.
                        </td>
                    </tr>
                    <% 
                        } else {
                            for(User u : usersList) {
                                UserProfile prof = u.getProfile(); 
                                String fullName = (prof != null && prof.getFullName() != null) ? prof.getFullName() : "No Profile Linked";
                                String gender = (prof != null && prof.getGender() != null) ? prof.getGender() : "N/A";
                                String bio = (prof != null && prof.getBio() != null) ? prof.getBio() : "No biography compiled yet.";
                                
                                String initialLetter = "U";
                                if (u.getUsername() != null && !u.getUsername().trim().isEmpty()) {
                                    initialLetter = u.getUsername().substring(0, 1).toUpperCase();
                                }
                                
                                boolean hasRealAvatar = (prof != null && prof.getAvatar() != null && prof.getAvatar().length > 0);
                                String rawAvatarSrc = "";
                                String imgHtml = "<div class='avatar-letter'>" + initialLetter + "</div>";
                                
                                if (hasRealAvatar) {
                                    String base64Img = Base64.getEncoder().encodeToString(prof.getAvatar());
                                    rawAvatarSrc = "data:image/jpeg;base64," + base64Img.replaceAll("[\\r\\n\\s]+", "");
                                    imgHtml = "<img src='" + rawAvatarSrc + "' class='mini-avatar' alt='Avatar' />";
                                }

                                boolean isBanned = u.isCurrentlyBanned();
                    %>
                    <tr>
                        <td><%= imgHtml %></td>
                        <td>
                            <strong>@<%= u.getUsername() %></strong><br/>
                            <span style="font-size:12px; color:#64748b;"><%= u.getEmail() %></span>
                        </td>
                        <td><%= fullName %></td>
                        <td><span style="text-transform: capitalize;"><%= gender %></span></td>
                        
                        <td>
                            <% if (isBanned) { %>
                                <span class="badge-banned">🚫 BANNED</span>
                                <div style="font-size:11px; color:#dc2626; margin-top:4px; font-weight:600;">
                                    <%= u.getBanRemainingText() %>
                                </div>
                            <% } else { %>
                                <form id="form-<%= u.getId() %>" action="${pageContext.request.contextPath}/admin/users/update-status" method="POST" style="display:inline;">
                                    <input type="hidden" name="userId" value="<%= u.getId() %>" />
                                    <input type="hidden" name="role" value="<%= u.getRole().name() %>" />
                                    <select name="status" onchange="document.getElementById('form-<%= u.getId() %>').submit();">
                                        <option value="ACTIVE" <%= u.getStatus().name().equals("ACTIVE")?"selected":"" %>>ACTIVE</option>
                                        <option value="INACTIVE" <%= u.getStatus().name().equals("INACTIVE")?"selected":"" %>>INACTIVE</option>
                                    </select>
                                </form>
                            <% } %>
                        </td>
                        <td style="text-align: right;">
                            <div style="display: flex; align-items: center; justify-content: flex-end; gap: 6px; flex-wrap: wrap;">
                                <% if (isBanned) { %>
                                    <!-- 🎉 UNBAN / PARDON BUTTON -->
                                    <form action="${pageContext.request.contextPath}/admin/users/<%= u.getId() %>/unban" method="POST" style="margin:0;">
                                        <button type="submit" class="btn btn-unban" onclick="return confirm('ဒီ User ကို Ban ခဲ့တာမှ ကင်းလွှတ်ခွင့်ပေးပြီး (Unban) ပြန်ဖွင့်ပေးမှာ သေချာပါသလား။');">
                                            <i class="fas fa-key"></i> 🎉 Unban (ကင်းလွှတ်ခွင့်)
                                        </button>
                                    </form>
                                <% } else { %>
                                    <!-- 🚫 TIMED BAN BUTTON -->
                                    <button type="button" class="btn btn-ban" onclick="openBanModal('<%= u.getId() %>', '<%= u.getUsername().replace("'", "\\'") %>')">
                                        <i class="fas fa-ban"></i> Ban / Suspend
                                    </button>
                                <% } %>
                                
                                <button type="button" 
                                        class="btn btn-view" 
                                        data-name="<%= fullName.replace("\"", "&quot;") %>"
                                        data-username="<%= u.getUsername() != null ? u.getUsername().replace("\"", "&quot;") : "" %>"
                                        data-gender="<%= gender %>"
                                        data-bio="<%= bio.replace("\"", "&quot;").replace("\n", " ").replace("\r", "") %>"
                                        data-hasavatar="<%= hasRealAvatar %>"
                                        data-letter="<%= initialLetter %>"
                                        data-status="<%= u.getStatus().name() %>"
                                        data-email="<%= u.getEmail() %>"
                                        data-role="<%= u.getRole().name() %>"
                                        onclick="openProfileInspector(this)">
                                        <i class="fas fa-eye"></i> View
                                </button>                                   
                            </div>
                        </td>
                    </tr>
                    <%      }
                        } 
                    %>
                </tbody>
            </table>
        </div>

        <% 
            Integer currentPage = (Integer) request.getAttribute("currentPage");
            Integer totalPages = (Integer) request.getAttribute("totalPages");
            
            if (currentPage != null && totalPages != null && totalPages > 1) {
        %>
        <div class="pagination-bar" style="display: flex; justify-content: space-between; align-items: center; margin-top: 24px; padding: 0 4px;">
            <span style="font-size: 14px; color: #64748b; font-weight: 500;">
                Showing page <strong style="color: #0f1724;"><%= currentPage %></strong> of <strong style="color: #0f1724;"><%= totalPages %></strong>
            </span>
            
            <div style="display: flex; gap: 8px;">
                <% 
                    String currentSearch = request.getParameter("search");
                    String searchQueryString = (currentSearch != null && !currentSearch.trim().isEmpty()) ? "&search=" + java.net.URLEncoder.encode(currentSearch, "UTF-8") : "";
                %>
                <% if (currentPage > 1) { %>
                    <a href="${pageContext.request.contextPath}/admin/users?page=<%= currentPage - 1 %><%= searchQueryString %>" class="btn btn-paginated">
                        <i class="fas fa-chevron-left" style="font-size: 10px;"></i> Previous
                    </a>
                <% } %>
                <% if (currentPage < totalPages) { %>
                    <a href="${pageContext.request.contextPath}/admin/users?page=<%= currentPage + 1 %><%= searchQueryString %>" class="btn btn-paginated-active">
                        Next <i class="fas fa-chevron-right" style="font-size: 10px;"></i>
                    </a>
                <% } %>
            </div>
        </div>
        <% } %>
    </main>

    <!-- ===== PROFILE INSPECTOR MODAL ===== -->
    <div class="modal-mask" id="inspectorModal" onclick="closeProfileInspector(event)">
        <div class="modal-body" onclick="event.stopPropagation()">
            <button class="modal-close-x" onclick="document.getElementById('inspectorModal').classList.remove('open')">&times;</button>
            <div class="modal-header-profile">
                <div id="modalAvatarSlot"></div>
                <div>
                    <div class="modal-name" id="modalName">Name</div>
                    <div class="modal-username" id="modalUsername">@username</div>
                </div>
            </div>
            <span class="modal-section-title">Biography</span>
            <div class="modal-bio" id="modalBio">"Bio."</div>
            <span class="modal-section-title">Core Identity Profile</span>
            <div class="modal-info-grid">
                <div class="modal-info-row"><span class="modal-label">Gender Axis:</span><span class="modal-val" id="modalGender">N/A</span></div>
                <div class="modal-info-row"><span class="modal-label">Account Status:</span><span class="modal-val" id="modalStatus">N/A</span></div>
                <div class="modal-info-row"><span class="modal-label">Email Address:</span><span class="modal-val" id="modalEmail">N/A</span></div>
                <div class="modal-info-row"><span class="modal-label">System Role:</span><span class="modal-val" id="modalRole">N/A</span></div>
            </div>
        </div>
    </div>

    <!-- ===== TIMED BAN MODAL ===== -->
    <div class="modal-mask" id="banModal" onclick="if(event.target.classList.contains('modal-mask')) this.classList.remove('open')">
        <div class="modal-body" onclick="event.stopPropagation()">
            <button class="modal-close-x" onclick="document.getElementById('banModal').classList.remove('open')">&times;</button>
            <h3 style="font-size: 20px; color: #0f1724; margin-bottom: 8px;">🚫 Suspend / Ban User</h3>
            <p style="color: #64748b; font-size: 14px; margin-bottom: 20px;">
                User: <strong id="banTargetUsername" style="color: #2563eb;">@username</strong>
            </p>

            <form id="banForm" action="" method="POST">
                <div style="margin-bottom: 16px;">
                    <label style="display: block; font-size: 12px; font-weight: 700; color: #475569; margin-bottom: 6px; text-transform: uppercase;">
                        Ban Duration (အချိန်ကာလ သတ်မှတ်ချက်):
                    </label>
                    <select name="duration" style="width: 100%; padding: 10px; border-radius: 8px;">
                        <option value="1_WEEK">1 Week (၁ ပတ်)</option>
                        <option value="1_MONTH">1 Month (၁ လ)</option>
                        <option value="1_YEAR">1 Year (၁ နှစ်)</option>
                        <option value="PERMANENT">Permanent Ban (ထာဝရ ပိတ်ပင်မည်)</option>
                    </select>
                </div>

                <div style="margin-bottom: 20px;">
                    <label style="display: block; font-size: 12px; font-weight: 700; color: #475569; margin-bottom: 6px; text-transform: uppercase;">
                        Reason for Suspension (အကြောင်းအရင်း):
                    </label>
                    <textarea name="reason" rows="3" required placeholder="Violated community rules..." style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid #cbd5e1; font-size: 14px;"></textarea>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 10px;">
                    <button type="button" class="btn" style="background:#e2e8f0; color:#475569;" onclick="document.getElementById('banModal').classList.remove('open')">Cancel</button>
                    <button type="submit" class="btn" style="background:#dc2626; color:white;">Confirm Ban / Suspend</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openBanModal(userId, username) {
            document.getElementById('banTargetUsername').textContent = '@' + username;
            document.getElementById('banForm').action = '${pageContext.request.contextPath}/admin/users/' + userId + '/ban';
            document.getElementById('banModal').classList.add('open');
        }

        function openProfileInspector(button) {
            const name = button.getAttribute('data-name') || 'No Name Attached';
            const username = button.getAttribute('data-username');
            const gender = button.getAttribute('data-gender') || 'N/A';
            const bio = button.getAttribute('data-bio') || 'No biography compiled yet.';
            const hasAvatar = button.getAttribute('data-hasavatar') === 'true';
            const fallbackLetter = button.getAttribute('data-letter') || 'U';
            const status = button.getAttribute('data-status') || 'N/A';
            const email = button.getAttribute('data-email') || 'N/A';
            const role = button.getAttribute('data-role') || 'N/A';

            document.getElementById('modalName').textContent = name;
            document.getElementById('modalUsername').textContent = username ? "@" + username : "@User";
            document.getElementById('modalBio').textContent = `"${bio}"`;
            
            document.getElementById('modalGender').textContent = gender;
            document.getElementById('modalStatus').textContent = status;
            document.getElementById('modalEmail').textContent = email;
            document.getElementById('modalRole').textContent = role;
            
            const avatarSlot = document.getElementById('modalAvatarSlot');
            avatarSlot.innerHTML = ""; 
            
            if (hasAvatar) {
                const currentRow = button.closest('tr');
                const workingTableImg = currentRow ? currentRow.querySelector('.mini-avatar') : null;
                if (workingTableImg) {
                    const clonedImg = workingTableImg.cloneNode(true);
                    clonedImg.className = "modal-avatar"; 
                    avatarSlot.appendChild(clonedImg);
                } else {
                    avatarSlot.innerHTML = `<div class="modal-avatar-letter">${fallbackLetter}</div>`;
                }
            } else {
                avatarSlot.innerHTML = `<div class="modal-avatar-letter">${fallbackLetter}</div>`;
            }
            
            document.getElementById('inspectorModal').classList.add('open');
        }
        
        function closeProfileInspector(event) {
            if (event.target.classList.contains('modal-mask')) {
                document.getElementById('inspectorModal').classList.remove('open');
            }
        }
        
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                document.getElementById('inspectorModal').classList.remove('open');
                document.getElementById('banModal').classList.remove('open');
            }
        });
    </script>

</body>
</html>