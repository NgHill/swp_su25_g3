<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Stimulation Exam</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Global Styles */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                color: #333;
            }

            .container {
                display: flex;
                min-height: 100vh;
            }

            /* === Sidebar (UPDATED) === */
            .sidebar {
                position: fixed;
                top: 0;
                left: 0;
                width: 220px;
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

            .sidebar ul li a:hover {
                background-color: rgba(255, 255, 255, 0.05);
                transform: translateX(5px);
                color: #ecf0f1;
            }

            /* Main Content Area */
            .main-content {
                flex-grow: 1;
                margin-left: 220px;
                transition: margin-left 0.3s;
                padding: 20px;
            }

            .sidebar.hidden + .main-content {
                margin-left: 0;
            }

            .content-wrapper {
                background:rgba(255,255,255,.95);
                backdrop-filter:blur(10px);
                border-radius:15px;
                padding:30px;
                box-shadow:0 8px 32px rgba(0,0,0,.1);
            }

            /* Header */
            header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px;
                border-radius: 8px;
                color: #2d3748;
                background-color: #fff;
                margin-bottom: 20px;
                box-shadow: 0 4px 6px -1px rgba(0,0,0,.1), 0 2px 4px -1px rgba(0,0,0,.06);
            }

            header h1 {
                font-size: 24px;
            }

            /* Controls & Filter */
            .controls {
                display: flex;
                justify-content: center;
                gap: 15px;
                margin: 20px 0;
            }

            .filter-dropdown {
                position: relative;
                display: inline-block;
                margin-bottom: 20px;
            }

            .filter-btn {
                padding: 8px 15px;
                cursor: pointer;
                background-color: #3498db;
                color: white;
                border: none;
                border-radius: 5px;
            }

            .filter-content {
                display: none;
                position: absolute;
                top: 40px;
                left: 0;
                background-color: white;
                border: 1px solid #ddd;
                padding: 15px;
                border-radius: 5px;
                z-index: 1;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
                width: 250px;
            }
            .filter-content button {
                width: 100%;
                padding: 8px;
                margin-top: 10px;
                background-color: #28a745;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }

            /* Table Styles */
            .table-container {
                overflow-x: auto;
            }

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
                background-color: #3498db;
                color: white;
            }

            tr:hover {
                background-color: #f2f2f2;
            }

            /* Action Buttons */
            .view-btn {
                font-size: 14px;
                padding: 8px 16px;
                background-color: #2980b9;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                transition: background-color 0.3s ease;
            }

            .view-btn:hover {
                background-color: #1f6391;
            }

            /* Search Box */
            .search-box {
                display: flex;
                align-items: center;
            }

            .search-box input[type="search"] {
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 20px 0 0 20px;
                outline: none;
            }

            .search-button {
                background-color: #3498db;
                color: white;
                border: 1px solid #3498db;
                padding: 8px 12px;
                border-radius: 0 20px 20px 0;
                cursor: pointer;
            }

            /* Pagination */
            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                margin: 20px 0;
                gap: 10px;
            }

            .pagination a,
            .pagination span {
                padding: 8px 12px;
                text-decoration: none;
                border: 1px solid #ddd;
                color: #007bff;
                border-radius: 4px;
                transition: background-color 0.3s;
            }

            .pagination a:hover {
                background-color: #e9ecef;
            }

            .pagination .current {
                background-color: #007bff;
                color: white;
                border-color: #007bff;
            }

            .pagination .disabled {
                color: #6c757d;
                cursor: not-allowed;
                background-color: #fff;
            }

            @media (max-width: 768px) {
                .sidebar {
                    transform: translateX(-100%);
                }
                .main-content {
                    margin-left: 0;
                }
                .sidebar.hidden {
                    transform: translateX(-100%);
                }
                header {
                    flex-direction: column;
                    gap: 10px;
                }
            }
            .filter-dropdown a {
                font-size: 16px;
                background-color: #27ae60;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                text-decoration: none;
                display: inline-block;
                transition: background-color 0.3s ease;
            }
        </style>
    </head>
    <body>

        <nav class="sidebar">
            <a href="${pageContext.request.contextPath}/profile">
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

        <div class="main-content">
            <div class="content-wrapper">
                <header>
                    <h1>Practice List</h1>
                    <div class="search-container">
                        <form method="get" action="${pageContext.request.contextPath}/practicelist" class="search-box">
                            <input type="search" name="search" placeholder="Search..." value="${search}">
                            <button class="search-button" type="submit">🔍</button>
                        </form>
                    </div>
                </header>

                <div class="filter-dropdown">
                    <button type="button" class="filter-btn" onclick="toggleFilter()">Filter ▼</button>
                    <div class="controls">
                </div>
       
                    <div class="filter-content" id="filterContent" style="display:none;">
                        <form method="get" action="${pageContext.request.contextPath}/practicelist">
                            <label>
                                <div>Score:</div>
                                <select name="scoreFilter">
                                    <option value="A" <c:if test="${scoreFilter == 'A' || scoreFilter == null}">selected</c:if>>All</option>
                                    <option value="L" <c:if test="${scoreFilter == 'L'}">selected</c:if>>Lower than 5</option>
                                    <option value="G" <c:if test="${scoreFilter == 'G'}">selected</c:if>>Greater than 5</option>
                                    </select>
                                </label>
                                <button type="submit">Apply</button>
                            </form>
                        </div>
                </div>


                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Submitted on</th>
                                <th>Score</th>
                                <th>Options</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${practiceLists}" var="pl" varStatus="status">
                                <tr>
                                    <td>${offset + status.index + 1}</td>
                                    <td>${pl.quizTitle}</td>
                                    <td>${pl.submittedAt}</td>
                                    <td>${pl.score}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/practicedetails?quizResultId=${pl.quizResultId}" class="view-btn">View</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <a href="?page=${currentPage - 1}&scoreFilter=${scoreFilter}&search=${param.search}">« Previous</a>
                            </c:when>
                            <c:otherwise>
                                <span class="disabled">« Previous</span>
                            </c:otherwise>
                        </c:choose>

                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span class="current">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="?page=${i}&scoreFilter=${scoreFilter}&search=${param.search}">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <a href="?page=${currentPage + 1}&scoreFilter=${scoreFilter}&search=${param.search}">Next »</a>
                            </c:when>
                            <c:otherwise>
                                <span class="disabled">Next »</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
            </div>
        </div>

        <script>
            function toggleFilter() {
                const content = document.getElementById('filterContent');
                content.style.display = (content.style.display === 'block') ? 'none' : 'block';
            }

            window.addEventListener('click', function (e) {
                const dropdown = document.querySelector('.filter-dropdown');
                const content = document.getElementById('filterContent');
                if (content && !dropdown.contains(e.target)) {
                    content.style.display = 'none';
                }
            });

        </script>

    </body>
</html>