<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>👥 Create Group Chat</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        :root {
            --bg-main: #ffffff;
            --panel-bg: #ffffff;
            --border-clean: #e5e7eb;
            --accent-black: #111111;
            --accent-gray: #f5f6f6;
            --text-main: #111111;
            --text-muted: #707579;
            --error-color: #ef4444;
            --success-color: #00c853;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body { 
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; 
            background: #fafafa; 
            color: var(--text-main); 
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Topbar Header matching chat.jsp & room.jsp */
        .topbar { 
            background: var(--accent-black); 
            color: #ffffff; 
            padding: 14px 20px; 
            display: flex; 
            align-items: center; 
            gap: 16px; 
            border-bottom: 1px solid var(--accent-black);
            z-index: 10;
        }

        .back-btn { 
            color: #ffffff; 
            text-decoration: none; 
            font-size: 20px; 
            width: 34px; 
            height: 34px; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            border-radius: 50%; 
            transition: background 0.2s; 
        }

        .back-btn:hover { background: rgba(255, 255, 255, 0.15); }

        .topbar-title {
            font-size: 18px;
            font-weight: 600;
            color: #ffffff;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Container Layout */
        .main-container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 30px 16px;
        }

        .card { 
            background: var(--panel-bg); 
            padding: 30px; 
            border-radius: 16px; 
            border: 1px solid var(--border-clean);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05); 
            width: 100%; 
            max-width: 520px; 
        }

        .card-header {
            margin-bottom: 24px;
        }

        .card-header h2 { 
            font-size: 22px; 
            font-weight: 700; 
            color: var(--text-main); 
            margin-bottom: 6px; 
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .card-header p { 
            color: var(--text-muted); 
            font-size: 14px; 
            line-height: 1.4;
        }

        .form-group { 
            margin-bottom: 20px; 
            position: relative;
        }

        label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: 600; 
            color: var(--text-main); 
            font-size: 14px; 
        }

        .input-field { 
            width: 100%; 
            padding: 12px 16px; 
            border: 1px solid var(--border-clean); 
            border-radius: 12px; 
            font-size: 14px; 
            font-family: inherit;
            outline: none; 
            background: var(--accent-gray);
            color: var(--text-main);
            transition: all 0.2s ease;
        }

        .input-field:focus { 
            border-color: var(--accent-black);
            background: #ffffff;
        }

        /* Member Search Dropdown */
        .search-container {
            position: relative;
        }

        .search-results { 
            position: absolute; 
            left: 0; 
            right: 0; 
            top: calc(100% + 6px); 
            background: #ffffff; 
            border-radius: 12px; 
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15); 
            z-index: 50; 
            display: none; 
            max-height: 260px; 
            overflow-y: auto; 
            border: 1px solid var(--border-clean);
        }

        .search-item { 
            display: flex; 
            align-items: center; 
            gap: 12px; 
            padding: 10px 14px; 
            cursor: pointer; 
            border-bottom: 1px solid var(--accent-gray); 
            transition: background 0.15s;
        }

        .search-item:last-child { border-bottom: none; }
        .search-item:hover { background: var(--accent-gray); }

        .avatar { 
            width: 36px; 
            height: 36px; 
            border-radius: 50%; 
            background: #dfe5e7; 
            color: #54656f; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-weight: 700; 
            font-size: 14px; 
            flex-shrink: 0; 
        }

        .badge-admin { 
            background: var(--accent-black); 
            color: #ffffff; 
            font-size: 10px; 
            padding: 2px 6px; 
            border-radius: 6px; 
            margin-left: 6px; 
        }

        .badge-user { 
            background: var(--accent-gray); 
            color: var(--text-main); 
            font-size: 10px; 
            padding: 2px 6px; 
            border-radius: 6px; 
            margin-left: 6px; 
        }

        /* Selected Member Chips Container */
        .chips-container {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 10px;
            min-height: 40px;
            padding: 8px;
            border: 1px dashed var(--border-clean);
            border-radius: 12px;
            background: #fafafa;
            align-items: center;
        }

        .chips-empty-hint {
            font-size: 13px;
            color: var(--text-muted);
            padding: 4px 8px;
        }

        .member-chip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #ffffff;
            border: 1px solid var(--border-clean);
            padding: 4px 10px 4px 6px;
            border-radius: 20px;
            font-size: 13px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.03);
            animation: fadeIn 0.15s ease-out;
        }

        .chip-avatar {
            width: 24px;
            height: 24px;
            font-size: 11px;
            background: var(--accent-black);
            color: #ffffff;
        }

        .chip-name {
            font-weight: 500;
            color: var(--text-main);
        }

        .chip-username {
            font-size: 11px;
            color: var(--text-muted);
            margin-left: 2px;
        }

        .chip-remove {
            background: transparent;
            border: none;
            color: var(--text-muted);
            font-size: 16px;
            line-height: 1;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            transition: all 0.15s;
            margin-left: 2px;
        }

        .chip-remove:hover {
            background: var(--error-color);
            color: #ffffff;
        }

        /* Button & Errors */
        .btn-submit { 
            width: 100%; 
            background: var(--accent-black); 
            color: #ffffff; 
            border: none; 
            padding: 14px; 
            border-radius: 12px; 
            font-weight: 600; 
            font-size: 15px; 
            font-family: inherit;
            cursor: pointer; 
            margin-top: 10px; 
            transition: opacity 0.2s; 
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-submit:hover { opacity: 0.9; }

        .error-msg { 
            color: var(--error-color); 
            background: #fef2f2; 
            padding: 12px 16px; 
            border-radius: 10px; 
            font-size: 14px; 
            margin-bottom: 20px; 
            border: 1px solid #fecaca; 
            display: flex;
            align-items: center;
            gap: 8px;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }
    </style>
</head>
<body>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="topbar">
    <a href="${ctx}/chat" class="back-btn" title="Back to Inbox">←</a>
    <div class="topbar-title">
        👥 Create Group Chat
    </div>
</div>

<div class="main-container">
    <div class="card">
        <div class="card-header">
            <h2>👥 New Group Chat</h2>
            <p>Enter a group name and search for members to add</p>
        </div>

        <c:if test="${not empty error}">
            <div class="error-msg">
                <span>⚠️</span>
                <span><c:out value="${error}"/></span>
            </div>
        </c:if>

        <form action="${ctx}/chat/create-group" method="POST" id="createGroupForm">
            <div class="form-group">
                <label for="title">Group Name</label>
                <input type="text" id="title" name="title" class="input-field" placeholder="e.g. Study Group, CS Team" required autocomplete="off">
            </div>

            <div class="form-group search-container">
                <label for="memberSearch">Search and Select Members</label>
                <input type="text" id="memberSearch" class="input-field" placeholder="🔍 Type member name or username..." autocomplete="off">
                <div id="searchResults" class="search-results"></div>
            </div>

            <div class="form-group">
                <label>Selected Members (<span id="memberCount">0</span>)</label>
                <div id="chipsContainer" class="chips-container">
                    <span id="emptyHint" class="chips-empty-hint">No members selected yet. Type in the search box above to find and select members...</span>
                </div>
            </div>

            <!-- Hidden Input for Form Submit -->
            <input type="hidden" id="usernames" name="usernames" value="" required>

            <button type="submit" class="btn-submit">
                <span>➕ Create Group</span>
            </button>
        </form>
    </div>
</div>

<script>
    const ctx = '${ctx}';
    let searchTimer;
    let selectedMembers = []; // Array of objects: { id, username, displayName }

    $(document).ready(function() {
        $('#memberSearch').on('input', function() {
            clearTimeout(searchTimer);
            const q = $(this).val().trim();
            if (q.length < 1) {
                $('#searchResults').hide().empty();
                return;
            }
            searchTimer = setTimeout(function() { searchUsers(q); }, 200);
        });

        // Hide search dropdown on click outside
        $(document).click(function(e) {
            if (!$(e.target).closest('.search-container').length) {
                $('#searchResults').hide();
            }
        });

        // Form validation before submit
        $('#createGroupForm').submit(function(e) {
            updateHiddenUsernamesInput();
            if (selectedMembers.length < 1) {
                alert('Please select at least 1 member.');
                e.preventDefault();
                return false;
            }
        });
    });

    function searchUsers(keyword) {
        $.get(ctx + '/api/chat/users/search', { q: keyword }, function(users) {
            const box = $('#searchResults').empty();
            if (!users || !users.length) {
                box.append('<div class="search-item" style="cursor:default;color:var(--text-muted);font-size:13px;justify-content:center;">No results found</div>').show();
                return;
            }

            users.forEach(function(user) {
                // If already selected, skip or show selected state
                const isAlreadySelected = selectedMembers.some(m => String(m.username) === String(user.username));
                if (isAlreadySelected) return;

                const badge = user.role === 'ADMIN'
                    ? '<span class="badge-admin">Admin</span>'
                    : '<span class="badge-user">User</span>';
                const displayName = user.displayName || user.username;
                
                const row = $('<div class="search-item"></div>');
                row.html(
                    '<div class="avatar">' + displayName.charAt(0).toUpperCase() + '</div>' +
                    '<div style="font-size:14px;flex:1;">' +
                        '<strong>' + escapeHtml(displayName) + '</strong> ' + badge +
                        '<div style="font-size:12px;color:var(--text-muted);">@' + escapeHtml(user.username) + '</div>' +
                    '</div>'
                );

                row.click(function() {
                    addMember(user);
                    $('#memberSearch').val('');
                    box.hide().empty();
                });
                box.append(row);
            });

            if (box.children().length === 0) {
                box.append('<div class="search-item" style="cursor:default;color:var(--text-muted);font-size:13px;justify-content:center;">Already selected</div>');
            }

            box.show();
        });
    }

    function addMember(user) {
        const username = user.username;
        const displayName = user.displayName || username;

        if (selectedMembers.some(m => String(m.username) === String(username))) return;

        selectedMembers.push({
            id: user.id,
            username: username,
            displayName: displayName
        });

        renderChips();
    }

    function removeMember(username) {
        selectedMembers = selectedMembers.filter(m => String(m.username) !== String(username));
        renderChips();
    }

    function renderChips() {
        const container = $('#chipsContainer').empty();
        $('#memberCount').text(selectedMembers.length);

        if (selectedMembers.length === 0) {
            container.append('<span id="emptyHint" class="chips-empty-hint">No members selected yet. Type in the search box above to find and select members...</span>');
            updateHiddenUsernamesInput();
            return;
        }

        selectedMembers.forEach(function(m) {
            const chip = $('<div class="member-chip"></div>');
            const initial = m.displayName.charAt(0).toUpperCase();
            chip.html(
                '<div class="avatar chip-avatar">' + initial + '</div>' +
                '<span class="chip-name">' + escapeHtml(m.displayName) + '</span>' +
                '<span class="chip-username">(@' + escapeHtml(m.username) + ')</span>' +
                '<button type="button" class="chip-remove" title="Remove">&times;</button>'
            );

            chip.find('.chip-remove').click(function(e) {
                e.stopPropagation();
                removeMember(m.username);
            });

            container.append(chip);
        });

        updateHiddenUsernamesInput();
    }

    function updateHiddenUsernamesInput() {
        const usernamesStr = selectedMembers.map(m => m.username).join(',');
        $('#usernames').val(usernamesStr);
    }

    function escapeHtml(text) {
        return $('<div/>').text(text).html();
    }
</script>

</body>
</html>
