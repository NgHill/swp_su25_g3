<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz Practice for Soft Skills - Trang Chủ</title>
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
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
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

        /* Left Sidebar */
        .sidebar {
            position: fixed;
            left: -280px;
            top: 0;
            width: 280px;
            height: 100vh;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(15px);
            box-shadow: 2px 0 20px rgba(0,0,0,0.1);
            transition: left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 1001;
            overflow-y: auto;
        }

        .sidebar.active {
            left: 0;
        }

        .sidebar-header {
            padding: 2rem 1.5rem;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            text-align: center;
        }

        .sidebar-nav {
            padding: 2rem 0;
        }

        .nav-item {
            display: flex;
            align-items: center;
            padding: 1rem 1.5rem;
            color: #333;
            text-decoration: none;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        .nav-item:hover {
            background: rgba(102, 126, 234, 0.1);
            border-left-color: #667eea;
            transform: translateX(5px);
        }

        .nav-icon {
            margin-right: 12px;
            font-size: 1.2rem;
        }

        /* Main Content */
        .main-content {
            max-width: 1200px;
            margin: 0 auto;
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
    border-radius: 50%;
    object-fit: cover;
}
    </style>
</head>
<body>
    <!-- Overlay -->
    <div class="overlay" id="overlay" onclick="closeSidebar()"></div>

    <!-- Left Sidebar -->
    <div class="sidebar" id="sidebar">
        <a href="<%= request.getContextPath() %>/profile">
            <div class="avatar-wrapper">
                <div class="avatar-img">👤</div>
            </div>
        </a>
        <nav class="sidebar-nav">
            <a href="#" class="nav-item">
                <span class="nav-icon">🏠</span>
                <span>Home</span>
            </a>
            <a href="#" class="nav-item">
                <span class="nav-icon">🧠</span>
                <span>Subject</span>
            </a>
            <a href="#" class="nav-item">
                <span class="nav-icon">📝</span>
                <span>My Registrations</span>
            </a>
            <a href="#" class="nav-item">
                <span class="nav-icon">⚙️</span>
                <span>Settings</span>
            </a>
        </nav>
    </div>

    <!-- Header -->
    <header class="header">
        <div class="header-content">
            <button class="menu-toggle" onclick="toggleSidebar()">
                ☰ 
            </button>
            <div class="logo">🧠 Quiz Practice for Soft Skills</div>
            <div class="auth-buttons">
                <a href="<%= request.getContextPath() %>/login" class="auth-btn login-btn">Login</a>
                <a href="<%= request.getContextPath() %>/register" class="auth-btn signup-btn">Sign Up</a>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Slider Section -->
        <section class="slider-section">          
            <div class="slider-container">
                <div class="slider" id="slider">
                    <div class="slide" style="background-image: url('https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80')" onclick="window.open('/quiz-practice/communication-skills', '_blank')">
                        <div class="slide-content">
                            <h2 class="slide-title">🗣️ Communication Skills Challenge</h2>
                            <p>Master the art of effective communication through interactive quizzes</p>
                        </div>
                    </div>
                    <div class="slide" style="background-image: url('https://images.unsplash.com/photo-1556761175-b413da4baf72?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80')" onclick="window.open('/quiz-practice/leadership', '_blank')">
                        <div class="slide-content">
                            <h2 class="slide-title">👑 Leadership Excellence Quiz</h2>
                            <p>Develop your leadership potential with scenario-based questions</p>
                        </div>
                    </div>
                    <div class="slide" style="background-image: url('https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80')" onclick="window.open('/quiz-practice/teamwork', '_blank')">
                        <div class="slide-content">
                            <h2 class="slide-title">🤝 Teamwork & Collaboration</h2>
                            <p>Enhance your ability to work effectively in diverse teams</p>
                        </div>
                    </div>
                </div>
                <div class="slider-nav">
                    <div class="slider-dot active" onclick="goToSlide(0)"></div>
                    <div class="slider-dot" onclick="goToSlide(1)"></div>
                    <div class="slider-dot" onclick="goToSlide(2)"></div>
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
                        <div class="post-card" onclick="window.open('/quiz-practice/emotional-intelligence', '_blank')">
                            <div class="post-thumbnail" style="background-image: url('https://images.unsplash.com/photo-1559757148-5c350d0d3c56?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80')"></div>
                            <div class="post-info">
                                <h3>🧭 Emotional Intelligence Mastery Quiz</h3>
                                <p class="post-date">12/06/2025</p>
                            </div>
                        </div>
                        <div class="post-card" onclick="window.open('/quiz-practice/problem-solving', '_blank')">
                            <div class="post-thumbnail" style="background-image: url('https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80')"></div>
                            <div class="post-info">
                                <h3>🧩 Creative Problem Solving Challenge</h3>
                                <p class="post-date">12/06/2025</p>
                            </div>
                        </div>
                        <div class="post-card" onclick="window.open('/quiz-practice/time-management', '_blank')">
                            <div class="post-thumbnail" style="background-image: url('https://images.unsplash.com/photo-1434030216411-0b793f4b4173?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80')"></div>
                            <div class="post-info">
                                <h3>⏰ Time Management & Productivity Quiz</h3>
                                <p class="post-date">12/06/2025</p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Featured Subjects Section -->
                <section class="subjects-section">
                    <div class="section-header">
                        <h2>⭐ Featured Subjects</h2>
                    </div>
                    <div class="subject-grid">
                        <div class="subject-card" onclick="window.open('/quiz-practice/category/interpersonal', '_blank')">
                            <div class="subject-thumbnail" style="background-image: url('https://images.unsplash.com/photo-1521737711867-e3b97375f902?ixlib=rb-4.0.3&auto=format&fit=crop&w=120&q=80')"></div>
                            <h3 class="subject-title">🤝 Interpersonal Skills</h3>
                            <p class="subject-tagline">Build stronger relationships and networking abilities</p>
                        </div>
                        <div class="subject-card" onclick="window.open('/quiz-practice/category/critical-thinking', '_blank')">
                            <div class="subject-thumbnail" style="background-image: url('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=120&q=80')"></div>
                            <h3 class="subject-title">🧠 Critical Thinking</h3>
                            <p class="subject-tagline">Develop analytical and decision-making skills</p>
                        </div>
                        <div class="subject-card" onclick="window.open('/quiz-practice/category/adaptability', '_blank')">
                            <div class="subject-thumbnail" style="background-image: url('https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-4.0.3&auto=format&fit=crop&w=120&q=80')"></div>
                            <h3 class="subject-title">🔄 Adaptability & Change</h3>
                            <p class="subject-tagline">Master flexibility in dynamic work environments</p>
                        </div>
                    </div>
                </section>
            </div>

            <!-- Right Sidebar -->
            <aside class="right-sidebar">
                <div class="latest-posts">
                    <h3> Latest Post</h3>
                    <div class="latest-post-item" onclick="window.open('/quiz-practice/results/leadership-quiz', '_blank')">
                        <img src="https://images.unsplash.com/photo-1556761175-b413da4baf72?ixlib=rb-4.0.3&auto=format&fit=crop&w=80&q=80" alt="Leadership" class="latest-post-icon">
                        <div class="latest-post-content">
                            <h4 class="latest-post-title">Leadership Assessment</h4>
                            <p class="post-date">2 hours ago</p>
                        </div>
                    </div>
                    <div class="latest-post-item" onclick="window.open('/quiz-practice/results/communication-quiz', '_blank')">
                        <img src="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-4.0.3&auto=format&fit=crop&w=80&q=80" alt="Communication" class="latest-post-icon">
                        <div class="latest-post-content">
                            <h4 class="latest-post-title">Communication Skills Practice</h4>
                            <p class="post-date">5 hours ago</p>
                        </div>
                    </div>
                    <div class="latest-post-item" onclick="window.open('/quiz-practice/results/teamwork-quiz', '_blank')">
                        <img src="https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?ixlib=rb-4.0.3&auto=format&fit=crop&w=80&q=80" alt="Teamwork" class="latest-post-icon">
                        <div class="latest-post-content">
                            <h4 class="latest-post-title">Teamwork Challenge</h4>
                            <p class="post-date">2 hours ago</p>
                        </div>
                    </div>
                    <div class="latest-post-item" onclick="window.open('/quiz-practice/results/problem-solving', '_blank')">
                        <img src="https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-4.0.3&auto=format&fit=crop&w=80&q=80" alt="Problem Solving" class="latest-post-icon">
                        <div class="latest-post-content">
                            <h4 class="latest-post-title">Problem Solving</h4>
                            <p class="post-date">3 hours ago</p>
                        </div>
                    </div>
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

    <script>
        // Global functions để có thể gọi từ HTML
        function toggleSidebar() {                               // Hàm bật/tắt sidebar
            var sidebar = document.getElementById('sidebar');    // Lấy phần tử sidebar theo ID
            var overlay = document.getElementById('overlay');    // Lấy phần tử lớp phủ overlay theo ID

            if (sidebar && overlay) {                            // Kiểm tra tồn tại cả 2 phần tử
                if (sidebar.classList.contains('active')) {      // Nếu sidebar đang hiển thị
                    sidebar.classList.remove('active');          // Gỡ class 'active' để ẩn sidebar
                    overlay.classList.remove('active');          // Gỡ class 'active' để ẩn overlay
                } else {
                    sidebar.classList.add('active');             // Thêm class 'active' để hiển thị sidebar
                    overlay.classList.add('active');             // Thêm class 'active' để hiển thị overlay
                }
            }
        }

        function closeSidebar() {                                // Hàm đóng sidebar thủ công
            var sidebar = document.getElementById('sidebar');    // Lấy sidebar
            var overlay = document.getElementById('overlay');    // Lấy overlay

            if (sidebar && overlay) {                            // Nếu cả 2 phần tử tồn tại
                sidebar.classList.remove('active');              // Gỡ class 'active' để ẩn sidebar
                overlay.classList.remove('active');              // Gỡ class 'active' để ẩn overlay
            }
        }

        function goToSlide(index) {                              // Hàm chuyển slider đến slide theo chỉ số
            var slider = document.getElementById('slider');      // Lấy slider theo ID
            var dots = document.querySelectorAll('.slider-dot'); // Lấy các chấm đại diện slide

            if (slider && dots.length > 0) {                     // Kiểm tra slider và tồn tại dot
                currentSlide = index;                            // Gán giá trị slide hiện tại
                slider.style.transform = 'translateX(-' + (currentSlide * 100) + '%)';  // Di chuyển slider theo phần trăm

                for (var i = 0; i < dots.length; i++) {          // Duyệt qua từng dot
                    if (i === currentSlide) {                    // Nếu là dot của slide hiện tại
                        dots[i].classList.add('active');         // Thêm class 'active' để làm nổi bật
                    } else {
                        dots[i].classList.remove('active');      // Gỡ class nếu không phải slide đang hiển thị
                    }
                }
            }
        }

        var currentSlide = 0;                                    // Khai báo biến lưu chỉ số slide hiện tại

        function initializePage() {                              // Hàm khởi tạo trang khi tải
            var slides = document.querySelectorAll('.slide');    // Lấy tất cả các phần tử slide
            if (slides.length > 0) {                             // Nếu có ít nhất 1 slide
                setInterval(function() {                         // Thiết lập vòng lặp chạy tự động
                    currentSlide = (currentSlide + 1) % slides.length;   // Tăng slide, quay vòng nếu đến cuối
                    goToSlide(currentSlide);                     // Gọi hàm chuyển đến slide mới
                }, 5000);                                        // Mỗi 5 giây chuyển slide 1 lần
            }

            var cards = document.querySelectorAll('.post-card, .subject-card, .latest-post-item'); // Lấy các card cần hiệu ứng
            for (var i = 0; i < cards.length; i++) {             // Duyệt qua từng card
                cards[i].style.opacity = '1';                    // Hiển thị card (từ mờ sang rõ)
                cards[i].style.transform = 'translateY(0)';      // Di chuyển card về vị trí ban đầu
                cards[i].style.transition = 'opacity 0.6s ease, transform 0.6s ease';  // Gán hiệu ứng chuyển động mượt
            }

            document.addEventListener('keydown', function(e) {   // Lắng nghe sự kiện nhấn phím
                if (e.keyCode === 27) {                          // Nếu phím ESC (mã 27)
                    closeSidebar();                              // Đóng sidebar khi nhấn ESC
                }
            });
        }

        // Kiểm tra trạng thái tải trang (JSP thường cần hỗ trợ cả 2 cách)
        if (document.readyState === 'loading') {                             // Nếu DOM chưa tải xong
            document.addEventListener('DOMContentLoaded', initializePage);   // Gán sự kiện khi DOM sẵn sàng
        } else {
            initializePage();                                     // Nếu DOM đã tải xong thì gọi luôn
        }

        window.onload = function() {                              // Khi toàn bộ trang (gồm ảnh, script) đã tải
            setTimeout(initializePage, 100);                      // Delay 100ms rồi gọi initializePage
        };

    </script>
</body>
</html>