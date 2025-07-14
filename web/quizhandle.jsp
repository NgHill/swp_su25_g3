<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz: ${quiz.title}</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            color: #333;
        }

        .quiz-container {
            max-width: 800px;
            margin: 20px auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .quiz-header {
            background: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .quiz-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .question-counter {
            font-weight: bold;
            color: #6c757d;
        }

        .quiz-title {
            font-size: 16px;
            font-weight: bold;
            color: #495057;
        }

        .timer {
            background: #e3f2fd;
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: bold;
            color: #1976d2;
        }

        .quiz-body {
            padding: 30px;
        }

        .question-header {
            background: #6c757d;
            color: white;
            padding: 10px 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .question-text {
            line-height: 1.6;
            margin-bottom: 25px;
            font-size: 14px;
        }

        .options {
            margin-bottom: 30px;
        }

        .option {
            display: flex;
            align-items: flex-start;
            margin-bottom: 15px;
            cursor: pointer;
            padding: 10px;
            border-radius: 4px;
            transition: background-color 0.2s;
        }

        .option:hover {
            background-color: #f8f9fa;
        }

        .option input[type="radio"] {
            margin-right: 10px;
            margin-top: 2px;
        }

        .option-text {
            flex: 1;
            font-size: 14px;
            line-height: 1.4;
        }

        .quiz-footer {
            background: #f8f9fa;
            padding: 15px 20px;
            border-top: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .left-buttons {
            display: flex;
            gap: 10px;
        }

        .right-buttons {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.2s;
        }

        .btn-primary {
            background: #28a745;
            color: white;
        }

        .btn-primary:hover {
            background: #218838;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .btn-warning {
            background: #ffc107;
            color: #212529;
        }

        .btn-warning:hover {
            background: #e0a800;
        }

        .btn-success {
            background: #28a745;
            color: white;
        }

        .btn-success:hover {
            background: #218838;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background-color: white;
            margin: 15% auto;
            padding: 20px;
            border-radius: 8px;
            width: 80%;
            max-width: 500px;
            position: relative;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
        }

        .modal-title {
            font-weight: bold;
            font-size: 18px;
        }

        .close {
            font-size: 24px;
            cursor: pointer;
            color: #6c757d;
        }

        .close:hover {
            color: #000;
        }

        .modal-body {
            margin-bottom: 20px;
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .question-grid {
            display: grid;
            grid-template-columns: repeat(10, 1fr);
            gap: 8px;
            margin-bottom: 20px;
        }

        .question-number {
            width: 32px;
            height: 32px;
            border: 1px solid #ccc;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            border-radius: 4px;
            font-size: 12px;
            transition: all 0.2s;
        }

        .question-number:hover {
            background-color: #f8f9fa;
        }

        .question-number.answered {
            background-color: #28a745;
            color: white;
            border-color: #28a745;
        }

        .question-number.marked {
            background-color: #ffc107;
            color: #212529;
            border-color: #ffc107;
        }

        .question-number.unanswered {
            background-color: white;
            color: #6c757d;
        }

        .question-number.current {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }

        .peek-answer-content {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 4px;
            margin-top: 10px;
        }

        .peek-answer-content h4 {
            color: #28a745;
            margin-bottom: 10px;
        }

        .answer-explanation {
            font-size: 14px;
            line-height: 1.5;
            margin-bottom: 10px;
        }

        .answer-source {
            font-size: 12px;
            color: #6c757d;
            font-style: italic;
        }

        .confirmation-text {
            margin-bottom: 15px;
            font-size: 14px;
            line-height: 1.5;
        }

        @media (max-width: 768px) {
            .quiz-container {
                margin: 10px;
                border-radius: 0;
            }
            
            .quiz-header {
                flex-direction: column;
                gap: 10px;
                align-items: flex-start;
            }
            
            .quiz-footer {
                flex-direction: column;
                gap: 15px;
                align-items: stretch;
            }
            
            .left-buttons, .right-buttons {
                justify-content: center;
                order: 2;
            }
            
            .question-grid {
                grid-template-columns: repeat(5, 1fr);
            }
        }
            
        .text-input-container {
            margin-bottom: 30px;
        }

        .text-input {
            width: 100%;
            padding: 12px;
            font-size: 14px;
            border: 2px solid #e9ecef;
            border-radius: 4px;
            transition: border-color 0.2s;
        }

        .text-input:focus {
            outline: none;
            border-color: #007bff;
        }
    </style>
</head>
<body>
    <div class="quiz-container">
        <div class="quiz-header">
            <div class="quiz-info">
                <div class="quiz-title">${quiz.title}</div>
                <div class="question-counter">
                    <span id="currentQuestion">${currentQuestionIndex + 1}</span> / <span id="totalQuestions">${totalQuestions}</span>
                </div>
            </div>
            <div class="timer" id="timer">00:00:00</div>
        </div>

        <div class="quiz-body">
            <div class="question-header">
                <span id="questionNumber">${currentQuestionIndex + 1})</span>
                <span>Question ID: <span id="questionId">${currentQuestion.id}</span></span>
            </div>

            <div class="question-text" id="questionText">
                ${currentQuestion.content}
            </div>

            <div class="options" id="optionsContainer">
                <c:choose>
                    <c:when test="${currentQuestion.questionType == 'text_input'}">
                        <div class="text-input-container">
                            <input type="text" 
                                   name="textAnswer" 
                                   id="textAnswer" 
                                   placeholder="Enter your answer here..."
                                   value="${userAnswers[currentQuestionIndex]}"
                                   class="text-input">
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="answer" items="${currentQuestion.answers}" varStatus="status">
                            <div class="option">
                                <input type="radio" name="answer" value="${answer.id}" id="option${status.index}" 
                                       <c:if test="${userAnswers[currentQuestionIndex] eq answer.id}">checked</c:if>>
                                <label for="option${status.index}" class="option-text">
                                    ${answer.content}
                                </label>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="quiz-footer">
            <div class="left-buttons">
                <button class="btn btn-primary" id="reviewProgressBtn">Review Progress</button>
            </div>
            <div class="right-buttons">
                <c:if test="${isPracticeMode}">
                    <button class="btn btn-warning" id="peekAnswerBtn">Peek at Answer</button>
                </c:if>
                <c:if test="${currentQuestionIndex > 0}">
                    <button class="btn btn-secondary" id="prevBtn">Previous</button>
                </c:if>
                <c:if test="${currentQuestionIndex < totalQuestions - 1}">
                    <button class="btn btn-primary" id="nextBtn">Next</button>
                </c:if>
                <c:if test="${currentQuestionIndex == totalQuestions - 1}">
                    <button class="btn btn-success" id="scoreExamBtn">Score Exam</button>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Peek at Answer Modal -->
    <div id="peekAnswerModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Peek at Answer</h3>
                <span class="close" onclick="closePeekAnswerModal()">&times;</span>
            </div>
            <div class="modal-body">
                <c:choose>
                    <c:when test="${currentQuestion.questionType == 'text_input'}">
                        <p><strong>Correct answers include:</strong></p>
                        <ul>
                            <c:forEach var="answer" items="${currentQuestion.answers}">
                                <c:if test="${answer.correct}">
                                    <li>${answer.content}</li>
                                </c:if>
                            </c:forEach>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <c:set var="correctAnswer" value=""/>
                        <c:forEach var="answer" items="${currentQuestion.answers}">
                            <c:if test="${answer.correct}">
                                <c:set var="correctAnswer" value="${answer.content}"/>
                            </c:if>
                        </c:forEach>
                        <p><strong>The correct answer is: ${correctAnswer}</strong></p>
                    </c:otherwise>
                </c:choose>

                <div class="peek-answer-content">
                    <h4>Explanation:</h4>
                    <div class="answer-explanation">
                        <c:forEach var="answer" items="${currentQuestion.answers}">
                            <c:if test="${answer.correct && not empty answer.explanation}">
                                ${answer.explanation}
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closePeekAnswerModal()">Close</button>
            </div>
        </div>
    </div>

    <!-- Review Progress Modal -->
    <div id="reviewProgressModal" class="modal">
        <div class="modal-content" style="max-width: 600px;">
            <div class="modal-header">
                <h3 class="modal-title">Review Progress</h3>
                <span class="close" onclick="closeReviewProgressModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p style="margin-bottom: 15px;">Review before scoring exam</p>
                
                <div class="question-grid" id="questionGrid">
                    <c:forEach var="i" begin="0" end="${totalQuestions - 1}">
                        <div class="question-number 
                                    <c:if test="${i == currentQuestionIndex}">current</c:if>
                                    <c:if test="${not empty userAnswers[i]}">answered</c:if>
                                    <c:if test="${empty userAnswers[i]}">unanswered</c:if>" 
                             onclick="goToQuestion(${i})">
                            ${i + 1}
                        </div>
                    </c:forEach>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-success" onclick="scoreExamNow()">SCORE EXAM NOW</button>
            </div>
        </div>
    </div>

    <!-- Score Exam Confirmation Modal -->
    <div id="scoreExamModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Score Exam?</h3>
            </div>
            <div class="modal-body">
                <div class="confirmation-text" id="confirmationText">
                    By clicking on the [Score Exam] button below, you will complete your current exam and receive your score. You will not be able to change any answers after this point.
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeScoreExamModal()">← Back</button>
                <button class="btn btn-success" onclick="submitExam()">Score Exam</button>
            </div>
        </div>
    </div>

    <script>
        // Initialize quiz data from JSP
        let currentQuestionIndex = ${currentQuestionIndex};
        let totalQuestions = ${totalQuestions};
        let quizId = ${quiz.id};
        let userId = ${currentUserId};
        let timeLeft = ${timeLeft};
        let timerInterval;
        let isPracticeMode = ${isPracticeMode};

        // Get user answers from server
        let userAnswers = {};
        <c:forEach var="entry" items="${userAnswers}">
            userAnswers[${entry.key}] = '${entry.value}';
        </c:forEach>

        // Initialize quiz
        function initializeQuiz() {
            startTimer();
            if (!isPracticeMode) {
                const peekBtn = document.getElementById('peekAnswerBtn');
                if (peekBtn) {
                    peekBtn.style.display = 'none';
                }
            }
        }

        // Timer functions
        function startTimer() {
            updateTimerDisplay();
            timerInterval = setInterval(() => {
            timeLeft--;
            if (timeLeft <= 0) {
                alert('Time is up! The exam will be submitted automatically.');
                submitExam();
                return;
            }
            updateTimerDisplay();
        }, 1000);
        }

        function updateTimerDisplay() {
            const hours = Math.floor(timeLeft / 3600);
            const minutes = Math.floor((timeLeft % 3600) / 60);
            const seconds = timeLeft % 60;
            
            const timerElement = document.getElementById('timer');
            if (timerElement) {
                timerElement.textContent = 
                    hours.toString().padStart(2, '0') + ':' +
                    minutes.toString().padStart(2, '0') + ':' +
                    seconds.toString().padStart(2, '0');
            }
        }

        // Navigation functions
        function goToQuestion(index) {
            saveCurrentAnswer();
            window.location.href = '${pageContext.request.contextPath}/quizhandle?quizId=' + quizId + '&userId=' + userId + '&questionIndex=' + index;
        }

        function nextQuestion() {
            saveCurrentAnswer();
            if (currentQuestionIndex < totalQuestions - 1) {
                window.location.href = '${pageContext.request.contextPath}/quizhandle?quizId=' + quizId + '&userId=' + userId + '&questionIndex=' + (currentQuestionIndex + 1);
            }
        }

        function prevQuestion() {
            saveCurrentAnswer();
            if (currentQuestionIndex > 0) {
                window.location.href = '${pageContext.request.contextPath}/quizhandle?quizId=' + quizId + '&userId=' + userId + '&questionIndex=' + (currentQuestionIndex - 1);
            }
        }

        // Answer handling
        function saveCurrentAnswer() {
            const selectedAnswer = document.querySelector('input[name="answer"]:checked');
            const textAnswer = document.getElementById('textAnswer');

            let answerValue = null;
            let requestBody = 'action=saveAnswer&questionIndex=' + currentQuestionIndex;

            if (selectedAnswer) {
                // Multiple choice question
                answerValue = selectedAnswer.value;
                requestBody += '&selectedAnswer=' + encodeURIComponent(answerValue);
            } else if (textAnswer) {
                // Text input question
                answerValue = textAnswer.value.trim();
                requestBody += '&textAnswer=' + encodeURIComponent(answerValue);
            }

            if (answerValue) {
                fetch('${pageContext.request.contextPath}/quizhandle', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: requestBody
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        console.log('Answer saved successfully');
                    }
                })
                .catch(error => {
                    console.error('Error saving answer:', error);
                });
            }
        }

        function handleAnswerChange(event) {
            userAnswers[currentQuestionIndex] = event.target.value;
            saveCurrentAnswer();
        }

        // Modal functions
        function showPeekAnswer() {
            if (isPracticeMode) {
                const modal = document.getElementById('peekAnswerModal');
                if (modal) {
                    modal.style.display = 'block';
                }
            }
        }

        function closePeekAnswerModal() {
            const modal = document.getElementById('peekAnswerModal');
            if (modal) {
                modal.style.display = 'none';
            }
        }

        function showReviewProgress() {
            const modal = document.getElementById('reviewProgressModal');
            if (modal) {
                modal.style.display = 'block';
            }
        }

        function closeReviewProgressModal() {
            const modal = document.getElementById('reviewProgressModal');
            if (modal) {
                modal.style.display = 'none';
            }
        }

        function showScoreExamModal() {
            const unansweredCount = totalQuestions - Object.keys(userAnswers).length;
            let message;
            
            if (Object.keys(userAnswers).length === 0) {
                message = "You have not answered any questions. By clicking on the [Score Exam] button below, you will complete your current exam and be returned to the dashboard.";
            } else if (unansweredCount > 0) {
                message = "You have " + unansweredCount + " unanswered questions. By clicking on the [Score Exam] button below, you will complete your current exam and receive your score. You will not be able to change any answers after this point.";
            } else {
                message = "All questions have been answered. By clicking on the [Score Exam] button below, you will complete your current exam and receive your score. You will not be able to change any answers after this point.";
            }
            
            const confirmationText = document.getElementById('confirmationText');
            if (confirmationText) {
                confirmationText.textContent = message;
            }
            
            const modal = document.getElementById('scoreExamModal');
            if (modal) {
                modal.style.display = 'block';
            }
        }

        function closeScoreExamModal() {
            const modal = document.getElementById('scoreExamModal');
            if (modal) {
                modal.style.display = 'none';
            }
        }

        function scoreExamNow() {
            closeReviewProgressModal();
            showScoreExamModal();
        }

        // Exam submission
        function submitExam() {
            saveCurrentAnswer();
            clearInterval(timerInterval);
            
            // Submit quiz via POST
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/quizhandle';
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'submitQuiz';
            form.appendChild(actionInput);
            
            document.body.appendChild(form);
            form.submit();
        }

        // Event listeners
        document.addEventListener('DOMContentLoaded', function() {
            initializeQuiz();
            
            // Answer selection
            const answerRadios = document.querySelectorAll('input[name="answer"]');
            const textAnswer = document.getElementById('textAnswer');

            answerRadios.forEach(function(radio) {
                radio.addEventListener('change', handleAnswerChange);
            });

            if (textAnswer) {
                textAnswer.addEventListener('input', handleAnswerChange);
                textAnswer.addEventListener('blur', saveCurrentAnswer);
            }
            
            // Navigation buttons
            const nextBtn = document.getElementById('nextBtn');
            const prevBtn = document.getElementById('prevBtn');
            const scoreBtn = document.getElementById('scoreExamBtn');
            const peekBtn = document.getElementById('peekAnswerBtn');
            const reviewBtn = document.getElementById('reviewProgressBtn');
            
            if (nextBtn) nextBtn.addEventListener('click', nextQuestion);
            if (prevBtn) prevBtn.addEventListener('click', prevQuestion);
            if (scoreBtn) scoreBtn.addEventListener('click', showScoreExamModal);
            if (peekBtn) peekBtn.addEventListener('click', showPeekAnswer);
            if (reviewBtn) reviewBtn.addEventListener('click', showReviewProgress);
            
            // Close modals when clicking outside
            window.addEventListener('click', function(event) {
                const modals = document.querySelectorAll('.modal');
                modals.forEach(function(modal) {
                    if (event.target === modal) {
                        modal.style.display = 'none';
                    }
                });
            });

            // Save answer before page unload
            window.addEventListener('beforeunload', function() {
                saveCurrentAnswer();
            });
        });
    </script>
</body>
</html>