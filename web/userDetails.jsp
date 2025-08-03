<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Details - Stimulation Exam</title>
    <style>
        /* Định dạng tổng thể */
        body {
            display: flex;
            flex-direction: column;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }

        html, body {
            height: 100%;
        }

        /* Sidebar */
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
       
        .sidebar ul {
            list-style: none;
            padding: 0;
            margin-top: 100px;
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

        /* Nội dung chính */
        main {
            flex-grow: 1;
            padding: 20px;
            margin-left: 240px;
        }

        /* Header */
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            border-radius: 8px;
            color: white;
            background-color: #277AB0;
            margin-bottom: 30px;
        }

        .logo {
            font-size: 1.8rem;
            font-weight: bold;
            color: white;
        }

        /* Back button */
        .back-btn {
            background-color: #95a5a6;
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 16px;
            display: inline-block;
        }

        /* User Details Card */
        .user-details-card {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            max-width: 800px;
            margin: 0 auto;
        }

        .card-header {
            background: linear-gradient(135deg, #2980b9, #3498db);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .avatar-container {
            margin-bottom: 20px;
        }

        .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            background-color: #ecf0f1;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            font-size: 48px;
            font-weight: bold;
            color: #34495e;
        }

        .user-name {
            font-size: 28px;
            font-weight: bold;
            margin: 0;
        }

        .user-id {
            font-size: 16px;
            opacity: 0.9;
            margin: 5px 0 0 0;
        }

        .card-body {
            padding: 40px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
        }

        .info-label {
            font-size: 14px;
            font-weight: bold;
            color: #7f8c8d;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
        }

        .info-value {
            font-size: 18px;
            color: #2c3e50;
            font-weight: 500;
            padding: 12px 16px;
            background-color: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #3498db;
        }

        /* Status badge */
        .status-badge {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .status-active {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* Role badge */
        .role-badge {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .role-admin {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        .role-customer {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        .role-teacher {
            background-color: #e2e3e5;
            color: #383d41;
            border: 1px solid #d6d8db;
        }

        /* Gender display */
        .gender-display {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .gender-icon {
            font-size: 20px;
        }

        /* Action buttons */
        .action-buttons {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 15px;
            margin-top: 30px;
            padding-top: 30px;
            border-top: 1px solid #ecf0f1;
            width: 100%;
            text-align: center;
        }

        /* Logout button styling */
        .logout-container {
            position: absolute;
            bottom: 70px;
            width: calc(100% - 40px);
        }

        .logout-btn {
            color: white;
            text-decoration: none;
            display: block;
            padding: 10px;
            background-color: #e74c3c;
            border-radius: 5px;
            text-align: center;
            transition: background-color 0.3s ease;
            font-size: 16px;
        }

        .logout-btn:hover {
            background-color: #c0392b;
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .info-grid {
                grid-template-columns: 1fr;
            }
            
            main {
                margin-left: 0;
                padding: 10px;
            }
            
            .sidebar {
                transform: translateX(-100%);
            }
        }
        
        /* Inline edit form styles */
        .inline-edit-form {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .inline-edit-form select {
            padding: 8px 12px;
            border: 2px solid #3498db;
            border-radius: 6px;
            font-size: 14px;
            background-color: white;
            min-width: 120px;
        }

        .inline-edit-form .btn-save-inline {
            background-color: #27ae60;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }

        .inline-edit-form .btn-cancel-inline {
            background-color: #e74c3c;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            text-decoration: none;
            display: inline-block;
        }

        .edit-link {
            color: #3498db;
            text-decoration: none;
            font-size: 14px;
            margin-left: 10px;
        }

        .edit-link:hover {
            color: #2980b9;
            text-decoration: underline;
        }
        .role-courseContent {
            background-color: #e8f5e8;
            color: #2d5016;
            border: 1px solid #c3e6c3;
        }

        .role-mkt {
            background-color: #fff0e6;
            color: #8b4513;
            border: 1px solid #ffd4b3;
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <nav class="sidebar" id="sidebar">
        <ul>
            <li><a href="${pageContext.request.contextPath}/userlist">User List</a></li>
            <li><a href="${pageContext.request.contextPath}/settinglist">Setting</a></li>
        </ul>

        <!-- Logout button at the bottom -->
        <div class="logout-container">
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                🔓 Logout
            </a>
        </div>
    </nav>

    <main>
        <!-- Header -->
        <header>
            <div class="logo">
                <img src="${pageContext.request.contextPath}/IMAGE/WEB-logo.png" alt="Logo" style="height: 90px; vertical-align: middle; margin-right: 8px;">
                User Details
            </div>
        </header>

        <!-- Thông báo thành công/lỗi -->
        <c:if test="${not empty successMessage}">
            <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
                ${successMessage}
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #f5c6cb;">
                ${errorMessage}
            </div>
        </c:if>
            
        <!-- User Details Card -->
        <div class="user-details-card">
            <!-- Card Header with Avatar -->
            <div class="card-header">
                <div class="avatar-container">
                    <div class="avatar">
                        <c:choose>
                            <c:when test="${not empty profile.avatar}">
                                <img src="${pageContext.request.contextPath}/avatar/${profile.avatar}" 
                                     alt="User Avatar" 
                                     style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
                            </c:when>
                            <c:when test="${not empty user.fullName}">
                                ${user.fullName.substring(0,1).toUpperCase()}
                            </c:when>
                            <c:otherwise>
                                ?
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <h1 class="user-name">${user.fullName}</h1>
                <p class="user-id">User ID: #${user.id}</p>
            </div>

            <div class="card-body">
                <div class="info-grid">
                    <!-- Full Name -->
                    <div class="info-item">
                        <div class="info-label">Full Name</div>
                        <div class="info-value">${user.fullName}</div>
                    </div>

                    <!-- Gender -->
                    <div class="info-item">
                        <div class="info-label">Gender</div>
                        <div class="info-value">
                            <div class="gender-display">
                                <c:choose>
                                    <c:when test="${user.gender == 0}">
                                        <span class="gender-icon">♀</span>
                                        <span>Female</span>
                                    </c:when>
                                    <c:when test="${user.gender == 1}">
                                        <span class="gender-icon">♂</span>
                                        <span>Male</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="gender-icon">?</span>
                                        <span>Unknown</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Email -->
                    <div class="info-item">
                        <div class="info-label">Email Address</div>
                        <div class="info-value">
                            <a href="mailto:${user.email}" style="color: #3498db; text-decoration: none;">
                                ${user.email}
                            </a>
                        </div>
                    </div>

                    <!-- Mobile -->
                    <div class="info-item">
                        <div class="info-label">Mobile Phone</div>
                        <div class="info-value">
                            <a href="tel:${user.mobile}" style="color: #3498db; text-decoration: none;">
                                ${user.mobile}
                            </a>
                        </div>
                    </div>

                    <!-- Role -->
                    <div class="info-item">
                        <div class="info-label">Role</div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${param.editRole == 'true'}">
                                    <!-- Form edit role -->
                                    <form method="post" action="${pageContext.request.contextPath}/userdetails" class="inline-edit-form">
                                        <input type="hidden" name="action" value="updateRole">
                                        <input type="hidden" name="userId" value="${user.id}">
                                        <select name="role" required>
                                            <option value="admin" ${user.role == 'admin' ? 'selected' : ''}>Admin</option>
                                            <option value="customer" ${user.role == 'customer' ? 'selected' : ''}>Customer</option>
                                            <option value="courseContent" ${user.role == 'courseContent' ? 'selected' : ''}>Course Content</option>
                                            <option value="mkt" ${user.role == 'mkt' ? 'selected' : ''}>Marketing</option>
                                        </select>
                                        <button type="submit" class="btn-save-inline">Save</button>
                                        <a href="${pageContext.request.contextPath}/userdetails?id=${user.id}" class="btn-cancel-inline">Cancel</a>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <!-- Hiển thị role -->
                                    <c:choose>
                                       <c:when test="${user.role == 'admin'}">
                                           <span class="role-badge role-admin">Admin</span>
                                       </c:when>
                                       <c:when test="${user.role == 'customer'}">
                                           <span class="role-badge role-customer">Customer</span>
                                       </c:when>
                                       <c:when test="${user.role == 'courseContent'}">
                                           <span class="role-badge role-courseContent">Course Content</span>
                                       </c:when>
                                       <c:when test="${user.role == 'mkt'}">
                                           <span class="role-badge role-mkt">Marketing</span>
                                       </c:when>
                                       <c:otherwise>
                                           <span class="role-badge">${user.role}</span>
                                       </c:otherwise>
                                   </c:choose>
                                    <a href="${pageContext.request.contextPath}/userdetails?id=${user.id}&editRole=true" class="edit-link">✏️ Edit</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Status -->
                    <div class="info-item">
                    <div class="info-label">Account Status</div>
                    <div class="info-value">
                        <c:choose>
                            <c:when test="${param.editStatus == 'true'}">
                                <!-- Form edit status -->
                                <form method="post" action="${pageContext.request.contextPath}/userdetails" class="inline-edit-form">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="userId" value="${user.id}">
                                    <select name="status" required>
                                        <option value="active" ${user.status == 'active' ? 'selected' : ''}>Active</option>
                                        <option value="inactive" ${user.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                                    </select>
                                    <button type="submit" class="btn-save-inline">Save</button>
                                    <a href="${pageContext.request.contextPath}/userdetails?id=${user.id}" class="btn-cancel-inline">Cancel</a>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <!-- Hiển thị status -->
                                <c:choose>
                                    <c:when test="${user.status == 'active'}">
                                        <span class="status-badge status-active">Active</span>
                                    </c:when>
                                    <c:when test="${user.status == 'inactive'}">
                                        <span class="status-badge status-inactive">Inactive</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge">${user.status}</span>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${pageContext.request.contextPath}/userdetails?id=${user.id}&editStatus=true" class="edit-link">✏️ Edit</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/userlist" class="back-btn">
                        ← Back to List
                    </a>
                </div>
            </div>
        </div>
    </main>

    <script>
        // Thêm hiệu ứng fade in cho card
        document.addEventListener('DOMContentLoaded', function() {
            const card = document.querySelector('.user-details-card');
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            
            setTimeout(() => {
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, 100);
        });
    </script>

</body>
</html>