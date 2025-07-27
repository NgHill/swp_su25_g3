<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="elearning.BasicDAO.UserAnswerDAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Review Quiz: ${quiz.title}</title>
        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f7fa;
                color: #333;
                padding: 20px;
            }
            h1 {
                font-size: 2rem;
                margin-bottom: 10px;
                color: #2c3e50;
            }
            p.score {
                font-size: 1.1rem;
                margin-bottom: 30px;
                color: #34495e;
            }
            .question-container {
                background: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                padding: 20px;
                margin-bottom: 20px;
            }
            .question-container p.question-text {
                font-size: 1.1rem;
                margin-bottom: 15px;
            }
            .question-container ul {
                list-style: none;
                padding-left: 0;
            }
            .question-container ul li {
                margin-bottom: 8px;
                padding: 8px 12px;
                border-radius: 4px;
                transition: background 0.2s;
            }
            .question-container ul li:hover {
                background: #f0f0f0;
            }
            .correct {
                color: #27ae60;
                font-weight: bold;
            }
            .incorrect {
                color: #c0392b;
                font-weight: bold;
            }
            .back-button {
                position: fixed;
                bottom: 20px;
                right: 20px;
                background-color: #2980b9;
                color: #fff;
                text-decoration: none;
                padding: 12px 20px;
                border-radius: 50px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.2);
                transition: background 0.2s, transform 0.1s;
                font-size: 0.95rem;
            }
            .back-button:hover {
                background-color: #1f6391;
                transform: translateY(-2px);
            }
        </style>
    </head>
    <body>
        <h1>Review Quiz: <c:out value="${quiz.title}" /></h1>
        <p class="score">
            Your score: <strong><c:out value="${quizResult.score}" /></strong>
        </p>

        <c:forEach var="question" items="${quiz.questions}" varStatus="qs">
            <div class="question-container">
                <p class="question-text">
                    <strong>Question ${qs.index + 1}:</strong>
                    <c:out value="${question.content}" />
                </p>

                <c:set var="ua" value="${userAnswers[qs.index]}" />

                <c:choose>
                    <c:when test="${question.questionType == 'multiple_choice'}">
                        <ul>
                            <c:forEach var="ans" items="${question.answers}">
                                <li>
                                    <c:choose>
                                        <c:when test="${ua.answerId == ans.id}">
                                            <span class="${ans.correct ? 'correct' : 'incorrect'}">
                                                <c:out value="${ans.content}" />
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <c:if test="${ans.correct}">
                                                <span class="correct">
                                                    <c:out value="${ans.content}" />
                                                </span>
                                            </c:if>
                                            <c:if test="${!ans.correct}">
                                                <c:out value="${ans.content}" />
                                            </c:if>
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:when>
                    <c:when test="${question.questionType == 'text_input'}">
                        <p>
                            Your answer:
                            <span class="${ua.correct ? 'correct' : 'incorrect'}">
                                <c:out value="${ua.textAnswer}" />
                            </span>
                        </p>
                        <p>
                            Correct answer:
                            <c:forEach var="ans" items="${question.answers}">
                                <c:if test="${ans.correct}">
                                    <strong><c:out value="${ans.content}" /></strong>
                                </c:if>
                            </c:forEach>
                        </p>
                    </c:when>
                </c:choose>
            </div>
        </c:forEach>

     
        <a href="${pageContext.request.contextPath}/quizreview/delete?quizId=${quiz.id}"
           class="back-button">← Quay lại Review</a>

    </body>

</html>
