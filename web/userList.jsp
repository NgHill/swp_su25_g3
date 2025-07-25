<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stimulation Exam</title>
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

        .add-btn {
            background-color: #27ae60;
            color: white;
            text-decoration: none;
            padding: 10px 16px;
            border-radius: 5px;
            font-size: 16px;
            display: inline-block;
        }

        .add-btn:hover {
            background-color: #2ecc71;
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

        }

        /* Khu vực chứa hai nút xanh */
        .controls {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin: 20px 0;
        }

        /* Nút liên kết trong .controls */
        .controls a {
            font-size: 16px;
            background-color: #27ae60;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
            transition: background-color 0.3s ease;
        }

        .controls a:hover {
            background-color: #2ecc71;
        }

        /* Bảng dữ liệu */
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #2980b9;
            color: white;
        }

        tr:hover {
            background-color: #f2f2f2;
        }

        /* Nút chỉnh sửa */
        button.action {
            background-color: #27ae60;
            color: white;
            padding: 8px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button.action:hover {
            background-color: #2ecc71;
        }

        /* Ô tìm kiếm */
        .search-box {
            display: flex;
            align-items: center;
            background-color: white;
            padding: 10px;
            border-radius: 25px;
            border: 2px solid #003366;
            box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.2);
            width: 300px;
        }

        .search-box input[type="search"] {
            flex: 1;
            padding: 10px;
            border: none;
            border-radius: 25px;
            outline: none;
            font-size: 16px;
        }

        /* Nút tìm kiếm */
        .search-button {
            background-color: #003366;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 25px;
            cursor: pointer;
            font-size: 16px;
            margin-left: 8px;
        }

        .search-button:hover {
            background-color: #0056b3;
        }

        /* Bao bọc ô tìm kiếm để định vị dropdown */
        .search-container {
            position: relative;
        }

        /* Nút mũi tên dropdown */
        .dropdown-toggle {
            background-color: white;
            border: none;
            cursor: pointer;
            font-size: 18px;
            padding-left: 10px;
            text-decoration: none;
            color: #003366;
        }

        /* Dropdown menu */
        .dropdown-menu {
            display: none;
            position: absolute;
            top: calc(100% + 5px);
            right: 0;
            width: 250px;
            background-color: white;
            border: 2px solid #003366;
            border-radius: 5px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
            padding: 10px;
            z-index: 100;
        }

        .dropdown-menu.visible {
            display: block;
        }

        .dropdown-menu ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .dropdown-menu li {
            padding: 12px;
            border-bottom: 1px solid #f4f4f4;
            font-size: 16px;
        }

        .dropdown-menu li:last-child {
            border-bottom: none;
        }

        .dropdown-menu li a {
            text-decoration: none;
            color: #003366;
            display: block;
        }

        .dropdown-menu li:hover {
            background-color: #f4f4f4;
        }
        .filter-dropdown {
          position: relative;
          display: inline-block;
        }

        .filter-btn {
          padding: 5px 10px;
          cursor: pointer;
          margin-bottom: 30px;
        }

        .filter-content {
          display: none;
          position: absolute;
          top: 35px;
          left: 0;
          background-color: white;
          border: 1px solid #3498db;
          padding: 10px;
          border-radius: 5px;
          z-index: 1;
          box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
          width: 220px;
        }

        .filter-dropdown:hover .filter-content {
          display: block;
        }

        .filter-content label {
          display: block;
          margin-bottom: 10px;
          font-size: 14px;
        }

        .filter-content input {
          width: 100%;
          padding: 5px;
          margin-top: 2px;
          border: 1px solid #ccc;
          border-radius: 3px;
        }

        .view-btn {
            font-size: 16px;            /* Tăng kích thước chữ */
            padding: 10px 20px;         /* Tăng kích thước nút */
            background-color: #2980b9;  /* Màu nền */
            color: white;               /* Màu chữ */
            border: none;               /* Bỏ viền */
            border-radius: 6px;         /* Bo góc */
            cursor: pointer;            /* Con trỏ tay khi hover */
            transition: background-color 0.3s ease;
        }

        .view-btn:hover {
            background-color: #1f6391;  /* Màu khi di chuột vào */
        }

        .edit-btn {
            font-size: 16px;            /* Tăng kích thước chữ */
            padding: 10px 20px;         /* Tăng kích thước nút */
            background-color: #2980b9;  /* Màu nền */
            color: white;               /* Màu chữ */
            border: none;               /* Bỏ viền */
            border-radius: 6px;         /* Bo góc */
            cursor: pointer;            /* Con trỏ tay khi hover */
            transition: background-color 0.3s ease;
        }

        .edit-btn:hover {
            background-color: #1f6391;  /* Màu khi di chuột vào */
        }

        /* Thêm vào cuối phần CSS hiện có */
        .sortable-header {
            cursor: pointer;
            position: relative;
            user-select: none;
            transition: background-color 0.2s ease;
        }

        .sortable-header:hover {
            background-color: #1f6391;
        }

        .sort-arrow {
            margin-left: 5px;
            font-size: 12px;
            color: #fff;
        }

        .sort-arrow.asc::after {
            content: " ↑";
        }

        .sort-arrow.desc::after {
            content: " ↓";
        }

        /* Style cho link trong header */
        th a.sortable-header {
            color: white;
            text-decoration: none;
            display: block;
            padding: 12px;
            margin: -12px;
        }

        th a.sortable-header:hover {
            color: white;
            text-decoration: none;
        }

        /* Modal/Popup styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 20px;
            border-radius: 8px;
            width: 500px;
            max-width: 90%;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover {
            color: black;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        .form-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }

        .btn-save {
            background-color: #27ae60;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-cancel {
            background-color: #95a5a6;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        
        .error-message {
            color: #e74c3c;
            font-size: 12px;
            margin-top: 5px;
            display: block;
        }
        
        .logo {
                font-size: 1.8rem;
                font-weight: bold;
                color: white;
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
                    User List
                </div>
                <div class="search-container">
                    <form method="get" action="${pageContext.request.contextPath}/userlist" class="search-box">
                        <input type="search" name="search" placeholder="Search name, email or mobile..." value="${search}">

                        <input type="hidden" name="genderFilter" value="${genderFilter}" />
                        <input type="hidden" name="roleFilter" value="${roleFilter}" />
                        <input type="hidden" name="statusFilter" value="${statusFilter}" />

                        <button class="search-button" type="submit">🔍</button>
                    </form>
                </div>
            </header>

            <!-- Filter by Gender -->
            <div class="filter-dropdown">
                <button type="button" class="filter-btn" onclick="toggleFilter('filterGender')">Filter by Gender ▼</button>
                <div class="filter-content" id="filterGender" style="display:none;">
                    <form method="get" action="${pageContext.request.contextPath}/userlist">
                        <label>
                            <div>Gender:</div>
                            <select name="genderFilter">
                                <option value="A" <c:if test="${genderFilter == 'A' || genderFilter == null}">selected</c:if>>All</option>
                                <option value="0" <c:if test="${genderFilter == '0'}">selected</c:if>>Female</option>
                                <option value="1" <c:if test="${genderFilter == '1'}">selected</c:if>>Male</option>
                            </select>
                        </label>
                            <input type="hidden" name="sortBy" value="${sortBy}" />
                            <input type="hidden" name="sortOrder" value="${sortOrder}" />

                        <button type="submit">Apply</button>
                    </form>
                </div>
            </div>

            <!-- Filter by Role -->
            <div class="filter-dropdown">
                <button type="button" class="filter-btn" onclick="toggleFilter('filterRole')">Filter by Role ▼</button>
                <div class="filter-content" id="filterRole" style="display:none;">
                    <form method="get" action="${pageContext.request.contextPath}/userlist">
                        <label>
                            <div>Role:</div>
                            <select name="roleFilter">
                                <option value="A" <c:if test="${roleFilter == 'A' || roleFilter == null}">selected</c:if>>All</option>
                                <option value="admin" <c:if test="${roleFilter == 'Admin'}">selected</c:if>>Admin</option>
                                <option value="customer" <c:if test="${roleFilter == 'Customer'}">selected</c:if>>Customer</option>
                                <option value="teacher" <c:if test="${roleFilter == 'teacher'}">selected</c:if>>Teacher</option>
                            </select>
                        </label>
                            <input type="hidden" name="sortBy" value="${sortBy}" />
                            <input type="hidden" name="sortOrder" value="${sortOrder}" />

                        <button type="submit">Apply</button>
                    </form>
                </div>
            </div>

            <!-- Filter by Status -->
            <div class="filter-dropdown">
                <button type="button" class="filter-btn" onclick="toggleFilter('filterStatus')">Filter by Status ▼</button>
                <div class="filter-content" id="filterStatus" style="display:none;">
                    <form method="get" action="${pageContext.request.contextPath}/userlist">
                        <label>
                            <div>Status:</div>
                            <select name="statusFilter">
                                <option value="A" <c:if test="${statusFilter == 'A' || statusFilter == null}">selected</c:if>>All</option>
                                <option value="active" <c:if test="${statusFilter == 'active'}">selected</c:if>>Active</option>
                                <option value="inactive" <c:if test="${statusFilter == 'inactive'}">selected</c:if>>Inactive</option>   
                            </select>
                        </label>
                            <input type="hidden" name="sortBy" value="${sortBy}" />
                            <input type="hidden" name="sortOrder" value="${sortOrder}" />

                        <button type="submit">Apply</button>
                    </form>
                </div>
            </div>
            <button class="add-btn" onclick="openAddUserModal()">➕ Add New User</button>

            <div class="line-limit-control">
                <label>
                    Line number displayed:
                    <form method="get" action="${pageContext.request.contextPath}/userlist">
                        <input type="number" name="rowsPerPage" value="${rowsPerPage}" />
                    </form>
                </label>
            </div>               

            <!-- CHECKBOX ẨN/HIỆN CỘT -->
            <div style="margin: 20px 0;">            
                <label><input type="checkbox" data-col="fullname" checked> Full Name</label>
                <label><input type="checkbox" data-col="gender" checked> Gender</label>
                <label><input type="checkbox" data-col="email" checked> Email</label>
                <label><input type="checkbox" data-col="phone" checked> Phone</label>
                <label><input type="checkbox" data-col="role" checked> Role</label>
                <label><input type="checkbox" data-col="status" checked> Status</label>    
            </div>


            <!-- User Table -->
            <div class="table-container">          
                    <table>
                        <thead>
            <tr>
                <th class="col-id">
                    <a href="${pageContext.request.contextPath}/userlist?sortBy=Id&search=${search}&genderFilter=${genderFilter}&roleFilter=${roleFilter}&statusFilter=${statusFilter}" 
                       class="sortable-header">
                        ID
                        <c:if test="${sortBy == 'Id'}">
                            <span class="sort-arrow ${sortOrder}"></span>
                        </c:if>
                    </a>
                </th>
                <th class="col-fullname">
                    <a href="${pageContext.request.contextPath}/userlist?sortBy=FullName&search=${search}&genderFilter=${genderFilter}&roleFilter=${roleFilter}&statusFilter=${statusFilter}" 
                       class="sortable-header">
                        Full Name
                        <c:if test="${sortBy == 'FullName'}">
                            <span class="sort-arrow ${sortOrder}"></span>
                        </c:if>
                    </a>
                </th>
                <th class="col-gender">
                    <a href="${pageContext.request.contextPath}/userlist?sortBy=Gender&search=${search}&genderFilter=${genderFilter}&roleFilter=${roleFilter}&statusFilter=${statusFilter}" 
                       class="sortable-header">
                        Gender
                        <c:if test="${sortBy == 'Gender'}">
                            <span class="sort-arrow ${sortOrder}"></span>
                        </c:if>
                    </a>
                </th>
                <th class="col-email">
                    <a href="${pageContext.request.contextPath}/userlist?sortBy=Email&search=${search}&genderFilter=${genderFilter}&roleFilter=${roleFilter}&statusFilter=${statusFilter}" 
                       class="sortable-header">
                        Email
                        <c:if test="${sortBy == 'Email'}">
                            <span class="sort-arrow ${sortOrder}"></span>
                        </c:if>
                    </a>
                </th>
                <th class="col-phone">
                    <a href="${pageContext.request.contextPath}/userlist?sortBy=Mobile&search=${search}&genderFilter=${genderFilter}&roleFilter=${roleFilter}&statusFilter=${statusFilter}" 
                       class="sortable-header">
                        Phone
                        <c:if test="${sortBy == 'Mobile'}">
                            <span class="sort-arrow ${sortOrder}"></span>
                        </c:if>
                    </a>
                </th>
                <th class="col-role">
                    <a href="${pageContext.request.contextPath}/userlist?sortBy=Role&search=${search}&genderFilter=${genderFilter}&roleFilter=${roleFilter}&statusFilter=${statusFilter}" 
                       class="sortable-header">
                        Role
                        <c:if test="${sortBy == 'Role'}">
                            <span class="sort-arrow ${sortOrder}"></span>
                        </c:if>
                    </a>
                </th>
                <th class="col-status">
                    <a href="${pageContext.request.contextPath}/userlist?sortBy=Status&search=${search}&genderFilter=${genderFilter}&roleFilter=${roleFilter}&statusFilter=${statusFilter}" 
                       class="sortable-header">
                        Status
                        <c:if test="${sortBy == 'Status'}">
                            <span class="sort-arrow ${sortOrder}"></span>
                        </c:if>
                    </a>
                </th>
                <th class="col-action">Action</th>
            </tr>
        </thead>
                    <tbody>
                        <c:forEach items="${userLists}" var="u">
                            <tr>
                                <td class="col-id"> ${u.id}</td>
                                <td class="col-fullname">${u.fullName}</td>
                                <td class="col-gender">
                                    <c:choose>
                                        <c:when test="${u.gender == 0}">Female</c:when>
                                        <c:when test="${u.gender == 1}">Male</c:when>
                                        <c:otherwise>Unknown</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="col-email">${u.email}</td>
                                <td class="col-phone">${u.mobile}</td>
                                <td class="col-role">${u.role}</td>
                                <td class="col-status">${u.status}</td>
                                <td class="col-action">
                                     <a href="${pageContext.request.contextPath}/userdetails?id=${u.id}" class="view-btn">View</a>
                                     <button onclick="openEditUserModal(${u.id}, '${u.fullName}', '${u.role}', '${u.status}')" class="edit-btn">Edit</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
        </div>
                   
                    <!-- Add User Modal -->
                    <div id="addUserModal" class="modal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h2>Add New User</h2>
                                <span class="close" onclick="closeAddUserModal()">&times;</span>
                            </div>
                            <form id="addUserForm" method="post" action="${pageContext.request.contextPath}/userlist">
                                <div class="form-group">
                                    <label for="fullName">Full Name:</label>
                                    <input type="text" id="fullName" name="fullName" value="${inputFullName}">
                                    <c:if test="${not empty fullNameError}">
                                        <div class="error-message">${fullNameError}</div>
                                    </c:if>
                                </div>

                                <div class="form-group">
                                    <label for="gender">Gender:</label>
                                    <select id="gender" name="gender" required>
                                        <option value="0" ${inputGender == '0' ? 'selected' : ''}>Female</option>
                                        <option value="1" ${inputGender == '1' ? 'selected' : ''}>Male</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="email">Email:</label>
                                    <input type="email" id="email" name="email" value="${inputEmail}">
                                    <c:if test="${not empty emailError}">
                                        <div class="error-message">${emailError}</div>
                                    </c:if>
                                </div>

                                <div class="form-group">
                                    <label for="mobile">Mobile:</label>
                                    <input type="tel" id="mobile" name="mobile" value="${inputMobile}" >
                                    <c:if test="${not empty mobileError}">
                                        <div class="error-message">${mobileError}</div>
                                    </c:if>
                                </div>

                                <div class="form-group">
                                    <label for="role">Role:</label>
                                    <select id="role" name="role" required>
                                        <option value="admin" ${inputRole == 'admin' ? 'selected' : ''}>Admin</option>
                                        <option value="customer" ${inputRole == 'customer' ? 'selected' : ''}>Customer</option>
                                        <option value="teacher" ${inputRole == 'teacher' ? 'selected' : ''}>Teacher</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="status">Status:</label>
                                    <select id="status" name="status" required>
                                        <option value="active" ${inputStatus == 'active' ? 'selected' : ''}>Active</option>
                                        <option value="inactive" ${inputStatus == 'inactive' ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </div>

                                <div class="form-buttons">
                                    <button type="submit" class="btn-save">Save User</button>
                                </div>
                            </form>
                        </div>
                    </div>
            </main>

                     <div id="editUserModal" class="modal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h2>Edit User</h2>
                            </div>
                            <form id="editUserForm" method="post" action="${pageContext.request.contextPath}/userlist">
                                <input type="hidden" name="action" value="edit">
                                <input type="hidden" id="editUserId" name="userId" value="">

                                <div class="form-group">
                                    <label for="editFullName">Full Name:</label>
                                    <input type="text" id="editFullName" name="fullName" readonly style="background-color: #f5f5f5; cursor: not-allowed;">
                                </div>

                                <div class="form-group">
                                    <label for="editRole">Role:</label>
                                    <select id="editRole" name="role" required>
                                        <option value="admin">admin</option>
                                        <option value="customer">customer</option>
                                        <option value="teacher">teacher</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="editStatus">Status:</label>
                                    <select id="editStatus" name="status" required>
                                        <option value="active">active</option>
                                        <option value="inactive">inactive</option>
                                    </select>
                                </div>

                                <div class="form-buttons">
                                    <button type="button" class="btn-cancel" onclick="closeEditUserModal()">Cancel</button>
                                    <button type="submit" class="btn-save">Update User</button>
                                </div>
                            </form>
                        </div>
                    </div>         
                <script>
                    function toggleFilter(id) {                                     // Hàm mở/đóng dropdown lọc theo ID được truyền vào
                        const content = document.getElementById(id);                // Tìm phần tử cần toggle bằng id
                        content.style.display = (content.style.display === 'block') // Nếu đang hiện (block), thì ẩn nó đi
                            ? 'none' 
                            : 'block';                                              // Nếu đang ẩn, thì hiển thị ra
                    }

                    // Đóng dropdown nếu click ra ngoài
                    window.addEventListener('click', function (e) {                 // Lắng nghe sự kiện click toàn màn hình
                        document.querySelectorAll('.filter-content').forEach(content => { // Với mỗi dropdown lọc
                            if (!content.parentElement.contains(e.target)) {        // Nếu click không nằm trong vùng cha chứa dropdown
                                content.style.display = 'none';                     // Thì ẩn dropdown đó đi
                            }
                        });
                    });                  

                    document.querySelectorAll('input[type="checkbox"][data-col]').forEach(cb => { // Duyệt qua tất cả checkbox lọc cột
                        cb.addEventListener('change', () => {                     // Khi người dùng tick/untick checkbox
                            const col = cb.getAttribute('data-col');              // Lấy tên cột cần xử lý (ví dụ: "email", "role")
                            document.querySelectorAll('.col-' + col).forEach(cell => { // Tìm tất cả ô trong cột đó
                                cell.style.display = cb.checked ? '' : 'none';    // Nếu checkbox được tick → hiện, không thì ẩn
                            });
                        });
                    });

                    // Thêm vào cuối script hiện tại
                    function openAddUserModal() {
                        document.getElementById('addUserModal').style.display = 'block';
                    }

                    function closeAddUserModal() {
                        document.getElementById('addUserModal').style.display = 'none';
                        document.getElementById('addUserForm').reset(); // Reset form
                    }

                    // Kiểm tra nếu có lỗi thì mở modal
                    <c:if test="${showAddModal}">
                        document.getElementById('addUserModal').style.display = 'block';
                    </c:if>
                    
                    // Mở Edit User Modal
                    function openEditUserModal(userId, fullName, role, status) {
                        document.getElementById('editUserId').value = userId;
                        document.getElementById('editFullName').value = fullName;
                        document.getElementById('editRole').value = role;
                        document.getElementById('editStatus').value = status;
                        document.getElementById('editUserModal').style.display = 'block';
                    }

                    // Đóng Edit User Modal
                    function closeEditUserModal() {
                        document.getElementById('editUserModal').style.display = 'none';
                        document.getElementById('editUserForm').reset();
                    }

                </script>   
        </body>
</html>
