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

        .sidebar.hidden {
            transform: translateX(-100%);
        }

        .avatar-wrapper {
            width: 60px;
            height: 60px;
            background-color: #95a5a6;
            border-radius: 50%;
            margin: 0 auto 30px;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
        }

        .avatar-img {
            width: 30px;
            height: 30px;
            color: white;
            font-size: 24px;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
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

        /* Khi sidebar ẩn, dịch nội dung chính sang trái */
        .sidebar.hidden + main {
            margin-left: 0;
        }

        /* Khi sidebar ẩn, dịch nội dung chính sang trái */
        .sidebar.hidden + main {
            margin-left: 0;
        }


        /* Nội dung chính */
        main {
            flex-grow: 1;
            padding: 20px;
            margin-left: 240px;
            transition: margin-left 0.3s ease-in-out;
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

        /* Khi sidebar ẩn, dịch nội dung chính sang trái */
        .sidebar.hidden + main {
            margin-left: 0;
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

        /* Nút Toggle Sidebar */
        #toggleSidebar {
            background-color: #34495e;
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            margin-right: 15px;
        }

        #toggleSidebar:hover {
            background-color: #2c3e50;
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


    </style>
</head>
    <body>

    <!-- Sidebar -->
    <nav class="sidebar" id="sidebar">
        <a href="${pageContext.request.contextPath}/profile?id=${userId}">
            <div class="avatar-wrapper">
                <div class="avatar-img">👤</div> 
            </div>
        </a>
        <ul>
            <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/subject">Subject</a></li>
            <li><a href="${pageContext.request.contextPath}/myRegistration">My Registrations</a></li>
            <li><a href="${pageContext.request.contextPath}/settings">Setting</a></li>
        </ul>
    </nav>

    <main>
        <!-- Header -->
        <header>
            <a href="#" id="toggleSidebar">☰ Toggle Sidebar</a>
            <h1>User List</h1>
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
                            <option value="Admin" <c:if test="${roleFilter == 'Admin'}">selected</c:if>>Admin</option>
                            <option value="Customer" <c:if test="${roleFilter == 'Customer'}">selected</c:if>>Customer</option> 
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
                            <option value="Active" <c:if test="${statusFilter == 'Active'}">selected</c:if>>Active</option>
                            <option value="Inactive" <c:if test="${statusFilter == 'Inactive'}">selected</c:if>>Inactive</option>   
                        </select>
                    </label>
                        <input type="hidden" name="sortBy" value="${sortBy}" />
                        <input type="hidden" name="sortOrder" value="${sortOrder}" />
                        
                    <button type="submit">Apply</button>
                </form>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/adduser" class="add-btn">➕ Add New User</a>
        
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
                                    <a href="${pageContext.request.contextPath}/profile" class="edit-btn">Edit</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
        </div>
    </main>

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

                    document.getElementById("toggleSidebar").addEventListener("click", function (e) { // Khi click vào nút Toggle Sidebar
                        e.preventDefault();                                         // Ngăn hành vi mặc định (chuyển hướng trang)
                        document.querySelector(".sidebar").classList.toggle("hidden"); // Bật/tắt class 'hidden' để ẩn/hiện sidebar
                    });

                    document.querySelectorAll('input[type="checkbox"][data-col]').forEach(cb => { // Duyệt qua tất cả checkbox lọc cột
                        cb.addEventListener('change', () => {                     // Khi người dùng tick/untick checkbox
                            const col = cb.getAttribute('data-col');              // Lấy tên cột cần xử lý (ví dụ: "email", "role")
                            document.querySelectorAll('.col-' + col).forEach(cell => { // Tìm tất cả ô trong cột đó
                                cell.style.display = cb.checked ? '' : 'none';    // Nếu checkbox được tick → hiện, không thì ẩn
                            });
                        });
                    });

                    
                </script>   
    </body>
</html>
