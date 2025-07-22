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
            .sidebar {
                width:220px;
                background:#2c3e50;
                color:white;
                padding:20px;
                position:fixed;
                top:0;
                left:0;
                height:100%;
                transition:transform .3s;
                z-index:200;
            }
            .sidebar.hidden {
                transform:translateX(-100%);
            }
            .sidebar ul {
                list-style:none;
            }
            .sidebar li {
                margin:15px 0;
            }
            .sidebar a {
                color:white;
                text-decoration:none;
                display:block;
                padding:10px;
                border-radius:5px;
                transition:background .3s;
            }
            .sidebar a:hover {
                background:#34495e;
            }
            .main-content {
                flex-grow:1;
                margin-left:220px;
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
            #toggleSidebar {
                background:#34495e;
                color:white;
                padding:10px 15px;
                font-size:16px;
                border:none;
                border-radius:5px;
                cursor:pointer;
            }
            #toggleSidebar:hover {
                background:#2c3e50;
            }
            .header h1 {
                color:#2d3748;
                font-size:28px;
                font-weight:700;
            }
            .header-right {
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
            }
            .no-results i {
                font-size:48px;
                color:#cbd5e0;
                margin-bottom:15px;
            }
            @media(max-width:1024px){
                .main-content{
                    margin-left:200px;
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
                    transform:translateX(-100%);
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
                    right:-20px;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <nav class="sidebar">
                <ul>
                    <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/subject-list">Subject</a></li>
                    <li><a href="${pageContext.request.contextPath}/my-registration">My Registrations</a></li>
                    <li><a href="#">Setting</a></li>
                </ul>
            </nav>
            <main class="main-content">
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
                                            <i class="fas fa-search"></i>
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
        </div>

        <script>

            // Chức năng chuyển đổi bộ lọc
            const filterToggle = document.getElementById('filterToggle');
            const filterSidebar = document.getElementById('filterSidebar');

            filterToggle.addEventListener('click', (e) => {
                e.stopPropagation();
                filterSidebar.classList.toggle('show');
                const icon = filterToggle.querySelector('i');
                icon.classList.toggle('fa-filter');
                icon.classList.toggle('fa-times');
            });

            // Đóng thanh bên bộ lọc khi nhấp chuột ra ngoài
            document.addEventListener('click', (e) => {
                if (!filterSidebar.contains(e.target) && !filterToggle.contains(e.target)) {
                    filterSidebar.classList.remove('show');
                    const icon = filterToggle.querySelector('i');
                    icon.classList.add('fa-filter');
                    icon.classList.remove('fa-times');
                }
            });

            // Ngăn chặn đóng khi nhấp vào bên trong thanh bên bộ lọc
            filterSidebar.addEventListener('click', (e) => {
                e.stopPropagation();
            });

            // Hàm áp dụng bộ lọc
            function applyFilters() {
                const form = document.getElementById('searchForm');

                // Xóa các input hidden hiện tại để tránh trùng lặp
                form.querySelectorAll('input[type="hidden"]').forEach(input => input.remove());

                // Thêm các input hidden cho checkbox đã chọn
                document.querySelectorAll('#filterSidebar input[name="cat"]:checked').forEach(cb => {
                    form.appendChild(newHiddenInput('cat', cb.value));
                });

                // Nếu có giá trị tìm kiếm, thêm input hidden
                const searchVal = document.getElementById('searchInput').value.trim();
                if (searchVal) {
                    form.appendChild(newHiddenInput('search', searchVal));
                }

                form.submit();
            }

            // Hàm xóa bộ lọc
            function clearFilters() {
                // Bỏ chọn tất cả checkbox
                document.querySelectorAll('#filterSidebar input[type="checkbox"]').forEach(cb => cb.checked = false);

                // Xóa giá trị tìm kiếm
                document.getElementById('searchInput').value = '';

                // Xóa input hidden nếu có
                document.getElementById('searchForm').querySelectorAll('input[type="hidden"]').forEach(input => input.remove());

                // Submit lại form
                document.getElementById('searchForm').submit();
            }

           // Hàm tạo input hidden
            function newHiddenInput(name, value) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = name;
                input.value = value;
                return input;
            }

            // Khởi tạo các ô đánh dấu bộ lọc dựa trên các tham số URL hiện tại
            document.addEventListener('DOMContentLoaded', function () {
                const urlParams = new URLSearchParams(window.location.search);
                const categories = urlParams.getAll('cat');
                const searchParam = urlParams.get('search');

                // Đánh dấu các ô đánh dấu thích hợp
                categories.forEach(category => {
                    const checkbox = document.querySelector('#filterSidebar input[name="cat"][value="' + category + '"]');
                    if (checkbox) {
                        checkbox.checked = true;
                    }
                });

                // Đặt giá trị ô tìm kiếm nếu có trong URL
                const searchInput = document.getElementById('searchInput');
                if (searchParam) {
                    searchInput.value = searchParam;
                }

            });
        </script>
    </body>
</html>