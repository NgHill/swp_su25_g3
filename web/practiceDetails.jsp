<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Practice Details</title>
        <!-- Đường dẫn css tuyệt đối -->
        <style>
            /* Tổng thể */
            header h1 {
                flex-grow: 1;
                text-align: center;
                margin: 0;
            }

            body {
                font-family: Arial, sans-serif;
                background-color: #f0f0f0;
                display: flex;
                margin: 0;
                padding: 0;
                min-height: 100vh;
            }

            /* Sidebar với smooth animation */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

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

            /* Main Content với smooth transition */
            main {
                flex-grow: 1;
                padding: 20px;
                margin-left: 240px;
                transition: margin-left 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            }

            .sidebar.hidden ~ main {
                margin-left: 0;
            }

            /* Header */
            header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background-color: #277AB0;
                color: white;
                padding: 15px 20px;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            #toggleSidebar {
                background-color: #34495e;
                color: white;
                padding: 8px 12px;
                text-decoration: none;
                border-radius: 4px;
                transition: all 0.2s ease;
                font-weight: 500;
            }

            #toggleSidebar:hover {
                background-color: #2c3e50;
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            }

            /* Bảng chi tiết */
            .detail-table {
                width: 100%;
                background-color: white;
                border-collapse: collapse;
                margin-top: 20px;
                box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
                overflow: hidden;
            }

            .detail-table th,
            .detail-table td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }

            .detail-table th {
                background-color: #f2f2f2;
                width: 180px;
                font-weight: 600;
            }

            .detail-table tr:hover {
                background-color: #f9f9f9;
            }

            /* Nút Review Quiz */
            .center-button {
                text-align: center;
                margin: 20px 0;
            }

            .review-btn {
                padding: 10px 30px;
                background-color: #277AB0;
                color: white;
                border: none;
                font-weight: bold;
                cursor: pointer;
                border-radius: 4px;
                font-size: 16px;
                transition: all 0.2s ease;
            }

            .review-btn:hover {
                background-color: #005a99;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            }

            .review-btn:active {
                transform: translateY(0);
            }

            /* Form New Practice */
            .new-practice {
                background-color: white;
                padding: 20px;
                margin-top: 150px;
                border-radius: 8px;
                box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
                text-align: center;
                transition: box-shadow 0.2s ease;
            }

            .new-practice:hover {
                box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.15);
            }

            .new-practice h2 {
                margin-bottom: 20px;
                color: #277AB0;
                font-weight: 600;
            }

            .practice-form {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                justify-content: center;
                max-width: 700px;
                margin: 0 auto;
            }

            .practice-form label {
                display: flex;
                flex-direction: column;
                font-size: 16px;
                font-weight: 500;
            }

            .practice-form select,
            .practice-form input {
                padding: 8px;
                font-size: 14px;
                margin-top: 5px;
                border-radius: 4px;
                border: 1px solid #ccc;
                transition: border-color 0.2s ease, box-shadow 0.2s ease;
            }

            .practice-form select:focus,
            .practice-form input:focus {
                outline: none;
                border-color: #277AB0;
                box-shadow: 0 0 0 2px rgba(39, 122, 176, 0.2);
            }

            .practice-form button {
                margin-top: 20px;
                padding: 10px 30px;
                background-color: #277AB0;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: bold;
                grid-column: span 2;
                justify-self: center;
                transition: all 0.2s ease;
            }

            .practice-form button:hover {
                background-color: #005a99;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            }

            .practice-form button:active {
                transform: translateY(0);
            }

            /* Footer */
            .footer {
                background-color: #277AB0;
                color: white;
                text-align: center;
                padding: 20px;
                margin-top: 40px;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .sidebar {
                    width: 200px;
                    transform: translateX(-100%);
                }

                main {
                    margin-left: 0;
                }

                .sidebar.show {
                    transform: translateX(0);
                }

                .practice-form {
                    grid-template-columns: 1fr;
                }

                .practice-form button {
                    grid-column: span 1;
                }
            }
            .avatar-wrapper {
                width: 60px;
                height: 60px;
                background-color: #95a5a6;
                border-radius: 50%;
                margin: auto;
                margin-top:10px;
                display: flex;
                justify-content: center;
                align-items: center;
                cursor: pointer;
                overflow: hidden;
            }

            .avatar-img {
                width: 50px;     /* Nhỏ hơn wrapper một chút */
                height: 50px;
                border-radius: 50%;
                object-fit: cover;
                background-color: transparent;

            }

            .avatar-wrapper .avatar-icon {
                font-size: 24px;
                color: white;
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <nav class="sidebar" id="sidebar">
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
                <li><a href="<%= request.getContextPath() %>/home">Home</a></li>
                <li><a href="<%= request.getContextPath() %>/subject">Subject</a></li>
                <li><a href="<%= request.getContextPath() %>/myRegistration">My registration</a></li>
                <li><a href="${pageContext.request.contextPath}/blog">Blog list</a></li>
                <li><a href="<%= request.getContextPath() %>/settings">Setting</a></li>
            </ul>
        </nav>

        <main>
            <header>
                <a href="#" id="toggleSidebar">☰ Toggle Sidebar</a>
                <h1>Practice Details</h1>
            </header>

            <div class="quiz-details">
                <table class="detail-table">
                    <c:set var="pd" value="${practiceDetail}" />
                    <tr><th>Title</th><td>${pd.quizTitle}</td></tr>
                    <tr><th>Description</th><td>${pd.subjectDescription}</td></tr>
                    <tr><th>Type</th><td>Multiple-Choice Quiz</td></tr>
                    <tr><th>Time Limit</th><td>${pd.duration}</td></tr>
                    <tr><th>Submitted at</th><td>${pd.submittedAt}</td></tr>
                    <tr><th>Score</th><td>${pd.score}</td></tr>
                </table>
                <div class="center-button">
                    <a href="<%= request.getContextPath() %>/quiz-review?resultId=${practiceDetail.resultId}" class="review-btn" style="text-decoration: none; display: inline-block;">Review Quiz</a>
                </div>
            </div>

            <div class="new-practice">
                <h2>New Practice</h2>
                <form class="practice-form" method="get" action="<%= request.getContextPath() %>/practicedetails">
                    <!-- Hidden field để giữ quizResultId -->
                    <input type="hidden" name="quizResultId" value="${param.quizResultId}">

                    <label>
                        Subject:
                        <select name="subjectId" onchange="this.form.submit()">
                            <option value="">Select Subject</option>
                            <c:forEach var="subject" items="${registeredSubjects}">
                                <option value="${subject.id}" 
                                        <c:if test="${subject.id == selectedSubjectId}">selected</c:if>>
                                    ${subject.title}
                                </option>
                            </c:forEach>
                        </select>
                    </label>

                    <label>
                        Quizzes:
                        <select name="quizId">
                            <option value="">Select Quiz</option>
                            <c:forEach var="quiz" items="${quizzes}">
                                <option value="${quiz.id}">${quiz.title}</option>
                            </c:forEach>
                        </select>
                    </label>

                    <button type="button" onclick="startPractice()">Start Practicing</button>
                </form>
            </div>

            <footer class="footer">
                <p><strong>Quiz Practice for soft skills</strong></p>
                <p>Quiz Practice for Soft Skills is a platform that empowers learners to improve their communication, teamwork, and problem-solving abilities through engaging quizzes and step-by-step feedback.</p>
                <p>Phone: 1900 1509 &nbsp;&nbsp;&nbsp; Email: quizpractice@gmail.com</p>
            </footer>
        </main>

        <script>
            // Toggle sidebar functionality
            document.getElementById("toggleSidebar").addEventListener("click", function (e) {
                e.preventDefault(); // Ngăn trình duyệt nhảy lên đầu trang do href="#"
                document.querySelector(".sidebar").classList.toggle("hidden"); // Toggle class 'hidden'
            });
            
            function startPractice() {
                const subjectId = document.querySelector('select[name="subjectId"]').value;
                const quizId = document.querySelector('select[name="quizId"]').value;

                if (!subjectId) {
                    alert('Please select a subject');
                    return;
                }

                if (!quizId) {
                    alert('Please select a quiz');
                    return;
                }

                // Redirect đến trang quiz với quizId và userId
                window.location.href = '<%= request.getContextPath() %>/quizhandle?quizId=' + quizId + '&userId=${sessionScope.userAuth.id}&questionIndex=0';
            }
            
            // Toggle sidebar functionality (giữ nguyên code cũ)
            document.getElementById("toggleSidebar").addEventListener("click", function (e) {
                e.preventDefault();
                document.querySelector(".sidebar").classList.toggle("hidden");
            });
        </script>
    </body>
</html>