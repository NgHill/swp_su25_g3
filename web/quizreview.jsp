<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <title>Kết quả Quiz - Kiến thức cơ bản về JavaScript</title>
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
            padding: 20px;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #4CAF50, #45a049);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .quiz-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 15px;
        }
        
        .score-display {
            font-size: 48px;
            font-weight: bold;
            margin: 10px 0;
        }
        
        .score-text {
            font-size: 18px;
            opacity: 0.9;
        }
        
        .content {
            padding: 30px;
        }
        
        .question-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 25px;
            border-left: 5px solid #dee2e6;
            transition: all 0.3s ease;
        }
        
        .question-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .question-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .question-number {
            background: #6c757d;
            color: white;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 15px;
            font-size: 16px;
        }
        
        .question-text {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            flex: 1;
        }
        
        .status-icon {
            width: 28px;
            height: 28px;
            margin-left: 10px;
        }
        
        .correct-icon {
            color: #28a745;
        }
        
        .incorrect-icon {
            color: #dc3545;
        }
        
        .options-list {
            list-style: none;
            margin-top: 15px;
        }
        
        .option-item {
            padding: 15px 20px;
            margin: 10px 0;
            border-radius: 8px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
            font-size: 16px;
            position: relative;
        }
        
        .option-correct {
            background-color: #d4edda !important;
            border-color: #28a745 !important;
            color: #155724 !important;
            font-weight: 600;
        }
        
        .option-incorrect {
            background-color: #f8d7da !important;
            border-color: #dc3545 !important;
            color: #721c24 !important;
            font-weight: 600;
        }
        
        .option-default {
            background-color: #f8f9fa;
            color: #6c757d;
        }
        
        .option-badge {
            display: inline-block;
            margin-left: 10px;
            font-weight: bold;
            font-size: 14px;
        }
        
        .correct-answer-note {
            margin-top: 15px;
            padding: 15px 20px;
            background-color: #d1ecf1;
            border: 1px solid #bee5eb;
            border-radius: 8px;
            color: #0c5460;
            font-weight: 500;
            border-left: 4px solid #17a2b8;
        }
        
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #e9ecef;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary {
            background: #007bff;
            color: white;
        }
        
        .btn-primary:hover {
            background: #0056b3;
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #545b62;
            transform: translateY(-2px);
        }
        
        .statistics {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        
        .stat-number {
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 14px;
            opacity: 0.9;
        }
        
        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 10px;
            }
            
            .header {
                padding: 20px;
            }
            
            .content {
                padding: 20px;
            }
            
            .question-card {
                padding: 20px;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn {
                width: 100%;
                max-width: 200px;
            }
            
            .question-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">

        <div class="header">
            <div class="quiz-title">${quiz.title}</div>
        </div>
        

        <div class="content">
            <!-- Thống kê -->
            <div class="statistics">
                <div class="stat-card">
                    <div class="stat-number">${correctCount}</div>
                    <div class="stat-label">Câu đúng</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${incorrectCount}</div>
                    <div class="stat-label">Câu sai</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${quizResult.score}</div>
                    <div class="stat-label">Số điểm</div>
                </div>
            </div>

            <c:forEach var="question" items="${quiz.questions}" varStatus="status">
                <div class="question-card">
                    <div class="question-header">
                        <div class="question-number">${status.index + 1}</div>
                        <div class="question-text">${question.content}</div>

                        <!-- Hiển thị trạng thái đúng/sai/không trả lời -->
                        <c:choose>
                            <c:when test="${userAnswers[status.index].hasAnswer() && userAnswers[status.index].correct}">
                                <svg class="status-icon correct-icon" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                                </svg>
                            </c:when>
                            <c:when test="${userAnswers[status.index].hasAnswer() && !userAnswers[status.index].correct}">
                                <svg class="status-icon incorrect-icon" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
                                </svg>
                            </c:when>
                            <c:otherwise>
                                <!-- Icon cho không trả lời -->
                                <svg class="status-icon" style="color: #ffc107;" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-3a1 1 0 00-.867.5 1 1 0 11-1.731-1A3 3 0 0113 8a3.001 3.001 0 01-2 2.83V11a1 1 0 11-2 0v-1a1 1 0 011-1 1 1 0 100-2zm0 8a1 1 0 100-2 1 1 0 000 2z" clip-rule="evenodd"/>
                                </svg>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <ul class="options-list">
                        <c:choose>
                            <c:when test="${question.questionType == 'text_input'}">
                                <!-- Text Input Question -->
                                <c:choose>
                                    <c:when test="${userAnswers[status.index].hasAnswer()}">
                                        <li class="option-item 
                                            <c:choose>
                                                <c:when test="${userAnswers[status.index].correct}">option-correct</c:when>
                                                <c:otherwise>option-incorrect</c:otherwise>
                                            </c:choose>">
                                            <strong>Câu trả lời của bạn:</strong> ${userAnswers[status.index].userAnswer}
                                            <c:choose>
                                                <c:when test="${userAnswers[status.index].correct}">
                                                    <span class="option-badge">✓ Đúng</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="option-badge">✗ Sai</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="option-item option-incorrect">
                                            <strong>Bạn chưa trả lời câu hỏi này</strong>
                                            <span class="option-badge">✗ Không trả lời</span>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <!-- Multiple Choice Question -->
                                <c:forEach var="answer" items="${question.answers}">
                                    <c:set var="isUserChoice" value="${userAnswers[status.index].userAnswerId != null && userAnswers[status.index].userAnswerId == answer.id}" />

                                    <li class="option-item 
                                        <c:choose>
                                            <c:when test="${answer.correct}">option-correct</c:when>
                                            <c:when test="${isUserChoice && !answer.correct}">option-incorrect</c:when>
                                            <c:otherwise>option-default</c:otherwise>
                                        </c:choose>">

                                        ${answer.content}

                                        <!-- Hiển thị badge -->
                                        <c:choose>
                                            <c:when test="${isUserChoice && answer.correct}">
                                                <span class="option-badge">✓ Bạn đã chọn - Đúng</span>
                                            </c:when>
                                            <c:when test="${isUserChoice && !answer.correct}">
                                                <span class="option-badge">✗ Bạn đã chọn - Sai</span>
                                            </c:when>
                                            <c:when test="${answer.correct && !isUserChoice}">
                                                <span class="option-badge">✓ Đáp án đúng</span>
                                            </c:when>
                                        </c:choose>
                                    </li>
                                </c:forEach>

                                <!-- Hiển thị thông báo nếu không chọn đáp án nào -->
                                <c:if test="${userAnswers[status.index].userAnswerId == null}">
                                    <li class="option-item option-incorrect" style="margin-top: 10px; font-style: italic;">
                                        <strong>⚠️ Bạn chưa chọn đáp án nào cho câu hỏi này</strong>
                                        <span class="option-badge">✗ Không trả lời</span>
                                    </li>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </ul>

                    <!-- Hiển thị giải thích đáp án đúng -->
                    <c:if test="${!userAnswers[status.index].correct || !userAnswers[status.index].hasAnswer()}">
                        <div class="correct-answer-note">
                            <strong>💡 Đáp án đúng:</strong> 
                            <c:choose>
                                <c:when test="${question.questionType == 'text_input'}">
                                    <c:forEach var="answer" items="${question.answers}" varStatus="ansStatus">
                                        <c:if test="${answer.correct}">
                                            ${answer.content}<c:if test="${!ansStatus.last}">, </c:if>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="answer" items="${question.answers}">
                                        <c:if test="${answer.correct}">
                                            ${answer.content}
                                            <c:if test="${not empty answer.explanation}">
                                                <br/><em>Giải thích: ${answer.explanation}</em>
                                            </c:if>
                                        </c:if>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </div>
            </c:forEach>                     
            
            <!-- Nút hành động -->
            <div class="action-buttons">
                <a href="#" class="btn btn-secondary" onclick="history.back()">
                    <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                        <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
                    </svg>
                    Về danh sách Quiz
                </a>
            </div>
        </div>
    </div>
</body>
</html>