<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My registration list</title>
        <style>
            /* Định dạng tổng thể */
            body {
                display: flex;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f4f4f4;
            }

            /* Sidebar */
            .sidebar {
                width: 180px;
                background: #2c3e50;
                color: white;
                padding: 20px;
                min-height: 100vh;
                position: fixed;
                left: 0;
                top: 0;
                transition: transform 0.3s ease-in-out;
            }


            /* Danh sách sidebar */
            .sidebar ul {
                list-style: none;
                padding: 0;
                padding-top:20px;
            }

            .sidebar ul li {
                margin: 15px 0;
            }

            .sidebar ul li a {
                color: white;
                text-decoration: none;
                font-size: 16px;
                display: block;
                padding: 10px;
                border-radius: 5px;
            }

            .sidebar ul li a:hover {
                /* === Sidebar container === */
                .sidebar {
                    width: 220px;
                    background: #2c3e50;
                    color: white;
                    padding: 20px;
                    position: fixed;
                    top: 0;
                    left: 0;
                    height: 100%;
                    transition: transform 0.3s;
                    z-index: 200;
                }

                .sidebar.hidden {
                    transform: translateX(-100%);
                }

                /* === Sidebar avatar === */
                .sidebar .avatar-wrapper {
                    width: 60px;
                    height: 60px;
                    background-color: #95a5a6;
                    border-radius: 50%;
                    margin: 10px auto 20px;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    cursor: pointer;
                    overflow: hidden;
                }

                .sidebar .avatar-img {
                    width: 50px;
                    height: 50px;
                    border-radius: 50%;
                    object-fit: cover;
                    background-color: transparent;
                }

                .sidebar .avatar-icon {
                    font-size: 24px;
                    color: white;
                }

                /* === Sidebar navigation list === */
                .sidebar ul {
                    list-style: none;
                    padding: 0;
                    margin: 0;
                }

                .sidebar ul li {
                    margin: 15px 0;
                }

                .sidebar ul li a {
                    color: white;
                    text-decoration: none;
                    display: block;
                    padding: 10px;
                    border-radius: 5px;
                    transition: background 0.3s, transform 0.2s;
                }

                /* === Hover effect (không tím) === */
                .sidebar ul li a:hover {
                    background-color: rgba(255, 255, 255, 0.05); /* nhẹ nhàng hiện đại */
                    transform: translateX(5px);
                    color: #ecf0f1;
                }

            }

            /* Nội dung chính */
            main {
                flex-grow: 1;
                padding: 20px;
                margin-left: 240px;
                transition: margin-left 0.3s ease-in-out;

            }


            /* Header */
            header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px;
                border-radius: 8px;
                color: rgb(0, 0, 0);
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
                width: 350px;
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
            a {
                text-decoration: none;
            }
            /* Bao bọc ô tìm kiếm để định vị dropdown */
            .search-container {
                position: relative;
            }

            /* Nút mũi tên dropdown */
            .dropdown-toggle {
                background-color: #ffffff;
                border: 2px solid #003366;
                border-radius: 50px;
                padding: 8px 16px;
                font-size: 16px;
                color: #003366;
                cursor: pointer;
                margin-left: 10px;
                transition: background-color 0.3s;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .dropdown-toggle:hover {
                background-color: #e6f0ff;
            }


            /* Dropdown menu */
            .dropdown-menu {
                display: none;
                position: absolute;
                top: calc(100% + 5px);
                right: 0;
                width: 280px;
                background-color: white;
                border: 2px solid #003366;
                border-radius: 5px;
                box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
                padding: 15px;
                z-index: 100;
            }

            .dropdown-menu.visible {
                display: block;
            }

            .dropdown-menu .filter-section {
                margin-bottom: 15px;
            }

            .dropdown-menu .filter-title {
                font-weight: bold;
                color: #003366;
                margin-bottom: 8px;
                border-bottom: 1px solid #e0e0e0;
                padding-bottom: 5px;
            }

            .dropdown-menu .filter-options {
                max-height: 150px;
                overflow-y: auto;
            }

            .dropdown-menu .filter-item {
                display: flex;
                align-items: center;
                padding: 8px 0;
                font-size: 14px;
            }

            .dropdown-menu .filter-item input[type="checkbox"] {
                margin-right: 8px;
                transform: scale(1.2);
            }

            .dropdown-menu .filter-item label {
                cursor: pointer;
                flex: 1;
            }

            .dropdown-menu .filter-actions {
                display: flex;
                gap: 10px;
                margin-top: 15px;
                padding-top: 10px;
                border-top: 1px solid #e0e0e0;
            }

            .dropdown-menu .btn-clear, .dropdown-menu .btn-apply {
                padding: 8px 16px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 12px;
                flex: 1;
            }

            .dropdown-menu .btn-clear {
                background-color: #e74c3c;
                color: white;
            }

            .dropdown-menu .btn-apply {
                background-color: #27ae60;
                color: white;
            }

            .dropdown-menu .btn-clear:hover {
                background-color: #c0392b;
            }

            .dropdown-menu .btn-apply:hover {
                background-color: #229954;
            }

            /* Active filter indicator */
            .search-box.has-filters {
                border-color: #27ae60;
                box-shadow: 0px 2px 6px rgba(39, 174, 96, 0.3);
            }

            .dropdown-toggle.has-filters {
                color: #27ae60;
                font-weight: bold;
            }

            /* Search results info */
            .search-info {
                margin: 15px 0;
                padding: 10px;
                background-color: #e8f4fd;
                border-left: 4px solid #3498db;
                border-radius: 4px;
                font-size: 14px;
                color: #2c3e50;
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
                overflow: hidden;
                margin-top: 30px;
            }

            .avatar-img {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                object-fit: cover;
                background-color: transparent;
            }

            .avatar-wrapper .avatar-icon {
                font-size: 24px;
                color: white;
            }
            /* === Sidebar container === */
            .sidebar {
                position: fixed;
                top: 0;
                left: 0;
                width: 180px;
                height: 100%;
                background: #2c3e50;
                color: white;
                padding: 20px;
                box-shadow: 2px 0 20px rgba(0,0,0,0.1);
                transition: transform 0.3s ease, left 0.3s ease;
                z-index: 200;
                overflow-y: auto;
            }

            .sidebar.hidden {
                transform: translateX(-100%);
            }

            /* === Sidebar avatar === */
            .sidebar .avatar-wrapper {
                width: 60px;
                height: 60px;
                background-color: #95a5a6;
                border-radius: 50%;
                margin: 10px auto 20px;
                display: flex;
                justify-content: center;
                align-items: center;
                cursor: pointer;
                overflow: hidden;
            }

            .sidebar .avatar-img {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                object-fit: cover;
                background-color: transparent;
            }

            .sidebar .avatar-icon {
                font-size: 24px;
                color: white;
            }

            /* === Sidebar navigation list === */
            .sidebar ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .sidebar ul li {
                margin: 15px 0;
            }

            .sidebar ul li a {
                color: white;
                text-decoration: none;
                display: block;
                padding: 10px;
                border-radius: 5px;
                transition: background 0.3s, transform 0.2s;
            }

            /* === Hover effect (modern, không tím) === */
            .sidebar ul li a:hover {
                background-color: rgba(255, 255, 255, 0.05);
                transform: translateX(5px);
                color: #ecf0f1;
            }


        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <nav class="sidebar">
            <a href="<%= request.getContextPath() %>/profile">
                <div class="avatar-wrapper">
                    <c:choose>
                        <c:when test="${not empty sessionScope.userAuth.avatar}">
                            <img src="${pageContext.request.contextPath}/avatar/${sessionScope.userAuth.avatar}" alt="Avatar" class="avatar-img">
                        </c:when>
                        <c:otherwise>
                            <span class="avatar-icon">👤</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </a>
            <ul>
                <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/subject-list">Subject</a></li>
                <li><a href="${pageContext.request.contextPath}/my-registration">My registration</a></li>
                <li><a href="${pageContext.request.contextPath}/blog">Blog list</a></li>
                <li><a href="#">Setting</a></li>
            </ul>
        </nav>


        <main>
            <header>
                <h1>My Registrations List</h1>
                <div class="controls">
                    <a href="${pageContext.request.contextPath}/practicelist">My Practice</a>
                    <a href="${pageContext.request.contextPath}/stimulation-exam">Stimulation Exam</a>
                </div>
            </header>
            <!-- Search and Filter UI -->
            <div class="search-container" style="margin: 20px 0; display: flex; justify-content: flex-end;">
                <form id="searchForm" method="get" action="my-registration" style="display: flex; align-items: center;">
                    <div class="search-box">
                        <input type="search" id="searchInput" name="search" placeholder="Search subject..."
                               value="${param.search != null ? param.search : ''}"/>
                        <button type="button" class="search-button" onclick="applyFilters()">Search</button>
                    </div>
                    <button type="button" class="dropdown-toggle" onclick="toggleDropdown(this)">
                        Filter ▼
                    </button>


                    <div class="dropdown-menu" id="filterSidebar">
                        <div class="filter-section">
                            <div class="filter-title">Category</div>
                            <div class="filter-options">
                                <c:forEach items="${allCategories}" var="category">
                                    <div class="filter-item">
                                        <label>
                                            <input type="checkbox" name="cat" value="${category}"
                                                   <c:if test="${fn:contains(paramValues.cat, category)}">checked</c:if>>
                                            ${category}
                                        </label>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        <div class="filter-actions">
                            <button type="button" class="btn-clear" onclick="clearFilters()">Clear</button>
                            <button type="button" class="btn-apply" onclick="applyFilters()">Apply</button>
                        </div>
                    </div>
                </form>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Subject</th>
                        <th>Registration Time</th>
                        <th>Status</th>
                        <th>Total Cost</th>
                        <th>Package</th>
                        <th>Valid from</th>
                        <th>Valid to</th>
                        <th>Option</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty registrations}">
                            <c:forEach var="r" items="${registrations}">
                                <tr>
                                    <td>${r.id}</td>
                                    <td>${r.subjectPackage.title}</td>
                                    <td><fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${r.status == 'active'}">
                                                <span style="background:#27ae60; color:white; padding:4px 8px; border-radius:4px;">Active</span>
                                            </c:when>
                                            <c:when test="${r.status == 'submitted'}">
                                                <span style="background:#3498db; color:white; padding:4px 8px; border-radius:4px;">Submitted</span>
                                            </c:when>
                                            <c:when test="${r.status == 'pending'}">
                                                <span style="background:#f39c12; color:white; padding:4px 8px; border-radius:4px;">Pending</span>
                                            </c:when>
                                            <c:when test="${r.status == 'expired'}">
                                                <span style="background:#95a5a6; color:white; padding:4px 8px; border-radius:4px;">Expired</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span>${r.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatNumber value="${r.totalCost}" type="currency" currencySymbol="₫"/></td>
                                    <td>
                                        <div>
                                            <strong>${r.packageMonths} tháng</strong><br/>
                                            <small style="color: gray">${r.subjectPackage.category}</small><br/>
                                            <c:choose>
                                                <c:when test="${r.subjectPackage.salePrice lt r.subjectPackage.originalPrice}">
                                                    <small style="color:red; text-decoration:line-through;">
                                                        <fmt:formatNumber value="${r.subjectPackage.originalPrice}" type="currency" currencySymbol="₫"/>
                                                    </small><br/>
                                                    <small style="color:green; font-weight:bold;">
                                                        <fmt:formatNumber value="${r.subjectPackage.salePrice}" type="currency" currencySymbol="₫"/>
                                                    </small>
                                                </c:when>
                                                <c:otherwise>
                                                    <small>
                                                        <fmt:formatNumber value="${r.subjectPackage.originalPrice}" type="currency" currencySymbol="₫"/>
                                                    </small>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td><fmt:formatDate value="${r.validFrom}" pattern="dd/MM/yyyy"/></td>
                                    <td><fmt:formatDate value="${r.validTo}" pattern="dd/MM/yyyy"/></td>
                                    <td>
                                        <form action="registrationDetails" method="get">
                                            <input type="hidden" name="id" value="${r.id}" />
                                            <button class="action">View Details</button>
                                        </form>
                                        <form action="my-registration" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xoá đăng ký này không?');">
                                            <input type="hidden" name="id" value="${r.id}" />
                                            <input type="hidden" name="action" value="delete" />
                                            <button class="action" style="background-color:#e74c3c;">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="9">No registration can be found.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </main>
    </body>
</html>
<script>
    function toggleDropdown(button) {
        const dropdown = document.getElementById('filterSidebar');
        dropdown.classList.toggle('visible');
        button.classList.toggle('has-filters');
    }

    function applyFilters() {
        const form = document.getElementById('searchForm');
        const searchInput = document.getElementById('searchInput');

        // Gán lại giá trị cho input search nếu cần
        let searchHiddenInput = form.querySelector('input[name="search"]');
        if (searchHiddenInput) {
            searchHiddenInput.value = searchInput.value;
        }

        form.submit();
    }

    function clearFilters() {
        const form = document.getElementById('searchForm');
        const searchInput = document.getElementById('searchInput');
        const checkboxes = document.querySelectorAll('#filterSidebar input[name="cat"]');

        checkboxes.forEach(cb => cb.checked = false);
        searchInput.value = '';

        // Xóa các input ẩn (nếu có)
        form.querySelectorAll('input[name="cat"][type="hidden"], input[name="search"][type="hidden"]').forEach(input => input.remove());

        form.submit();
    }
</script>