<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Stimulation Exam</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/practiceList.css">


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
                                <td>${pl.quizResultId}</td>
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



