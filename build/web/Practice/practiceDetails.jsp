<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Practice Details</title>
    <!-- Đường dẫn css tuyệt đối -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/practiceDetails.css" />
</head>
<body>
    <!-- Sidebar -->
    <nav class="sidebar">
            <a href="profile.html">
                <div class="avatar-wrapper">
                    <img src="images/avatar.png" alt="Avatar" class="avatar-img">
                </div>
            </a>
            <ul>
                <li><a href="home">Home</a></li>
                <li><a href="subject">Subject</a></li>
                <li><a href="myRegistration">My Registrations</a></li>
                <li><a href="#">Setting</a></li>
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
                <button class="review-btn">Review Quiz</button>
            </div>
        </div>

        <div class="new-practice">
            <h2>New Practice</h2>
            <form class="practice-form">
                <label>
                    Subject:
                    <select>
                        <option>Subject</option>
                    </select>
                </label>
                <label>
                    Number of question:
                    <select>
                        <option>20</option>
                        <option>30</option>
                        <option>50</option>
                    </select>
                </label>
                <label>
                    Date:
                    <input type="date" placeholder="DD/MM/YYYY" />
                </label>
                <label>
                    Time (minutes):
                    <select>
                        <option>30</option>
                        <option>45</option>
                        <option>60</option>
                    </select>
                </label>
                <button type="submit">Start Practicing</button>
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
    </script>
</body>
</html>