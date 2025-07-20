<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">    
    <title>User List</title>
    <style>
        /* RESET & BODY LAYOUT */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            display: flex;
            min-height: 100vh;
        }

        /* SIDEBAR */
        .sidebar {
            width: 200px;
            background-color: #34495e;
            color: white;
            padding: 20px;
            min-height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            transition: transform 0.3s ease-in-out;
        }

        .sidebar.hidden {
            transform: translateX(-100%);
        }

        .sidebar ul {
            list-style: none;
        }

        .sidebar ul li {
            margin: 20px 0;
        }

        .sidebar ul li a {
            color: white;
            text-decoration: none;
            font-size: 16px;
            display: block;
            padding: 10px 0;
        }

        .sidebar ul li a:hover {
            color: #bdc3c7;
        }

        /* MAIN CONTENT */
        main {
            flex: 1;
            margin-left: 200px;
            transition: margin-left 0.3s ease-in-out;
            display: flex;
            flex-direction: column;
        }

        .sidebar.hidden + main {
            margin-left: 0;
        }

        /* HEADER */
        header {
            position: relative;
            background-color: #277AB0;
            color: white;
            padding: 15px 20px;
            height: 60px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        #toggleSidebar {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            background-color: #34495e;
            color: white;
            padding: 8px 12px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 500;
        }

        #toggleSidebar:hover {
            background-color: #2c3e50;
            transform: translateY(-50%) scale(1.05);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }

        .header-title {
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            line-height: 60px;
        }

        /* USER LIST CONTENT */
        .userlist-content {
            flex: 1;
            background-color: #e8e8e8;
            padding: 40px;
            min-height: calc(100vh - 70px);
        }

        .userlist-container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        /* SEARCH AND FILTER */
        .search-filter-section {
            padding: 20px;
            background-color: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }

        .search-filter-row {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }

        .search-group {
            flex: 1;
            min-width: 250px;
        }

        .search-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #bdc3c7;
            border-radius: 4px;
            font-size: 14px;
        }

        .filter-group {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .filter-group select {
            padding: 10px;
            border: 1px solid #bdc3c7;
            border-radius: 4px;
            font-size: 14px;
            background-color: white;
        }

        .search-btn {
            padding: 10px 20px;
            background-color: #277AB0;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }

        .search-btn:hover {
            background-color: #1e5f87;
        }

        /* TABLE */
        .user-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }

        .user-table thead {
            background-color: #34495e;
            color: white;
        }

        .user-table th,
        .user-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }

        .user-table th {
            font-weight: bold;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .user-table tbody tr:hover {
            background-color: #f8f9fa;
        }

        /* AVATAR IN TABLE */
        .user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #3498db;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-details h4 {
            margin: 0 0 5px 0;
            color: #2c3e50;
            font-size: 16px;
        }

        .user-details p {
            margin: 0;
            color: #7f8c8d;
            font-size: 14px;
        }

        /* STATUS BADGES */
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-active {
            background-color: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        /* ROLE BADGES */
        .role-badge {
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .role-admin {
            background-color: #dc3545;
            color: white;
        }

        .role-teacher {
            background-color: #28a745;
            color: white;
        }

        .role-student {
            background-color: #007bff;
            color: white;
        }

        /* GENDER ICONS */
        .gender-icon {
            font-size: 16px;
            margin-right: 5px;
        }

        .gender-male {
            color: #3498db;
        }

        .gender-female {
            color: #e91e63;
        }

        .gender-other {
            color: #95a5a6;
        }

        /* ACTION BUTTONS */
        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-view {
            background-color: #17a2b8;
            color: white;
        }

        .btn-edit {
            background-color: #ffc107;
            color: #212529;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
        }

        .btn:hover {
            opacity: 0.8;
            transform: translateY(-1px);
        }

        /* PAGINATION */
        .pagination {
            padding: 20px;
            text-align: center;
            background-color: #f8f9fa;
            border-top: 1px solid #dee2e6;
        }

        .pagination a,
        .pagination span {
            display: inline-block;
            padding: 8px 12px;
            margin: 0 4px;
            text-decoration: none;
            border: 1px solid #dee2e6;
            color: #277AB0;
            border-radius: 4px;
        }

        .pagination a:hover {
            background-color: #e9ecef;
        }

        .pagination .current {
            background-color: #277AB0;
            color: white;
            border-color: #277AB0;
        }

        /* MESSAGE NOTIFICATION */
        .message {
            margin-bottom: 20px;
            padding: 10px 15px;
            border-radius: 4px;
        }

        .message.success {
            background-color: #d4edda;
            color: #155724;
            border-left: 5px solid #28a745;
        }

        .message.error {
            background-color: #f8d7da;
            color: #721c24;
            border-left: 5px solid #dc3545;
        }

        /* RESPONSIVE */
        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                transform: translateX(-100%);
            }

            main {
                margin-left: 0;
            }

            .search-filter-row {
                flex-direction: column;
                align-items: stretch;
            }

            .user-table {
                font-size: 12px;
            }

            .user-table th,
            .user-table td {
                padding: 8px;
            }

            .user-info {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }

            .user-avatar {
                width: 40px;
                height: 40px;
            }
        }

    </style>
