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
                            <button id="toggleSidebar">☰</button>
                            <h1>Subject Register</h1>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${subject != null}">
                            <div class="subject-card" style="cursor: default;">
                                <div class="subject-content" style="padding: 30px;">
                                    <h2 style="font-size: 24px; color: #2d3748;">${subject.title}</h2>
                                    <div class="price-section" style="margin-top: 10px;">
                                        <span class="sale-price" style="font-size: 20px; color: #e53e3e;">
                                            <fmt:formatNumber value="${subject.salePrice}" type="currency" currencyCode="VND"/>
                                        </span>
                                    </div>

                                    <hr style="margin: 20px 0;">


                                    <div class="form-group">
                                        <h3>Thông tin người dùng:</h3>

                                        <c:choose>
                                            <c:when test="${sessionScope.userAuth != null}">
                                                <%-- Nếu đã đăng nhập --%>
                                                <p><strong>Họ và tên:</strong> ${sessionScope.userAuth.fullName}</p>
                                                <p><strong>Email:</strong> ${sessionScope.userAuth.email}</p>
                                                <p><strong>Số điện thoại:</strong> ${sessionScope.userAuth.mobile}</p>
                                                <p><strong>Giới tính:</strong> 
                                                    <c:choose>
                                                        <c:when test="${sessionScope.userAuth.gender == true}">Nam</c:when>
                                                        <c:when test="${sessionScope.userAuth.gender == false}">Nữ</c:when>
                                                        <c:otherwise>Khác</c:otherwise>
                                                    </c:choose>
                                                </p>
                                                <form method="post" action="${pageContext.request.contextPath}/subject-register">
                                                    <input type="hidden" name="subjectId" value="${subject.id}" />
                                                    <input type="hidden" name="price" value="${subject.salePrice}" />
                                                    <input type="hidden" name="confirm" value="true" />

                                                    <div class="form-group">
                                                        <label for="packageSelect"><strong>Chọn gói học:</strong></label><br>
                                                        <select id="packageSelect" name="packageMonths" style="margin-top: 10px; padding: 10px; border-radius: 6px; border: 1px solid #ccc;">
                                                            <option value="1">1 tháng</option>
                                                            <option value="3">3 tháng</option>
                                                            <option value="6">6 tháng</option>
                                                        </select>
                                                    </div>
                                                    <hr style="margin: 20px 0;">
                                                    <button type="submit" class="register-btn">Xác nhận đăng kí</button>
                                                </form>
                                            </c:when>

                                            <c:otherwise>
                                                <%-- Nếu chưa đăng nhập --%>
                                                <form id="registerForm" method="post" action="${pageContext.request.contextPath}/subject-register">
                                                    <input type="hidden" name="subjectId" value="${subject.id}" />
                                                    <input type="hidden" name="price" value="${subject.salePrice}" />
                                                    <input type="hidden" name="confirm" value="true" />

                                                    <div class="form-group">
                                                        <label for="packageSelect"><strong>Chọn gói học:</strong></label><br>
                                                        <select id="packageSelect" name="packageMonths" style="margin-top: 10px; padding: 10px; border-radius: 6px; border: 1px solid #ccc;">
                                                            <option value="1">1 tháng</option>
                                                            <option value="3">3 tháng</option>
                                                            <option value="6">6 tháng</option>
                                                        </select>
                                                    </div>

                                                    <input type="text" name="fullName" placeholder="Họ và tên" required pattern="[^\d]+" title="Họ và tên không được chứa số">

                                                    <input type="email" name="email" placeholder="Email" required>

                                                    <input type="text" name="mobile" placeholder="Số điện thoại" required pattern="[0-9]+" title="Số điện thoại chỉ được chứa số">

                                                    <select name="gender" required>
                                                        <option value="true">Nam</option>
                                                        <option value="false">Nữ</option>
                                                    </select>

                                                    <button type="submit" class="register-btn" onclick="return confirm('Bạn có chắc muốn đăng ký môn học này?')">Xác nhận đăng ký</button>
                                                </form>

                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                    </c:choose>
                    <c:if test="${not empty successMessage}">
                        <script>
        alert("${successMessage}");
        window.location.href = "<c:url value='/subject-list' />";
                        </script>
                    </c:if>

                </div>
            </main>
        </div>
        <script>
            document.getElementById('toggleSidebar').addEventListener('click', () =>
                document.querySelector('.sidebar').classList.toggle('hidden')
            );

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


        </script>
    </body>
</html>