<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Subject List</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            * {
                margin:0;
                padding:0;
                box-sizing:border-box;
            }
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);
                min-height:100vh;
                color:#333;
            }
            .container {
                display:flex;
                background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);
                min-height:100vh;
            }
            /* === Sidebar container === */
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

            /* === Hover effect (modern) === */
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
            .filter-sidebar {
                position:absolute;
                top:100%;
                right:0;
                width:250px;
                background:#f9f9f9;
                border:1px solid #ccc;
                border-radius:8px;
                box-shadow:0 4px 12px rgba(0,0,0,.15);
                padding:16px;
                display:none;
                z-index:100;
            }
            .filter-sidebar h3 {
                margin-top:0;
                font-size:16px;
                text-align:center;
                border:1px solid #667eea;
                padding:8px;
                border-radius:4px;
                color:#667eea;
            }
            .filter-group {
                margin:12px 0;
            }
            .filter-group label {
                display:flex;
                align-items:center;
                margin-bottom:8px;
                cursor:pointer;
            }
            .filter-group input {
                margin-right:8px;
            }
            .link-section {
                display:flex;
                flex-direction:column;
                gap:8px;
                margin-top:12px;
            }
            .link-section a {
                text-decoration:none;
                border:1px solid #667eea;
                color:#667eea;
                padding:6px;
                border-radius:4px;
                text-align:center;
            }
            .clear-filter {
                background:#e53e3e;
                color:white;
                border:none;
                padding:8px 16px;
                border-radius:4px;
                cursor:pointer;
                font-size:12px;
                margin-top:8px;
                width:100%;
            }
            .clear-filter:hover {
                background:#c53030;
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
            .controls-left {
                display:flex;
                align-items:center;
                gap:20px;
                flex-wrap:wrap;
            }
            .control-group {
                display:flex;
                align-items:center;
                gap:8px;
            }
            .control-group label {
                font-weight:500;
                color:#2d3748;
                white-space:nowrap;
            }
            .control-group input {
                padding:8px 12px;
                border:1px solid #cbd5e0;
                border-radius:8px;
                background:white;
                font-size:14px;
                cursor:pointer;
                outline:none;
            }
            .control-group input:focus {
                border-color:#667eea;
                box-shadow:0 0 0 2px rgba(102,126,234,.2);
            }
            .display-options {
                display:flex;
                flex-wrap:wrap;
                gap:15px;
                align-items:center;
            }
            .display-options label {
                display:flex;
                align-items:center;
                gap:5px;
                font-size:14px;
                cursor:pointer;
            }
            .subjects-grid {
                display:grid;
                grid-template-columns:repeat(3,1fr);
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
            .price-section {
                display:flex;
                align-items:center;
                gap:10px;
                margin-top:10px;
            }
            .sale-price {
                font-size:18px;
                font-weight:700;
                color:#e53e3e;
            }
            .original-price {
                font-size:16px;
                color:red;
                text-decoration:line-through;
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
            }
            .register-btn:hover {
                transform:scale(1.05);
                box-shadow:0 4px 15px rgba(102,126,234,.4);
            }
            .pagination {
                display:flex;
                justify-content:center;
                gap:10px;
                margin-top:30px;
            }
            .pagination a, .pagination span {
                padding:10px 15px;
                border:2px solid #e2e8f0;
                background:white;
                color:#4a5568;
                border-radius:8px;
                font-weight:500;
                text-decoration:none;
                transition:background .3s,border-color .3s;
            }
            .pagination a:hover {
                background:#f7fafc;
                border-color:#cbd5e0;
            }
            .current {
                background:linear-gradient(135deg,#667eea,#764ba2);
                color:white;
                border-color:#667eea;
            }
            .pagination .current {
                background: linear-gradient(135deg,#667eea,#764ba2);
                color: white;
                border-color: #667eea;
                font-weight: bold;
            }
            .disabled {
                opacity:.5;
                pointer-events:none;
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

        <main class="main-content">
            <div class="content-wrapper">
                <div class="header">
                    <div class="header-left">
                        <h1>Subject List</h1>
                    </div>
                    <div class="header-right">
                        <form method="GET" action="${pageContext.request.contextPath}/subject-list" id="searchForm" onsubmit="document.getElementById('searchPage').value = '1'">
                            <div class="search-wrapper">
                                <div class="search-box">
                                    <input type="search" id="searchInput" name="search" placeholder="Search subject..." value="${param.search}" />
                                    <button type="submit" class="search-button"><i class="fas fa-search"></i></button>
                                </div>

                                <button type="button" class="filter-toggle" id="filterToggle" title="Lọc bộ môn">
                                    <i class="fas fa-filter"></i>
                                </button>
                                <div class="filter-sidebar" id="filterSidebar">
                                    <h3>Categories</h3>
                                    <div class="filter-group">
                                        <label><input type="radio" name="cat" value="" ${empty param.cat ? 'checked' : ''}> Tất cả</label>
                                        <label><input type="radio" name="cat" value="Teamwork" ${param.cat == 'Teamwork' ? 'checked' : ''}> Teamwork</label>
                                        <label><input type="radio" name="cat" value="Communication" ${param.cat == 'Communication' ? 'checked' : ''}> Communication</label>
                                        <label><input type="radio" name="cat" value="Self improve" ${param.cat == 'Self improve' ? 'checked' : ''}> Self improve</label>
                                        <label><input type="radio" name="cat" value="Thinking" ${param.cat == 'Thinking' ? 'checked' : ''}> Thinking</label>
                                    </div>
                                    <button type="button" class="clear-filter" onclick="clearFilter()">Xóa bộ lọc</button>

                                    <h3>Featured Subject</h3>
                                    <div class="filter-group">
                                        <label><a href="#">Subject A</a></label>
                                        <label><a href="#">Subject B</a></label>
                                        <label><a href="#">Subject C</a></label>
                                        <label><a href="#">Subject D</a></label>
                                    </div>
                                    <div class="link-section">
                                        <a href="#">Privacy Policy</a>
                                        <a href="#">Terms of Service</a>
                                        <a href="#">FAQ</a>
                                    </div>
                                </div>
                            </div>
                            <input type="hidden" id="searchPage" name="page" value="${param.page != null ? param.page : 1}" />
                            <input type="hidden" name="pageSize" value="${param.pageSize != null ? param.pageSize : 9}" />
                            <input type="hidden" name="cat" value="${param.cat}" />
                            <c:forEach items="${paramValues.displayOptions}" var="opt">
                                <input type="hidden" name="displayOptions" value="${opt}" />
                            </c:forEach>
                        </form>
                    </div>
                </div>
                <div class="controls-section">
                    <div class="controls-left">
                        <div class="control-group">
                            <label for="pageSize">Number of subjects per page:</label>
                            <input type="number" id="pageSize" name="pageSize" min="1" max="100" value="${param.pageSize != null ? param.pageSize : 9}" onchange="updatePageSize()" />
                        </div>
                        <c:set var="showTitle" value="${empty paramValues.displayOptions}" />
                        <c:set var="showTagline" value="${empty paramValues.displayOptions}" />
                        <c:set var="showSale" value="${empty paramValues.displayOptions}" />
                        <c:set var="showOriginal" value="${empty paramValues.displayOptions}" />
                        <c:forEach items="${paramValues.displayOptions}" var="opt">
                            <c:choose>
                                <c:when test="${opt=='title'}"><c:set var="showTitle" value="true"/></c:when>
                                <c:when test="${opt=='tagline'}"><c:set var="showTagline" value="true"/></c:when>
                                <c:when test="${opt=='sale-price'}"><c:set var="showSale" value="true"/></c:when>
                                <c:when test="${opt=='original-price'}"><c:set var="showOriginal" value="true"/></c:when>
                            </c:choose>
                        </c:forEach>
                        <div class="display-options">
                            <label><input type="checkbox" name="displayOptions" value="title" <c:if test="${showTitle}">checked</c:if> onchange="updateDisplayOptions()" /> Tittle</label>
                            <label><input type="checkbox" name="displayOptions" value="tagline" <c:if test="${showTagline}">checked</c:if> onchange="updateDisplayOptions()" /> Description</label>
                            <label><input type="checkbox" name="displayOptions" value="sale-price" <c:if test="${showSale}">checked</c:if> onchange="updateDisplayOptions()" /> Sale price</label>
                            <label><input type="checkbox" name="displayOptions" value="original-price" <c:if test="${showOriginal}">checked</c:if> onchange="updateDisplayOptions()" /> Original price</label>
                            </div>
                        </div>
                        <div class="controls-right">
                            <div class="pagination">
                            <c:if test="${currentPage>1}">
                                <a href="?page=${currentPage-1}&search=${param.search}&pageSize=${param.pageSize}&cat=${param.cat}<c:forEach items='${paramValues.displayOptions}' var='opt'>&displayOptions=${opt}</c:forEach>">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                            </c:if>
                            <c:if test="${currentPage<=1}">
                                <span class="disabled"><i class="fas fa-chevron-left"></i></span>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <c:choose>
                                        <c:when test="${i==currentPage}">
                                        <span class="current">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="?page=${i}&search=${param.search}&pageSize=${param.pageSize}&cat=${param.cat}<c:forEach items='${paramValues.displayOptions}' var='opt'>&displayOptions=${opt}</c:forEach>">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <c:if test="${currentPage<totalPages}">
                                <a href="?page=${currentPage+1}&search=${param.search}&pageSize=${param.pageSize}&cat=${param.cat}<c:forEach items='${paramValues.displayOptions}' var='opt'>&displayOptions=${opt}</c:forEach>">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                            </c:if>
                            <c:if test="${currentPage>=totalPages}">
                                <span class="disabled"><i class="fas fa-chevron-right"></i></span>
                                </c:if>
                        </div>
                    </div>
                </div>
                <div class="subjects-grid">
                    <c:forEach items="${subjects}" var="subject">
                        <div class="subject-card" onclick="goToSubject(${subject.id})">
                            <div class="subject-thumbnail">
                                <c:choose>
                                    <c:when test="${not empty subject.thumbnail}">
                                        <img src="${pageContext.request.contextPath}/images/${subject.thumbnail}" alt="${subject.title}" onerror="this.style.display='none';this.parentElement.innerHTML='&#128218;';"/>
                                    </c:when>
                                    <c:otherwise>&#128218;</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="subject-content">
                                <c:if test="${showTitle}"><h3>${subject.title}</h3></c:if>
                                <c:if test="${showTagline}"><p>${subject.description}</p></c:if>
                                <c:if test="${showSale or showOriginal}">
                                    <div class="price-section">
                                        <c:if test="${showSale}">
                                            <span class="sale-price">
                                                <fmt:formatNumber value="${subject.salePrice}" type="currency" currencyCode="VND"/>
                                            </span>
                                        </c:if>
                                        <c:if test="${showOriginal}">
                                            <span class="original-price">
                                                <fmt:formatNumber value="${subject.originalPrice}" type="currency" currencyCode="VND"/>
                                            </span>
                                        </c:if>
                                   
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <c:if test="${empty subjects}">
                    <div style="text-align:center;padding:50px;color:#666;">
                        <i class="fas fa-search" style="font-size:48px;margin-bottom:20px;"></i>
                        <h3>Không tìm thấy môn học nào</h3>
                        <p>Thử thay đổi từ khóa tìm kiếm hoặc xem tất cả môn học</p>
                    </div>
                </c:if>
            </div>
        </main>

        <script>
            const ft = document.getElementById('filterToggle'), sb = document.getElementById('filterSidebar');
            ft.addEventListener('click', () => {
                sb.style.display = sb.style.display === 'block' ? 'none' : 'block';
                ft.querySelector('i').classList.toggle('fa-chevron-up');
                ft.querySelector('i').classList.toggle('fa-chevron-down');
            });

            document.addEventListener('click', e => {
                if (!sb.contains(e.target) && !ft.contains(e.target)) {
                    sb.style.display = 'none';
                    ft.querySelector('i').classList.add('fa-chevron-down');
                    ft.querySelector('i').classList.remove('fa-chevron-up');
                }
            });

            // Event listener cho radio buttons
            document.querySelectorAll('input[name="cat"]').forEach(radio => {
                radio.addEventListener('change', function () {
                    if (this.checked) {
                        submitFilter(this.value);
                    }
                });
            });

            // Function xử lý filter
            function submitFilter(categoryValue = '') {
                let url = new URL(window.location.href);
                url.searchParams.set('cat', categoryValue);
                url.searchParams.set('page', '1'); // Reset về trang 1
                window.location.href = url;
            }

            // Function xóa filter
            function clearFilter() {
                let url = new URL(window.location.href);
                url.searchParams.delete('cat');
                url.searchParams.set('page', '1');
                window.location.href = url;
            }

            function updatePageSize() {
                let s = parseInt(document.getElementById('pageSize').value) || 1;
                s = Math.min(Math.max(s, 1), 100);
                document.getElementById('pageSize').value = s;
                let u = new URL(window.location.href);
                u.searchParams.set('pageSize', s);
                u.searchParams.set('page', '1');
                window.location.href = u;
            }

            function updateDisplayOptions() {
                let u = new URL(window.location.href);
                u.searchParams.delete('displayOptions');
                document.querySelectorAll('input[name="displayOptions"]:checked').forEach(cb =>
                    u.searchParams.append('displayOptions', cb.value)
                );
                window.location.href = u;
            }

            function goToSubject(subjectId) {
                // Implement navigation to subject detail page
                window.location.href = "${pageContext.request.contextPath}/subject-detail?id=" + subjectId;
            }

            function registerSubject(event, subjectId) {
                event.stopPropagation(); // Prevent card click event from firing
                // Implement registration logic
                alert("Đăng ký môn học ID: " + subjectId);
                // You might want to redirect to a registration page or send an AJAX request
            }


            document.addEventListener('DOMContentLoaded', () => {
                let i = document.getElementById('pageSize'), v = parseInt(i.value) || 1;
                i.value = Math.min(Math.max(v, 1), 100);
            });
        </script>
    </body>
</html>