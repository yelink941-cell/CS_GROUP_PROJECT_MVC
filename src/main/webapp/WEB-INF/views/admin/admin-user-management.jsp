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
        
        /* ===== DATA TABLE MANAGEMENT ===== */
        .table-container { 
            background: #ffffff; 
            border-radius: 16px; 
            box-shadow: 0 4px 24px rgba(0,0,0,0.06);
            padding: 0; 
            border: 1px solid #e8edf3; 
            overflow: hidden;
            transition: box-shadow 0.3s ease;
        }
        
        .table-container:hover {
            box-shadow: 0 8px 32px rgba(0,0,0,0.08);
        }
        
        table { 
            width: 100%; 
            border-collapse: collapse; 
            text-align: left; 
        }
        
        th { 
            padding: 16px 20px; 
            background: #f8fafc;
            border-bottom: 2px solid #e8edf3;
            color: #475569; 
            font-weight: 600; 
            text-transform: uppercase; 
            font-size: 11px; 
            letter-spacing: 0.8px;
        }
        
        td { 
            padding: 16px 20px; 
            border-bottom: 1px solid #f1f4f9; 
            font-size: 14px; 
            vertical-align: middle;
            color: #1e293b;
        }
        
        tbody tr {
            transition: background 0.2s ease;
        }
        
        tbody tr:hover {
            background: #f8fafc;
        }
        
        tbody tr:last-child td {
            border-bottom: none;
        }
        
        /* ===== AVATAR RENDERERS ===== */
        .mini-avatar { 
            width: 44px; 
            height: 44px; 
            border-radius: 50%; 
            object-fit: cover; 
            border: 2px solid #e8edf3;
            transition: transform 0.2s ease, border-color 0.2s ease;
        }
        
        .mini-avatar:hover {
            transform: scale(1.05);
            border-color: #3b82f6;
        }
        
        .avatar-letter { 
            width: 44px; 
            height: 44px; 
            border-radius: 50%; 
            background: linear-gradient(135deg, #3b82f6, #6366f1);
            display: inline-flex; 
            align-items: center; 
            justify-content: center; 
            font-weight: 700; 
            color: #fff; 
            font-size: 18px;
            border: 2px solid #e8edf3;
            transition: transform 0.2s ease;
        }
        
        .avatar-letter:hover {
            transform: scale(1.05);
        }
        
        /* ===== FORM FIELDS & SELECTION ===== */
        select { 
            padding: 6px 14px; 
            border: 1.5px solid #d1d9e6; 
            border-radius: 8px; 
            font-size: 13px; 
            color: #1e293b; 
            background-color: #fff; 
            outline: none;
            font-weight: 500;
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

        /* Pagination Button Styling overrides */
        .btn-paginated {
            background: #ffffff;
            color: #475569;
            border: 1px solid #d1d9e6;
            padding: 8px 16px;
            font-size: 13px;
        }
        .btn-paginated:hover {
            background: #f8fafc;
            border-color: #94a3b8;
            transform: translateY(-1px);
        }
        .btn-paginated-active {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: #ffffff;
            border: none;
            padding: 8px 16px;
            font-size: 13px;
        }
        .btn-paginated-active:hover {
            box-shadow: 0 4px 12px rgba(59,130,246,0.3);
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
        
        /* ===== ANIMATION TIMINGS ===== */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .table-container { animation: fadeInUp 0.4s ease; }
        
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: #f1f4f9; border-radius: 10px; }
        ::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background: #94a3b8; }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="sidebar-brand">CheatSheet Admin 👑</div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link">📊 Core Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link active">👥 User Management</a></li>
        </ul>
    </aside>

    <div class="main-workspace">
        <h2>System User Registry & Full Profiles</h2>
        <div class="admin-toolbar" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; gap: 16px; flex-wrap: wrap;">
    
		    <form action="${pageContext.request.contextPath}/admin/users" method="GET" style="display: flex; gap: 10px; flex-grow: 1; max-width: 440px;">
		        <div style="position: relative; width: 100%;">
		            <i class="fas fa-search" style="position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 14px;"></i>
		            <input type="text" name="search" value="<%= request.getParameter("search") != null ? request.getParameter("search").replace("\"", "&quot;") : "" %>" placeholder="Search name, username, or email..." 
		                   style="width: 100%; padding: 11px 16px 11px 42px; border: 1.5px solid #d1d9e6; border-radius: 12px; font-size: 14px; color: #1e293b; outline: none; background-color: #fff; transition: border-color 0.2s;"
		                   onfocus="this.style.borderColor='#3b82f6'" onblur="this.style.borderColor='#d1d9e6'">
		        </div>
		        <button type="submit" class="btn btn-view" style="padding: 11px 22px; font-size: 13px; font-weight: 600; background: linear-gradient(135deg, #3b82f6, #2563eb); color: #fff; border-radius: 12px; height: 100%;">
		            Search
		        </button>
		    </form>
		
		    <% if(request.getParameter("search") != null && !request.getParameter("search").trim().isEmpty()) { %>
		        <div>
		            <a href="${pageContext.request.contextPath}/admin/users" class="btn" style="background: #e2e8f0; color: #475569; border-radius: 10px; padding: 10px 16px;">
		                <i class="fas fa-times"></i> Clear Search
		            </a>
		        </div>
		    <% } %>
		</div>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Photo</th>
                        <th>Account Details</th>
                        <th>Full Name</th>
                        <th>Gender</th>
                        <th>Account Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<User> users = (List<User>) request.getAttribute("users");
                        if(users != null) {
                            for(User u : users) {
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
                            <form id="form-<%= u.getId() %>" action="${pageContext.request.contextPath}/admin/users/update-status" method="POST" style="display:inline;">
                                <input type="hidden" name="userId" value="<%= u.getId() %>" />
                                <input type="hidden" name="role" value="<%= u.getRole().name() %>" />
                                
                                <select name="status">
                                    <option value="ACTIVE" <%= u.getStatus().name().equals("ACTIVE")?"selected":"" %>>ACTIVE</option>
                                    <option value="INACTIVE" <%= u.getStatus().name().equals("INACTIVE")?"selected":"" %>>INACTIVE</option>
                                </select>
                            </form>
                        </td>
                        <td>
                            <div style="display: flex; align-items: center; gap: 4px; flex-wrap: wrap;">
                                <button type="submit" form="form-<%= u.getId() %>" class="btn btn-update">
                                    <i class="fas fa-check-circle"></i> Update
                                </button>
                                
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
        <% 
            } 
        %>
    </div>

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

    <script>
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
            }
        });
    </script>

</body>
</html>