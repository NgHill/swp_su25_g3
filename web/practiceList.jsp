<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
            overflow: hidden; /* Cắt phần thừa */
        }

        .avatar-img {
            width: 50px;     /* Nhỏ hơn wrapper một chút */
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            background-color: transparent;
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

/* Nội dung chính */
main {
    flex: 1;
    margin-left: 200px; /* Thay đổi khoảng cách với sidebar */
    transition: margin-left 0.3s ease-in-out;
}

/* Khi sidebar ẩn, dịch nội dung chính sang trái */
.sidebar.hidden + main {
    margin-left: 0;
}


/* Nội dung chính */
main {
    flex: 1;
    margin-left: 200px; /* Thay đổi khoảng cách với sidebar */
    transition: margin-left 0.3s ease-in-out;
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


        </style>
    </head>
    <body>
        <!-- Sidebar -->
            <nav class="sidebar" id="sidebar">
                <a href="${pageContext.request.contextPath}/profile?id=${userId}">
                    <div class="avatar-wrapper">
                         <a href="<%= request.getContextPath() %>/profile">
                            <div class="avatar-wrapper">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.userAuth.avatar}">
                                        <img src="<%= request.getContextPath() %>/${sessionScope.userAuth.avatar}" alt="Avatar" class="avatar-img">
                                    </c:when>
                                    <c:otherwise>
                                        <span class="avatar-icon">👤</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                          </a>
                    </div>
                </a>

                <ul>
                    <li><a href="<%= request.getContextPath() %>/home">Home</a></li>
                    <li><a href="<%= request.getContextPath() %>/subject">Subject</a></li>
                    <li><a href="<%= request.getContextPath() %>/myRegistration">My Registrations</a></li>
                    <li><a href="<%= request.getContextPath() %>/settings">Setting</a></li>
                </ul>
            </nav>

        <main>
            <!-- Header -->
            <header>
                <a href="#" id="toggleSidebar">☰ Toggle Sidebar</a>
                <h1>Practice List</h1>

                <!-- Thanh tìm kiếm với dropdown -->
                <div class="search-container">
                    <form method="get" action="${pageContext.request.contextPath}/practicelist" class="search-box">
                        <input type="search" name="search" placeholder="Search..." value="${search}">
                        <button class="search-button" type="submit">🔍</button>
                    </form>
                </div>

            </header>
                <div class="filter-dropdown">
                    <button type="button" class="filter-btn" onclick="toggleFilter()">Filter ▼</button>
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
                        <c:forEach items="${practiceLists}" var="pl">
                            <tr>
                                <td>${status.index + 1}</td> 
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
        </main>
        
       
        <script>
            function toggleFilter() {
                const content = document.getElementById('filterContent');
                content.style.display = (content.style.display === 'block') ? 'none' : 'block';
            }

            // Ẩn khi click ra ngoài
            window.addEventListener('click', function (e) {
                const dropdown = document.querySelector('.filter-dropdown');
                const content = document.getElementById('filterContent');
                if (!dropdown.contains(e.target)) {
                    content.style.display = 'none';
                }
            });
        </script>
        <script>
    // Thêm sự kiện click cho nút toggleSidebar
            document.getElementById("toggleSidebar").addEventListener("click", function (e) {
            e.preventDefault(); // Ngăn trình duyệt nhảy lên đầu trang do href="#"
            document.querySelector(".sidebar").classList.toggle("hidden"); // Toggle class 'hidden'
            });
        </script>
        
    </body>
</html>


