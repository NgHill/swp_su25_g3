<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">    
    <title>Quiz Review</title>
    <style>
        /* RESET & BODY LAYOUT */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            display: flex;
            min-height: 100vh;
        }

        /* SIDEBAR */
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

        /* MAIN CONTENT */
        main {
            flex: 1;
            margin-left: 200px;
            transition: margin-left 0.3s ease-in-out;
            display: flex;
            flex-direction: column;
        }

        .sidebar.hidden + main {
            margin-left: 0;
        }

        /* HEADER */
        header {
            position: relative;
            background-color: #277AB0;
            color: white;
            padding: 15px 20px;
            height: 60px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        #toggleSidebar {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            background-color: #34495e;
            color: white;
            padding: 8px 12px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 500;
        }

        #toggleSidebar:hover {
            background-color: #2c3e50;
            transform: translateY(-50%) scale(1.05);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }

        .header-title {
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            line-height: 60px;
        }

        /* QUIZ REVIEW CONTENT */
        .quiz-content {
            flex: 1;
            background-color: #e8e8e8;
            padding: 20px;
            min-height: calc(100vh - 60px);
        }

        /* QUIZ HEADER SECTION */
        .quiz-header-section {
            background-color: #8fa8b8;
            padding: 15px 20px;
            margin-bottom: 20px;
            border-radius: 5px;
            color: white;
        }

        .quiz-title {
            font-size: 14px;
            text-align: center;
            margin-bottom: 15px;
        }

        .quiz-stats {
            display: flex;
            justify-content: space-around;
            align-items: center;
        }

        .stat-box {
            text-align: center;
        }

        .stat-label {
            font-size: 12px;
            margin-bottom: 5px;
        }

        .stat-value {
            font-size: 16px;
            font-weight: bold;
        }

        /* QUESTIONS REVIEW */
        .questions-section {
            background-color: #d4d4d4;
            border-radius: 5px;
            padding: 20px;
        }

        .section-title {
            font-size: 14px;
            color: #333;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .question-item {
            background: white;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .question-text {
            font-size: 13px;
            color: #333;
            margin-bottom: 15px;
            line-height: 1.4;
        }

        .answer-options {
            margin-bottom: 10px;
        }

        .answer-option {
            padding: 5px 0;
            margin: 3px 0;
            display: flex;
            align-items: center;
        }

        .option-radio {
            width: 14px;
            height: 14px;
            border-radius: 50%;
            border: 1px solid #999;
            margin-right: 8px;
            position: relative;
            flex-shrink: 0;
        }

        .option-radio.selected {
            border-color: #333;
            background-color: #333;
        }

        .option-radio.correct {
            border-color: #28a745;
            background-color: #28a745;
        }

        .option-radio.selected::after {
            content: '';
            width: 6px;
            height: 6px;
            background-color: white;
            border-radius: 50%;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }

        .option-text {
            color: #333;
            font-size: 12px;
            flex: 1;
        }

        .option-text.incorrect {
            color: #dc3545;
        }

        .option-status {
            font-size: 11px;
            font-weight: bold;
            color: #dc3545;
        }

        .correct-answer {
            font-size: 11px;
            color: #666;
            margin-top: 8px;
            font-style: italic;
        }

        /* ACTION BUTTONS */
        .action-buttons {
            text-align: center;
            margin-top: 20px;
        }

        .btn {
            padding: 10px 25px;
            border: none;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .btn-success {
            background-color: #28a745;
            color: white;
        }

        .btn-success:hover {
            background-color: #218838;
            transform: translateY(-2px);
        }

        /* RESPONSIVE */
        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                transform: translateX(-100%);
            }

            main {
                margin-left: 0;
            }

            .quiz-stats {
                flex-direction: column;
                gap: 10px;
            }

            .quiz-content {
                padding: 15px;
            }
        }
        
        .text-answer {
            margin-bottom: 10px;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 4px;
        }

        .user-text-answer {
            font-size: 12px;
            color: #333;
        }

        .correct-text {
            color: #28a745;
            font-weight: bold;
        }

        .incorrect-text {
            color: #dc3545;
            font-weight: bold;
        }

        .answer-status {
            margin-left: 10px;
            font-size: 11px;
            font-weight: bold;
        }

        .answer-status.correct {
            color: #28a745;
        }

        .answer-status.incorrect {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <nav class="sidebar" id="sidebar">
        <ul>
            <li><a href="<%= request.getContextPath() %>/home">Home</a></li>
            <li><a href="<%= request.getContextPath() %>/subject">Subject</a></li>
            <li><a href="<%= request.getContextPath() %>/myRegistration">My Registrations</a></li>
            <li><a href="<%= request.getContextPath() %>/settings">Settings</a></li>
        </ul>
    </nav>

    <main>
        <!-- Header -->
        <header>
            <a href="#" id="toggleSidebar">☰</a>
            <h1 class="header-title">Quiz Review</h1>
        </header>

        <!-- Quiz Review Content -->
        <div class="quiz-content">
            <!-- Quiz Header Section -->
            <div class="quiz-header-section">
                <div class="quiz-title">Subject: ${quiz.subject.title} | Duration: ${quiz.duration} minutes</div>
                <div class="quiz-stats">
                    <div class="stat-box">
                        <div class="stat-label">Score</div>
                        <div class="stat-value">${quizResult.score}</div>
                    </div>
                    <div class="stat-box">
                        <div class="stat-label">Correct/Total</div>
                        <div class="stat-value">${correctCount}/${totalQuestions}</div>
                    </div>
                    <div class="stat-box">
                        <div class="stat-label">Submitted</div>
                        <div class="stat-value">
                            <fmt:formatDate value="${quizResult.submittedAt}" pattern="dd/MM/yyyy HH:mm"/>
                        </div>
                    </div>
                </div>
            </div>

            <div class="questions-section">
                <div class="section-title">Question Review</div>

                <c:forEach var="question" items="${quiz.questions}" varStatus="status">
                    <div class="question-item">
                        <div class="question-text">${status.index + 1}) ${question.content}</div>

                        <c:choose>
                            <c:when test="${question.questionType == 'text_input'}">
                                <!-- Text input question -->
                                <div class="text-answer">
                                    <div class="user-text-answer">
                                        Your answer: 
                                        <c:forEach var="userAnswer" items="${userAnswers}">
                                            <c:if test="${userAnswer.questionIndex == status.index}">
                                                <span class="${userAnswer.correct ? 'correct-text' : 'incorrect-text'}">
                                                    "${userAnswer.userAnswer}"
                                                </span>
                                                <span class="answer-status ${userAnswer.correct ? 'correct' : 'incorrect'}">
                                                    ${userAnswer.correct ? '✓ Correct' : '✗ Incorrect'}
                                                </span>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Multiple choice question -->
                                <div class="answer-options">
                                    <c:forEach var="answer" items="${question.answers}">
                                        <div class="answer-option">
                                            <c:set var="isUserAnswer" value="false"/>
                                            <c:set var="isCorrectAnswer" value="${answer.correct}"/>

                                            <!-- Check if this is user's answer -->
                                            <c:forEach var="userAnswer" items="${userAnswers}">
                                                <c:if test="${userAnswer.questionIndex == status.index}">
                                                    <c:choose>
                                                        <c:when test="${userAnswer.userAnswer == answer.id.toString() || userAnswer.userAnswer == answer.content}">
                                                            <c:set var="isUserAnswer" value="true"/>
                                                        </c:when>
                                                    </c:choose>
                                                </c:if>
                                            </c:forEach>

                                            <div class="option-radio ${isCorrectAnswer ? 'correct' : ''} ${isUserAnswer ? 'selected' : ''}"></div>
                                            <div class="option-text ${isUserAnswer && !isCorrectAnswer ? 'incorrect' : ''}">
                                                ${answer.content}
                                            </div>

                                            <c:if test="${isUserAnswer && !isCorrectAnswer}">
                                                <div class="option-status">✗ Incorrect (Your answer)</div>
                                            </c:if>
                                            <c:if test="${isCorrectAnswer && isUserAnswer}">
                                                <div class="option-status" style="color: #28a745;">✓ Correct</div>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- Show correct answer if user got it wrong -->
                                <c:set var="userGotCorrect" value="false"/>
                                <c:forEach var="userAnswer" items="${userAnswers}">
                                    <c:if test="${userAnswer.questionIndex == status.index && userAnswer.correct}">
                                        <c:set var="userGotCorrect" value="true"/>
                                    </c:if>
                                </c:forEach>

                                <c:if test="${!userGotCorrect}">
                                    <c:forEach var="answer" items="${question.answers}">
                                        <c:if test="${answer.correct}">
                                            <div class="correct-answer">The correct answer: ${answer.content}</div>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
            </div>

            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <a href="<%= request.getContextPath() %>/quiz" class="btn btn-success">Take Another Practice Quiz</a>
            </div>
        </div>
    </main>

    <script>
        document.getElementById("toggleSidebar").addEventListener("click", function (e) {
            e.preventDefault();
            document.querySelector(".sidebar").classList.toggle("hidden");
        });
    </script>
</body>
</html>