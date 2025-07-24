<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quiz Practice for Soft Skills - Home page</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
            }

            /* Header */
            .header {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                padding: 1rem 2rem;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                position: sticky;
                top: 0;
                z-index: 1000;
                margin-left: 220px;
            }

            .header-content {
                display: flex;
                justify-content: space-between;
                align-items: center;
                max-width: 1200px;
                margin: 0 auto;
                margin-left:180px;
            }

            .logo {
                font-size: 1.8rem;
                font-weight: bold;
                color: #667eea;
            }

            .menu-toggle {
                background: #667eea;
                border: none;
                padding: 10px 15px;
                border-radius: 8px;
                color: white;
                cursor: pointer;
                font-size: 1.2rem;
                transition: all 0.3s ease;
            }

            .menu-toggle:hover {
                background: #5a6fd8;
                transform: scale(1.05);
            }

            .auth-buttons {
                display: flex;
                gap: 1rem;
            }

            .auth-btn {
                padding: 8px 16px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .login-btn {
                color: #667eea;
                border: 1px solid #667eea;
            }

            .login-btn:hover {
                background: #667eea;
                color: white;
            }

            .signup-btn {
                background: #667eea;
                color: white;
            }

            .signup-btn:hover {
                background: #5a6fd8;
            }

            /* Left Sidebar */
            .sidebar {
                text-decoration: none;
                position: fixed;
                top: 0;
                width: 220px;
                height: 100vh;
                background: #2c3e50;
                box-shadow: 2px 0 20px rgba(0,0,0,0.1);
                transition: left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                z-index: 1001;
                overflow-y: auto;
            }


            .sidebar-header {
                padding: 2rem 1.5rem;
                border-bottom: 1px solid rgba(0,0,0,0.1);
                text-align: center;
                text-decoration: none;
            }

            .sidebar-nav {
                padding: auto;
                padding-top:20px;
                text-decoration: none;
            }

            .nav-item {
                display: flex;
                align-items: center;
                padding: 1rem 1.5rem;
                color: white;
                text-decoration: none;
                transition: all 0.3s ease;
                border-left: 3px solid transparent;
                text-decoration: none;

            }

            .nav-item:hover {
                background: rgba(102, 126, 234, 0.1);
                border-left-color: #667eea;
                transform: translateX(5px);
            }

            .nav-icon {
                margin-right: 12px;
                font-size: 1.2rem;
                text-decoration: none;
            }

            /* Main Content */
            .main-content {
                max-width: 1200px;
                margin: 0 auto;
                margin-left: 220px;
                padding: 2rem;
                transition: margin-left 0.3s ease;
            }

            /* Slider Section */
            .slider-section {
                margin-bottom: 3rem;
            }

            .slider-container {
                position: relative;
                background: rgba(255, 255, 255, 0.9);
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            }

            .slider {
                display: flex;
                transition: transform 0.5s ease;
            }

            .slide {
                min-width: 100%;
                position: relative;
                cursor: pointer;
                height: 400px;
                background-size: cover;
                background-position: center;
                display: flex;
                align-items: end;
            }

            .slide-content {
                background: linear-gradient(transparent, rgba(0,0,0,0.8));
                color: white;
                padding: 2rem;
                width: 100%;
            }

            .slide-title {
                font-size: 1.8rem;
                margin-bottom: 0.5rem;
            }

            .slider-nav {
                position: absolute;
                bottom: 20px;
                right: 20px;
                display: flex;
                gap: 10px;
            }

            .slider-dot {
                width: 12px;
                height: 12px;
                border-radius: 50%;
                background: rgba(255,255,255,0.5);
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .slider-dot.active {
                background: white;
                transform: scale(1.2);
            }

            /* Content Grid */
            .content-grid {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 2rem;
                margin-bottom: 3rem;
            }

            .posts-section, .subjects-section {
                background: rgba(255, 255, 255, 0.9);
                border-radius: 15px;
                padding: 2rem;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }

            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1.5rem;
                padding-bottom: 1rem;
                border-bottom: 2px solid #667eea;
            }

            .section-header h2 {
                color: #667eea;
                font-size: 1.5rem;
            }

            .view-all {
                color: #667eea;
                text-decoration: none;
                font-weight: 500;
                transition: color 0.3s ease;
            }

            .view-all:hover {
                color: #5a6fd8;
            }

            /* Post Cards */
            .post-grid {
                display: grid;
                gap: 1.5rem;
            }

            .post-card {
                display: flex;
                gap: 1rem;
                padding: 1rem;
                border-radius: 10px;
                transition: all 0.3s ease;
                cursor: pointer;
            }

            .post-card:hover {
                background: rgba(102, 126, 234, 0.05);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }

            .post-thumbnail {
                width: 80px;
                height: 80px;
                border-radius: 8px;
                background-size: cover;
                background-position: center;
                flex-shrink: 0;
            }

            .post-info h3 {
                font-size: 1rem;
                margin-bottom: 0.5rem;
                color: #333;
                line-height: 1.4;
            }

            .post-date {
                color: #666;
                font-size: 0.85rem;
            }

            /* Subject Cards */
            .subject-grid {
                display: grid;
                gap: 1.5rem;
            }

            .subject-card {
                text-align: center;
                padding: 1.5rem;
                border-radius: 10px;
                transition: all 0.3s ease;
                cursor: pointer;
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            }

            .subject-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            }

            .subject-thumbnail {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                background-size: cover;
                background-position: center;
                margin: 0 auto 1rem;
            }

            .subject-title {
                font-size: 1.1rem;
                margin-bottom: 0.5rem;
                color: #333;
            }

            .subject-tagline {
                color: #666;
                font-size: 0.9rem;
            }

            /* Right Sidebar */
            .right-sidebar {
                background: rgba(255, 255, 255, 0.9);
                border-radius: 15px;
                padding: 2rem;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                height: fit-content;
            }

            .latest-posts {
                margin-bottom: 2rem;
            }

            .latest-post-item {
                display: flex;
                gap: 1rem;
                padding: 1rem 0;
                border-bottom: 1px solid rgba(0,0,0,0.1);
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .latest-post-item:hover {
                background: rgba(102, 126, 234, 0.05);
                margin: 0 -1rem;
                padding: 1rem;
                border-radius: 8px;
            }

            .latest-post-item:last-child {
                border-bottom: none;
            }

            .latest-post-icon {
                width: 50px;
                height: 50px;
                border-radius: 8px;
                object-fit: cover;
                flex-shrink: 0;
            }

            .latest-post-content {
                flex: 1;
            }

            .latest-post-title {
                font-size: 0.95rem;
                margin-bottom: 0.5rem;
                color: #333;
            }

            .contacts-section h3 {
                margin-bottom: 1rem;
                color: #667eea;
            }

            .contact-link {
                display: block;
                padding: 0.5rem 0;
                color: #666;
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .contact-link:hover {
                color: #667eea;
            }

            /* Overlay */
            .overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                opacity: 0;
                visibility: hidden;
                transition: all 0.3s ease;
                z-index: 1000;
            }

            .overlay.active {
                opacity: 1;
                visibility: visible;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .content-grid {
                    grid-template-columns: 1fr;
                }

                .main-content {
                    padding: 1rem;
                }

                .post-card {
                    flex-direction: column;
                }
            }

            /* Thêm vào phần CSS trong home.jsp */
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

            /* Footer */
            .footer {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                margin-top: 4rem;
                padding: 3rem 2rem 2rem;
                box-shadow: 0 -4px 20px rgba(0,0,0,0.1);
            }

            .footer-content {
                max-width: 1200px;
                margin: 0 auto;
                display: grid;
                grid-template-columns: 2fr 1fr 1fr;
                gap: 3rem;
                margin-left: 280px;
            }

            .footer-section h3 {
                color: #667eea;
                margin-bottom: 1rem;
                font-size: 1.2rem;
            }

            .footer-links {
                list-style: none;
                padding: 0;
            }

            .footer-links li {
                margin-bottom: 0.5rem;
            }

            .footer-links a {
                color: #666;
                text-decoration: none;
                transition: color 0.3s ease;
            }
            a {
                text-decoration: none;
            }
            .footer-links a:hover {
                color: #667eea;
            }

            .system-description {
                color: #666;
                line-height: 1.6;
                margin-bottom: 1rem;
            }

            .footer-bottom {
                border-top: 1px solid rgba(0,0,0,0.1);
                margin-top: 2rem;
                padding-top: 1rem;
                text-align: center;
                color: #666;
                font-size: 0.9rem;
            }

            @media (max-width: 768px) {
                .footer-content {
                    grid-template-columns: 1fr;
                    gap: 2rem;
                }
            }
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

        </style>
    </head>
    <body>
        <!-- Left Sidebar -->
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


        <!-- Header -->
        <header class="header">
            <div class="header-content">

                <div class="logo">
                    <img src="${pageContext.request.contextPath}/IMAGE/WEB-logo.png" alt="Logo" style="height: 90px; vertical-align: middle; margin-right: 8px;">
                    Quiz Practice for Soft Skills
                </div>

                <div class="auth-buttons">
                    <c:choose>
                        <c:when test="${sessionScope.userAuth != null}">
                            <!-- Nếu đã đăng nhập, hiển thị tên user và nút Logout -->
                            <span class="user-welcome">Xin chào, ${sessionScope.userAuth.fullName}!</span>
                            <a href="<%= request.getContextPath() %>/logout" class="auth-btn login-btn">Logout</a>
                        </c:when>
                        <c:otherwise>
                            <!-- Nếu chưa đăng nhập, hiển thị nút Login và Sign Up -->
                            <a href="<%= request.getContextPath() %>/login" class="auth-btn login-btn">Login</a>
                            <a href="<%= request.getContextPath() %>/register" class="auth-btn signup-btn">Sign Up</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Slider Section -->
            <section class="slider-section">          
                <div class="slider-container">
                    <div class="slider" id="slider">
                        <c:forEach var="slider" items="${sliders}" varStatus="status">
                            <div class="slide" style="background-image: url('${slider.image}')" 
                                 onclick="window.open('${pageContext.request.contextPath}/quiz/${slider.id}', '_blank')">
                                <div class="slide-content">
                                    <h2 class="slide-title">${slider.title}</h2>
                                    <p>${slider.description}</p>
                                </div>
                            </div>
                        </c:forEach>           
                    </div>
                    <div class="slider-nav">
                        <div class="slider-dot active" onclick="goToSlide(0)"></div>
                        <div class="slider-dot" onclick="goToSlide(1)"></div>
                        <div class="slider-dot" onclick="goToSlide(2)"></div>
                        <div class="slider-dot" onclick="goToSlide(3)"></div>
                        <div class="slider-dot" onclick="goToSlide(4)"></div>
                    </div>
                </div>
            </section>

            <!-- Content Grid -->
            <div class="content-grid">
                <div>
                    <!-- Hot Posts Section -->
                    <section class="posts-section">
                        <div class="section-header">
                            <h2>🔥 Hot Posts</h2>
                        </div>
                        <div class="post-grid">                           
                            <c:forEach var="post" items="${hotPosts}">
                                <div class="post-card" onclick="window.open('${pageContext.request.contextPath}/post/${post.id}', '_blank')">
                                    <div class="post-thumbnail" style="background-image: url('${post.thumbnail}')"></div>
                                    <div class="post-info">
                                        <h3>${post.title}</h3>
                                        <p class="post-date">
                                            <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy" />
                                        </p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </section>

                    <!-- Featured Subjects Section -->
                    <section class="subjects-section">
                        <div class="section-header">
                            <h2>⭐ Featured Subjects</h2>
                        </div>
                        <div class="subject-grid">
                            <c:forEach var="subject" items="${featureSubjects}">
                                <div class="subject-card" onclick="window.location.href = '${pageContext.request.contextPath}/subject-detail?id=${subject.id}'">

                                    <div class="subject-thumbnail" style="background-image: url('${subject.thumbnail}')"></div>
                                    <h3 class="subject-title">${subject.title}</h3>
                                    <p class="subject-tagline">${subject.description}</p>
                                </div>
                            </c:forEach>
                        </div>
                    </section>
                </div>

                <!-- Right Sidebar -->
                <aside class="right-sidebar">
                    <div class="latest-posts">
                        <h3>📝 Latest Posts</h3>
                        <c:forEach var="latestPost" items="${latestPosts}">
                            <div class="latest-post-item" onclick="window.open('${pageContext.request.contextPath}/post/${latestPost.id}', '_blank')">
                                <img src="${latestPost.thumbnail}" alt="${latestPost.title}" class="latest-post-icon">
                                <div class="latest-post-content">
                                    <h4 class="latest-post-title">${latestPost.title}</h4>
                                    <p class="post-date">
                                        <fmt:formatDate value="${latestPost.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </p>
                                </div>
                            </div>
                        </c:forEach>

                    </div>

                    <div class="contacts-section">
                        <h3>📞 Static Contacts/Links</h3>
                        <a href="mailto:support@quizpractice.com" class="contact-link">support@quizpractice.com</a>
                        <a href="/phone" class="contact-link">Phone</a>
                        <a href="https://web.facebook.com/?locale=vi_VN&_rdc=1&_rdr#" class="contact-link">Facebook</a>
                        <a href="https://www.youtube.com/watch?v=XLEKGL0Zt0Q" class="contact-link" target="_blank">Youtube</a>
                    </div>
                </aside>
            </div>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>About Quiz Practice for Soft Skills</h3>
                    <p class="system-description">
                        Our soft skills quiz practice platform helps you improve communication, teamwork, critical thinking, 
                        and other essential skills for the modern workplace.
                        With a rich question bank and user-friendly interface, we are committed to providing the best learning experience.
                    </p>
                </div>

                <div class="footer-section">
                    <h3>Support</h3>
                    <ul class="footer-links">
                        <li><a href="#">Help Center</a></li>
                        <li><a href="#">About Us</a></li>
                        <li><a href="#">Terms of Service</a></li>
                        <li><a href="#">Privacy Policy</a></li>
                        <li><a href="#">Contact</a></li>
                    </ul>
                </div>

                <div class="footer-section">
                    <h3>Connect with Us</h3>
                    <ul class="footer-links">
                        <li><a href="mailto:support@quizpractice.com">Support Email</a></li>
                        <li><a href="https://web.facebook.com" target="_blank">Facebook</a></li>
                        <li><a href="https://www.youtube.com" target="_blank">YouTube</a></li>
                        <li><a href="#">Hotline: 1900-xxxx</a></li>
                    </ul>
                </div>
            </div>

            <div class="footer-bottom">
                <p>&copy; 2025 Quiz Practice for Soft Skills. All rights reserved.</p>
            </div>
        </footer>


        <script>
            // Hàm chuyển slider sang slide có chỉ số là index
            function goToSlide(index) {
                var slider = document.getElementById('slider');        // Lấy phần tử slider chính
                var dots = document.querySelectorAll('.slider-dot');   // Lấy tất cả các chấm đại diện cho slide
                var slides = document.querySelectorAll('.slide');      // Lấy danh sách các slide hiện có

                if (slider && dots.length > 0 && slides.length > 0) {  // Kiểm tra tất cả tồn tại
                    // Kiểm soát index không vượt quá giới hạn
                    if (index >= slides.length) {
                        index = 0;                                     // Nếu index vượt quá, quay về slide đầu
                    } else if (index < 0) {
                        index = slides.length - 1;                     // Nếu index âm, chuyển đến slide cuối
                    }

                    currentSlide = index;                              // Cập nhật chỉ số slide hiện tại
                    slider.style.transform = 'translateX(-' + (currentSlide * 100) + '%)'; // Di chuyển slider

                    for (var i = 0; i < dots.length; i++) {            // Duyệt qua các chấm (dots)
                        if (i === currentSlide) {
                            dots[i].classList.add('active');           // Gán class active cho chấm tương ứng
                        } else {
                            dots[i].classList.remove('active');        // Bỏ class active ở chấm khác
                        }
                    }
                }
            }

            var currentSlide = 0; // Biến lưu chỉ số của slide hiện tại

            // Hàm chạy khi trang được khởi tạo hoặc load lại
            function initializePage() {
                var slides = document.querySelectorAll('.slide');      // Lấy tất cả slide
                if (slides.length > 0) {
                    setInterval(function () {                          // Thiết lập chuyển slide tự động
                        currentSlide = (currentSlide + 1) % slides.length; // Tăng chỉ số slide và lặp lại
                        goToSlide(currentSlide);                       // Gọi hàm chuyển slide
                    }, 3000);                                          // Thời gian chuyển slide: 3 giây
                }

                var cards = document.querySelectorAll('.post-card, .subject-card, .latest-post-item'); // Lấy tất cả thẻ hiển thị nội dung
                for (var i = 0; i < cards.length; i++) {
                    cards[i].style.opacity = '1';                      // Đặt opacity = 1 để hiện rõ
                    cards[i].style.transform = 'translateY(0)';        // Reset lại vị trí di chuyển về 0
                    cards[i].style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                    // Áp dụng hiệu ứng mượt mà khi card hiện ra: mờ và dịch chuyển
                }

                // Lắng nghe phím ESC để ẩn sidebar
                document.addEventListener('keydown', function (e) {
                    if (e.keyCode === 27) {                            // 27 là mã ESC
                        closeSidebar();                                // Gọi hàm đóng sidebar
                    }
                });
            }

            // Nếu trang chưa load xong, gắn sự kiện DOMContentLoaded
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', initializePage);
            }
        </script>
    </body>
</html>