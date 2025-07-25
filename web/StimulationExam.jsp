<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Simulation Exam</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            * {
                margin:0;
                padding:0;
                box-sizing:border-box;
            }
            body {
                font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;
                background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);
                min-height:100vh;
                color:#333;
            }
            .container {
                display:flex;
                background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);
                min-height:100vh;
            }
            /* === Sidebar container (UPDATED) === */
            .sidebar {
                position: fixed;
                top: 0px;
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

            /* === Sidebar avatar (UPDATED) === */
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

            /* === Sidebar navigation list (UPDATED) === */
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

            /* === Hover effect (modern) (UPDATED) === */
            .sidebar ul li a:hover {
                background-color: rgba(255, 255, 255, 0.05);
                transform: translateX(5px);
                color: #ecf0f1;
            }

            .main-content {
                flex-grow:1;
                margin-left:220px; /* Adjust this to match sidebar width */
                padding:20px;
                transition:margin .3s;
            }
            .sidebar.hidden + .main-content {
                margin-left:0;
            }
            .content-wrapper {
                background:rgba(255,255,255,.95);
                backdrop-filter:blur(10px);
                border-radius:15px;
                padding:30px;
                box-shadow:0 8px 32px rgba(0,0,0,.1);
            }
            .header {
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:30px;
                padding-bottom:20px;
                border-bottom:2px solid #e2e8f0;
                flex-wrap:wrap;
                gap:20px;
            }
            .header-left {
                display:flex;
                align-items:center;
                gap:15px;
            }
            .header h1 {
                color:#2d3748;
                font-size:28px;
                font-weight:700;
            }
            .header-right {
                position: relative;
                display:flex;
                align-items:center;
                gap:20px;
                flex-wrap:wrap;
            }
            .search-wrapper {
                position:relative;
                display:flex;
                align-items:center;
            }
            .search-box {
                display:flex;
                align-items:center;
                background:white;
                padding:5px;
                border:2px solid #667eea;
                border-radius:25px;
                box-shadow:0 2px 6px rgba(0,0,0,.2);
                width:300px;
            }
            .search-box input[type=search] {
                flex:1;
                padding:10px;
                border:none;
                border-radius:25px;
                outline:none;
                font-size:16px;
            }
            .search-button {
                background:#667eea;
                color:white;
                border:none;
                padding:8px 12px;
                border-radius:20px;
                cursor:pointer;
                display:flex;
                align-items:center;
                gap:5px;
                transition:background .3s;
            }
            .search-button:hover {
                background:#5a67d8;
            }
            .filter-toggle {
                width: 40px;
                height: 40px;
                margin-left: 10px;
                background: #667eea;
                border: none;
                border-radius: 8px;
                display: flex;
                justify-content: center;
                align-items: center;
                cursor: pointer;
                transition: background 0.3s;
                color: white;
                font-size: 16px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            .filter-toggle:hover {
                background: #5a67d8;
            }
            .filter-sidebar {
                position:absolute;
                top:100%;
                right:0;
                width:300px;
                background:#f9f9f9;
                border:1px solid #ccc;
                border-radius:8px;
                box-shadow:0 4px 12px rgba(0,0,0,.15);
                padding:16px;
                display:none;
                z-index:100;
            }
            .filter-sidebar.show {
                display:block;
            }
            .filter-sidebar h3 {
                margin-top:0;
                font-size:16px;
                text-align:center;
                border:1px solid #667eea;
                padding:8px;
                border-radius:4px;
                color:#667eea;
                margin-bottom:15px;
            }
            .filter-group {
                margin:12px 0;
            }
            .filter-group h4 {
                margin-bottom:8px;
                color:#2d3748;
                font-size:14px;
                font-weight:600;
            }
            .filter-group label {
                display:flex;
                align-items:center;
                margin-bottom:8px;
                cursor:pointer;
                font-size:13px;
            }
            .filter-group input[type="checkbox"] {
                margin-right:8px;
                cursor:pointer;
            }
            .filter-actions {
                display:flex;
                gap:8px;
                margin-top:15px;
            }
            .apply-filter, .clear-filter {
                flex:1;
                padding:8px 12px;
                border:none;
                border-radius:4px;
                cursor:pointer;
                font-size:12px;
                font-weight:600;
                transition:background .3s;
            }
            .apply-filter {
                background:#667eea;
                color:white;
            }
            .apply-filter:hover {
                background:#5a67d8;
            }
            .clear-filter {
                background:#e53e3e;
                color:white;
            }
            .clear-filter:hover {
                background:#c53030;
            }
            .active-filters {
                display:flex;
                flex-wrap:wrap;
                gap:8px;
                margin-bottom:20px;
            }
            .filter-tag {
                background:#667eea;
                color:white;
                padding:4px 8px;
                border-radius:12px;
                font-size:12px;
                display:flex;
                align-items:center;
                gap:5px;
            }
            .filter-tag .remove {
                cursor:pointer;
                font-weight:bold;
            }
            .controls-section {
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:30px;
                padding:15px;
                background:#f8f9fa;
                border-radius:10px;
                flex-wrap:wrap;
                gap:15px;
            }
            .results-info {
                font-weight:500;
                color:#2d3748;
            }
            .subjects-grid {
                display:grid;
                grid-template-columns:repeat(auto-fit, minmax(220px, 1fr));
                gap:25px;
                margin-bottom:40px;
            }
            .subject-card {
                background:white;
                border-radius:15px;
                overflow:hidden;
                box-shadow:0 4px 20px rgba(0,0,0,.1);
                transition:transform .3s,box-shadow .3s;
                cursor:pointer;
            }
            .subject-card:hover {
                transform:translateY(-5px);
                box-shadow:0 8px 30px rgba(0,0,0,.15);
            }
            .subject-thumbnail {
                width:100%;
                height:200px;
                background:linear-gradient(45deg,#667eea,#764ba2);
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:48px;
                color:white;
                position:relative;
                overflow:hidden;
            }
            .subject-thumbnail img {
                width:100%;
                height:100%;
                object-fit:cover;
            }
            .subject-thumbnail::before {
                content:'';
                position:absolute;
                top:0;
                left:0;
                right:0;
                bottom:0;
                background:linear-gradient(45deg,transparent 30%,rgba(255,255,255,.1) 50%,transparent 70%);
                transform:translateX(-100%);
                transition:transform .6s;
            }
            .subject-card:hover .subject-thumbnail::before {
                transform:translateX(100%);
            }
            .subject-content {
                padding:20px;
            }
            .subject-content h3 {
                margin-bottom:10px;
                color:#2d3748;
                font-size:16px;
            }
            .subject-content p {
                margin:5px 0;
                color:#4a5568;
                font-size:14px;
            }
            .register-btn {
                background:linear-gradient(135deg,#667eea,#764ba2);
                color:white;
                border:none;
                padding:10px 20px;
                border-radius:25px;
                font-weight:600;
                cursor:pointer;
                font-size:14px;
                transition:transform .3s,box-shadow .3s;
                margin-top:10px;
            }
            .register-btn:hover {
                transform:scale(1.05);
                box-shadow:0 4px 15px rgba(102,126,234,.4);
            }
            .no-results {
                text-align:center;
                padding:40px 20px;
                color:#4a5568;
                grid-column: 1 / -1;
            }
            .no-results i {
                font-size:48px;
                color:#cbd5e0;
                margin-bottom:15px;
            }
            @media(max-width:1024px){
                .main-content{
                    margin-left:220px;
                }
                .search-box{
                    width:250px;
                }
            }
            @media(max-width:768px){
                .main-content{
                    margin-left:0;
                    padding:15px;
                }
                .sidebar{
                    transform:translateX(-100%); /* Hide sidebar on small screens */
                }
                .subjects-grid{
                    grid-template-columns:1fr;
                }
                .header{
                    flex-direction:column;
                    text-align:center;
                    align-items:stretch;
                }
                .search-box{
                    width:100%;
                    max-width:300px;
                }
                .controls-section{
                    flex-direction:column;
                    align-items:stretch;
                }
                .filter-sidebar{
                    width:280px;
                    right:0;
                    left: auto;
                }
            }
        </style>
    </head>
    <body>

        <nav class="sidebar">
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
            <ul>
                <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/subject-list">Subject</a></li>
                <li><a href="${pageContext.request.contextPath}/my-registration">My registration</a></li>
                <li><a href="${pageContext.request.contextPath}/blog">Blog list</a></li>
                <li><a href="#">Setting</a></li>
            </ul>
        </nav>
        <main class="main-content" id="mainContent">
            <div class="content-wrapper">
                <div class="header">
                    <div class="header-left">
                        <h1>Simulation Exam</h1>
                    </div>
                    <div class="header-right">
                        <form method="GET" action="${pageContext.request.contextPath}/stimulation-exam" id="searchForm">
                            <div class="search-wrapper">
                                <div class="search-box">
                                    <input type="search" id="searchInput" name="search"
                                           placeholder="Search exam..." value="${param.search}" />
                                    <button type="submit" class="search-button">
                                        <i class="fas fa-search" ></i>
                                    </button>
                                </div>
                                <button type="button" class="filter-toggle" id="filterToggle">
                                    <i class="fas fa-filter"></i>
                                </button>
                                <div class="filter-sidebar" id="filterSidebar">
                                    <h3>Filter Options</h3>

                                    <div class="filter-group">
                                        <h4>Category</h4>
                                        <c:forEach items="${allCategories}" var="category">
                                            <label>
                                                <input type="checkbox" name="cat" value="${category}"
                                                       <c:if test="${fn:contains(paramValues.cat, category)}">checked</c:if>>
                                                ${category}
                                            </label>
                                        </c:forEach>
                                    </div>

                                    <div class="filter-actions">
                                        <button type="button" class="apply-filter" onclick="applyFilters()">Apply</button>
                                        <button type="button" class="clear-filter" onclick="clearFilters()">Clear</button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="subjects-grid">
                    <c:choose>
                        <c:when test="${empty stimulationList}">
                            <div class="no-results">
                                <i class="fas fa-search"></i>
                                <h3>No exams found</h3>
                                <p>Try adjusting your search criteria or filters</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${stimulationList}" var="exam">
                                <div class="subject-card" onclick="goToStimulation(${exam.id})">
                                    <div class="subject-thumbnail">
                                        📘
                                    </div>
                                    <div class="subject-content">
                                        <h3>${exam.stimulationExam}</h3>
                                        <p>Level: ${exam.level}</p>
                                        <p>Number of question: ${exam.numberOfQuestions}</p>
                                        <p>Time: ${exam.duration} minutes</p>
                                        <p>Pass rate: ${exam.passRate}%</p>
                                        <button class="register-btn" onclick="registerStimulation(event, ${exam.id})">Start</button>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </main>


        <script>
            // Chức năng toggle (hiển thị/ẩn) sidebar bộ lọc
            const filterToggle = document.getElementById('filterToggle'); // Lấy phần tử nút toggle (hiển thị/ẩn sidebar bộ lọc)
            const filterSidebar = document.getElementById('filterSidebar'); // Lấy phần tử sidebar bộ lọc

            // Khi người dùng click vào nút toggle, thực hiện việc hiển thị/ẩn sidebar
            filterToggle.addEventListener('click', (e) => {
                filterSidebar.classList.toggle('show'); 
               
            });

            // Hàm áp dụng bộ lọc (tìm kiếm và category)
            function applyFilters() {
                const form = document.getElementById('searchForm'); // Lấy form chứa ô tìm kiếm và bộ lọc

                // Xóa tất cả các input ẩn trong form để tránh việc tạo ra các input trùng lặp
                form.querySelectorAll('input[type="hidden"]').forEach(input => input.remove());

                form.submit(); // Gửi form đi để áp dụng bộ lọc
            }

            // Hàm xóa bộ lọc (xóa tìm kiếm và bỏ chọn tất cả các category)
            function clearFilters() {
                // Bỏ chọn tất cả các checkbox trong sidebar bộ lọc
                document.querySelectorAll('#filterSidebar input[type="checkbox"]').forEach(cb => cb.checked = false);

                // Xóa giá trị trong ô tìm kiếm
                document.getElementById('searchInput').value = '';

                // Gửi form để làm mới và áp dụng bộ lọc với giá trị mặc định (không có bộ lọc)
                document.getElementById('searchForm').submit();
            }

            // Khởi tạo các checkbox bộ lọc theo các tham số URL hiện tại
            document.addEventListener('DOMContentLoaded', function () {
                const urlParams = new URLSearchParams(window.location.search); // Lấy các tham số URL hiện tại
                const categories = urlParams.getAll('cat'); // Lấy tất cả giá trị của tham số 'cat' (category) từ URL
                const searchParam = urlParams.get('search'); // Lấy giá trị tham số 'search' từ URL

                // Đánh dấu (check) các checkbox tương ứng với các category đã chọn từ URL
                categories.forEach(category => {
                    const checkbox = document.querySelector('#filterSidebar input[name="cat"][value="' + category + '"]');
                    if (checkbox) {
                        checkbox.checked = true; // Đánh dấu checkbox nếu giá trị của category trùng với tham số URL
                    }
                });

                // Điền lại giá trị ô tìm kiếm nếu có giá trị trong tham số 'search' của URL
                const searchInput = document.getElementById('searchInput');
                if (searchParam) {
                    searchInput.value = searchParam; // Đặt giá trị ô tìm kiếm bằng giá trị trong URL
                }
            });
        </script>
    </body>
</html>