</head>
<body>
    <!-- Sidebar -->
    <nav class="sidebar" id="sidebar">
        <ul>
            <li><a href="<%= request.getContextPath() %>/home">Home</a></li>
            <li><a href="<%= request.getContextPath() %>/subject">Subject</a></li>
            <li><a href="<%= request.getContextPath() %>/userlist">User List</a></li>
            <li><a href="<%= request.getContextPath() %>/settings">Setting</a></li>
        </ul>
    </nav>

    <main>
        <!-- Header -->
        <header>
            <a href="#" id="toggleSidebar">☰ Toggle Sidebar</a>
            <h1 class="header-title">User Management</h1>
        </header>

        <!-- User List Content -->
        <div class="userlist-content">
            <div class="userlist-container">
                
                <!-- Search and Filter Section -->
                <div class="search-filter-section">
                    <form class="search-filter-row" method="get" action="<%= request.getContextPath() %>/userlist">
                        <div class="search-group">
                            <input type="text" name="search" placeholder="Search by name, email, or username..." value="${param.search}">
                        </div>
                        <div class="filter-group">
                            <select name="role">
                                <option value="">All Roles</option>
                                <option value="admin" ${param.role == 'admin' ? 'selected' : ''}>Admin</option>
                                <option value="teacher" ${param.role == 'teacher' ? 'selected' : ''}>Teacher</option>
                                <option value="student" ${param.role == 'student' ? 'selected' : ''}>Student</option>
                            </select>
                            <select name="status">
                                <option value="">All Status</option>
                                <option value="active" ${param.status == 'active' ? 'selected' : ''}>Active</option>
                                <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                                <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Pending</option>
                            </select>
                            <button type="submit" class="search-btn">Search</button>
                        </div>
                    </form>
                </div>

                <!-- Success/Error Messages -->
                <c:if test="${not empty message}">
                    <div class="message success">
                        ${message}
                    </div>
                </c:if>
                
                <c:if test="${not empty error}">
                    <div class="message error">
                        ${error}
                    </div>
                </c:if>

                <!-- User Table -->
                <table class="user-table">
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>Contact</th>
                            <th>Gender</th>
                            <th>Role</th>
                            <th>Address</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${userList}">
                            <tr>
                                <!-- User Info (Avatar + Name) -->
                                <td>
                                    <div class="user-info">
                                        <img src="<%= request.getContextPath() %>/${not empty user.avatar ? user.avatar : 'images/default-avatar.png'}" 
                                             alt="Avatar" class="user-avatar">
                                        <div class="user-details">
                                            <h4>${user.fullName}</h4>
                                            <p>@${user.username}</p>
                                        </div>
                                    </div>
                                </td>
                                
                                <!-- Contact Info -->
                                <td>
                                    <div>
                                        <div>${user.email}</div>
                                        <div style="margin-top: 5px; color: #7f8c8d; font-size: 13px;">
                                            ${not empty user.mobile ? user.mobile : 'N/A'}
                                        </div>
                                    </div>
                                </td>
                                
                                <!-- Gender -->
                                <td>
                                    <c:choose>
                                        <c:when test="${user.gender == '1'}">
                                            <span class="gender-icon gender-male">♂</span>Male
                                        </c:when>
                                        <c:when test="${user.gender == '0'}">
                                            <span class="gender-icon gender-female">♀</span>Female
                                        </c:when>
                                        <c:otherwise>
                                            <span class="gender-icon gender-other">⚧</span>Other
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <!-- Role -->
                                <td>
                                    <span class="role-badge role-${user.role}">
                                        ${user.role}
                                    </span>
                                </td>
                                
                                <!-- Address -->
                                <td>
                                    <div style="max-width: 150px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                        ${not empty user.address ? user.address : 'Not provided'}
                                    </div>
                                </td>
                                
                                <!-- Status -->
                                <td>
                                    <span class="status-badge status-${user.status}">
                                        ${user.status}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <!-- Empty state -->
                        <c:if test="${empty userList}">
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 40px; color: #7f8c8d;">
                                    <h3>No users found</h3>
                                    <p>Try adjusting your search criteria</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>

                <!-- Pagination -->
                <div class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="?page=${currentPage - 1}&search=${param.search}&role=${param.role}&status=${param.status}">&laquo; Previous</a>
                    </c:if>
                    
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span class="current">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="?page=${i}&search=${param.search}&role=${param.role}&status=${param.status}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages}">
                        <a href="?page=${currentPage + 1}&search=${param.search}&role=${param.role}&status=${param.status}">Next &raquo;</a>
                    </c:if>
                </div>
            </div>
        </div>
    </main>

    <script>
        document.getElementById("toggleSidebar").addEventListener("click", function (e) {
            e.preventDefault();
            document.querySelector(".sidebar").classList.toggle("hidden");
        });

        // Auto-hide success messages after 3 seconds
        setTimeout(function() {
            const successMessages = document.querySelectorAll('.message.success');
            successMessages.forEach(function(msg) {
                msg.style.display = 'none';
            });
        }, 3000);
    </script>
</body>
</html>