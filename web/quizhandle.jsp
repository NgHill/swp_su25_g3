<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz: ${quiz.title}</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/tesseract.js/4.1.1/tesseract.min.js"></script>
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
        
        .upload-button {
            background: #007bff;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            margin-bottom: 15px;
        }


        .upload-button:hover {

            background: #0056b3;
        }

        .image-preview {
            max-width: 200px;
            max-height: 200px;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-bottom: 10px;
        }

        .image-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .remove-image {
            background: #dc3545;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }

        .ocr-result {
            background: #e8f5e8;
            border: 1px solid #28a745;
            padding: 10px;
            border-radius: 4px;
            margin-top: 10px;
        }

        .ocr-loading {
            background: #fff3cd;
            border: 1px solid #ffc107;
            padding: 10px;
            border-radius: 4px;
            margin-top: 10px;
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

                        <div class="image-upload-container" id="imageUploadContainer">
                            <p style="margin-bottom: 10px; color: #6c757d;">You can also upload an image of your answer:</p>


                            <input type="file" 
                                   id="imageUpload" 

                                   accept="image/*" 
                                   style="display: none;"
                                   onchange="handleImageUpload(event)">

                            <button type="button" 
                                    class="upload-button" 
                                    onclick="document.getElementById('imageUpload').click()">
                                📷 Choose Image
                            </button>

                            <div id="imagePreview" style="display: none;">
                                <img id="previewImg" class="image-preview" src="" alt="Preview">
                                <div class="image-info">
                                    <span id="imageFileName"></span>
                                    <button type="button" class="remove-image" onclick="removeImage()">✕ Remove</button>
                                </div>
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
                <button class="btn btn-secondary" onclick="closeScoreExamModal()"> Back</button>
                <button class="btn btn-success" onclick="submitExam()">Score Exam</button>
            </div>
        </div>
    </div>

    <script>
        // Khởi tạo dữ liệu quiz từ JSP
        let currentQuestionIndex = ${currentQuestionIndex};  // Chỉ số câu hỏi hiện tại
        let totalQuestions = ${totalQuestions};  // Tổng số câu hỏi trong quiz
        let quizId = ${quiz.id};  // ID của quiz
        let userId = ${currentUserId};  // ID của người dùng
        let timeLeft = ${timeLeft};  // Thời gian còn lại để làm bài
        let timerInterval;  // Biến lưu trữ ID của timer
        let isPracticeMode = ${isPracticeMode};  // Kiểm tra xem có phải chế độ luyện tập hay không

        // Lấy câu trả lời của người dùng từ server
        let userAnswers = {};  // Khởi tạo đối tượng lưu trữ câu trả lời của người dùng
        <c:forEach var="entry" items="${userAnswers}">
            userAnswers[${entry.key}] = '${entry.value}';  // Lưu câu trả lời vào đối tượng userAnswers
        </c:forEach>

        // Khởi tạo quiz
        function initializeQuiz() {
            startTimer();  // Bắt đầu đồng hồ đếm ngược
            if (!isPracticeMode) {  // Kiểm tra nếu không phải chế độ luyện tập
                const peekBtn = document.getElementById('peekAnswerBtn');  // Lấy nút "Peek Answer"
                if (peekBtn) {

                    peekBtn.style.display = 'none';  // Ẩn nút "Peek Answer" nếu không phải chế độ luyện tập

                }
            }
        }

        // Hàm bắt đầu đếm giờ (Timer functions)
        function startTimer() {
            updateTimerDisplay();  // Cập nhật hiển thị thời gian
            timerInterval = setInterval(() => {
                timeLeft--;  // Giảm thời gian còn lại mỗi giây
                if (timeLeft <= 0) {  // Kiểm tra nếu hết thời gian
                    alert('Time is up! The exam will be submitted automatically.');  // Thông báo hết giờ
                    submitExam();  // Tự động nộp bài
                    return;
                }
                updateTimerDisplay();  // Cập nhật lại thời gian sau mỗi giây
            }, 1000);  // Mỗi giây
        }

        // Cập nhật hiển thị thời gian còn lại
        function updateTimerDisplay() {
            const hours = Math.floor(timeLeft / 3600);  // Tính giờ
            const minutes = Math.floor((timeLeft % 3600) / 60);  // Tính phút
            const seconds = timeLeft % 60;  // Tính giây

            const timerElement = document.getElementById('timer');  // Lấy phần tử đồng hồ
            if (timerElement) {
                timerElement.textContent = 
                    hours.toString().padStart(2, '0') + ':' +  // Cập nhật giờ
                    minutes.toString().padStart(2, '0') + ':' +  // Cập nhật phút
                    seconds.toString().padStart(2, '0');  // Cập nhật giây
            }
        }

        // Các hàm điều hướng giữa các câu hỏi
        function goToQuestion(index) {
            saveCurrentAnswer();  // Lưu câu trả lời hiện tại
            window.location.href = '${pageContext.request.contextPath}/quizhandle?quizId=' + quizId + '&userId=' + userId + '&questionIndex=' + index;  // Chuyển đến câu hỏi có chỉ số index
        }

        function nextQuestion() {
            saveCurrentAnswer();  // Lưu câu trả lời hiện tại
            if (currentQuestionIndex < totalQuestions - 1) {  // Nếu câu hỏi không phải câu cuối cùng
                window.location.href = '${pageContext.request.contextPath}/quizhandle?quizId=' + quizId + '&userId=' + userId + '&questionIndex=' + (currentQuestionIndex + 1);  // Chuyển đến câu hỏi tiếp theo
            }
        }

        function prevQuestion() {
            saveCurrentAnswer();  // Lưu câu trả lời hiện tại
            if (currentQuestionIndex > 0) {  // Nếu câu hỏi không phải câu đầu tiên
                window.location.href = '${pageContext.request.contextPath}/quizhandle?quizId=' + quizId + '&userId=' + userId + '&questionIndex=' + (currentQuestionIndex - 1);  // Quay lại câu hỏi trước
            }
        }

        // Lưu câu trả lời của người dùng

        function saveCurrentAnswer() {

            const selectedAnswer = document.querySelector('input[name="answer"]:checked');  // Lấy câu trả lời đã chọn (nếu là câu hỏi trắc nghiệm)
            const textAnswer = document.getElementById('textAnswer');  // Lấy câu trả lời dạng văn bản
            const extractedText = document.getElementById('extractedText');  // Lấy câu trả lời văn bản nhận dạng từ ảnh (nếu có)

            let answerValue = null;  // Khởi tạo biến lưu giá trị câu trả lời
            let requestBody = 'action=saveAnswer&questionIndex=' + currentQuestionIndex;  // Chuẩn bị body request gửi lên server

            if (selectedAnswer) {  // Nếu là câu hỏi trắc nghiệm
                answerValue = selectedAnswer.value;  // Lưu giá trị câu trả lời trắc nghiệm
                requestBody += '&selectedAnswer=' + encodeURIComponent(answerValue);  // Thêm giá trị câu trả lời vào request body
            } else if (textAnswer) {  // Nếu là câu hỏi dạng văn bản
                answerValue = textAnswer.value.trim();  // Lưu câu trả lời dạng văn bản
                requestBody += '&textAnswer=' + encodeURIComponent(answerValue);  // Thêm câu trả lời vào request body

                if (extractedText && extractedText.textContent.trim()) {  // Nếu có văn bản nhận dạng từ ảnh
                    requestBody += '&extractedText=' + encodeURIComponent(extractedText.textContent.trim());  // Thêm văn bản nhận dạng vào request body
                }
            }

            if (answerValue) {  // Nếu có câu trả lời (trắc nghiệm hoặc văn bản)
                fetch('${pageContext.request.contextPath}/quizhandle', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: requestBody  // Gửi câu trả lời lên server
                })
                .then(response => response.json())  // Chờ nhận phản hồi từ server
                .then(data => {
                    if (data.success) {
                        console.log('Answer saved successfully');  // In thông báo nếu lưu câu trả lời thành công
                    }
                })
                .catch(error => {
                    console.error('Error saving answer:', error);  // In lỗi nếu có lỗi xảy ra
                });
            }
        }

        // Hàm xử lý thay đổi câu trả lời
        function handleAnswerChange(event) {
            if (event.target.type === 'radio') {  // Nếu là câu trả lời trắc nghiệm
                userAnswers[currentQuestionIndex] = event.target.value;  // Lưu câu trả lời trắc nghiệm
            } else if (event.target.type === 'text') {  // Nếu là câu trả lời văn bản

                userAnswers[currentQuestionIndex] = event.target.value.trim();  // Lưu câu trả lời văn bản

            }
            saveCurrentAnswer();  // Lưu câu trả lời mỗi khi có thay đổi
        }

        // Các hàm Modal (hộp thoại)
        function showPeekAnswer() {
            if (isPracticeMode) {  // Nếu ở chế độ luyện tập
                const modal = document.getElementById('peekAnswerModal');  // Lấy modal "Peek Answer"
                if (modal) {
                    modal.style.display = 'block';  // Hiển thị modal
                }
            }
        }

        function closePeekAnswerModal() {
            const modal = document.getElementById('peekAnswerModal');  // Lấy modal "Peek Answer"
            if (modal) {
                modal.style.display = 'none';  // Đóng modal
            }
        }

        function showReviewProgress() {
            const modal = document.getElementById('reviewProgressModal');  // Lấy modal "Review Progress"
            if (modal) {
                modal.style.display = 'block';  // Hiển thị modal
            }
        }

        function closeReviewProgressModal() {
            const modal = document.getElementById('reviewProgressModal');  // Lấy modal "Review Progress"
            if (modal) {
                modal.style.display = 'none';  // Đóng modal
            }
        }

        function showScoreExamModal() {
            const unansweredCount = totalQuestions - Object.keys(userAnswers).length;  // Tính số câu hỏi chưa trả lời
            let message;

            if (Object.keys(userAnswers).length === 0) {  // Nếu chưa trả lời câu nào
                message = "You have not answered any questions. By clicking on the [Score Exam] button below, you will complete your current exam and be returned to the dashboard.";
            } else if (unansweredCount > 0) {  // Nếu còn câu chưa trả lời
                message = "You have unanswered questions. By clicking on the [Score Exam] button below, you will complete your current exam and receive your score. You will not be able to change any answers after this point.";
            } else {  // Nếu đã trả lời tất cả câu hỏi
                message = "All questions have been answered. By clicking on the [Score Exam] button below, you will complete your current exam and receive your score. You will not be able to change any answers after this point.";
            }

            const confirmationText = document.getElementById('confirmationText');  // Lấy phần tử hiển thị thông báo
            if (confirmationText) {
                confirmationText.textContent = message;  // Hiển thị thông báo
            }

            const modal = document.getElementById('scoreExamModal');  // Lấy modal "Score Exam"

            if (modal) {

                modal.style.display = 'block';  // Hiển thị modal
            }
        }

        function closeScoreExamModal() {
            const modal = document.getElementById('scoreExamModal');  // Lấy modal "Score Exam"
            if (modal) {
                modal.style.display = 'none';  // Đóng modal
            }
        }

        function scoreExamNow() {
            closeReviewProgressModal();  // Đóng modal "Review Progress"
            showScoreExamModal();  // Hiển thị modal "Score Exam"
        }

        // Nộp bài
        function submitExam() {
            saveCurrentAnswer();  // Lưu câu trả lời cuối cùng
            clearInterval(timerInterval);  // Dừng đồng hồ đếm ngược

            // Tạo form ẩn và gửi dữ liệu quiz lên server
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/quizhandle';

            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'submitQuiz';
            form.appendChild(actionInput);

            document.body.appendChild(form);  // Thêm form vào body
            form.submit();  // Gửi dữ liệu lên server

        }

        // Xử lý tải ảnh
        function handleImageUpload(event) {
            const file = event.target.files[0];  // Lấy file ảnh
            if (!file) return;  // Nếu không có file, thoát

            const reader = new FileReader();  // Đọc file ảnh
            reader.onload = function(e) {
                const preview = document.getElementById('imagePreview');  // Lấy phần tử preview
                const img = document.getElementById('previewImg');  // Lấy phần tử hình ảnh
                const fileName = document.getElementById('imageFileName');  // Lấy phần tử tên file

                img.src = e.target.result;  // Đặt nguồn hình ảnh từ file
                fileName.textContent = file.name;  // Hiển thị tên file
                preview.style.display = 'block';  // Hiển thị ảnh preview

                // Thực hiện nhận dạng văn bản từ ảnh (OCR)
                performOCR(e.target.result);
            };
            reader.readAsDataURL(file);  // Đọc file ảnh
        }

        function removeImage() {
            document.getElementById('imageUpload').value = '';  // Xóa giá trị file đã chọn
            document.getElementById('imagePreview').style.display = 'none';  // Ẩn preview ảnh
            document.getElementById('ocrResult').style.display = 'none';  // Ẩn kết quả OCR
            document.getElementById('extractedText').textContent = '';  // Xóa văn bản nhận dạng
        }


        // Nhận dạng văn bản từ ảnh (OCR)
        function performOCR(imageData) {
            const ocrResult = document.getElementById('ocrResult');  // Lấy phần tử 'ocrResult' để hiển thị kết quả OCR
            const extractedText = document.getElementById('extractedText');  // Lấy phần tử 'extractedText' để hiển thị văn bản nhận dạng

            console.log('🔄 Analyzing image...');  // In thông báo vào console khi bắt đầu quá trình nhận diện văn bản từ ảnh

            Tesseract.recognize(imageData, 'eng', {  // Sử dụng Tesseract.js để nhận diện văn bản từ ảnh, ngôn ngữ là 'eng' (tiếng Anh)
                logger: m => console.log(m)  // Ghi log tiến trình nhận diện vào console
            }).then(({ data: { text } }) => {  // Sau khi Tesseract hoàn thành nhận diện, nhận giá trị 'text' là văn bản nhận diện được

                // Điền text vào ô input
                const textInput = document.getElementById('textAnswer');  // Lấy phần tử input với id 'textAnswer' để điền kết quả nhận diện vào
                if (textInput) {  // Nếu phần tử input tồn tại
                    textInput.value = text.trim();  // Điền văn bản nhận diện vào ô input, loại bỏ khoảng trắng thừa
                }

                // Lưu câu trả lời ngay lập tức
                saveCurrentAnswer();  // Gọi hàm saveCurrentAnswer để lưu câu trả lời sau khi nhận diện xong

                // Xóa hình ảnh sau khi đã chuyển thành text
                removeImage();  // Gọi hàm removeImage để xóa ảnh đã tải lên và ẩn phần preview ảnh

                // Ẩn loading
                const ocrResult = document.getElementById('ocrResult');  // Lấy phần tử 'ocrResult' để ẩn kết quả OCR
                if (ocrResult) {  // Nếu phần tử 'ocrResult' tồn tại
                    ocrResult.style.display = 'none';  // Ẩn phần tử 'ocrResult' sau khi quá trình nhận diện hoàn tất
                }
            }).catch(err => {  // Nếu có lỗi trong quá trình nhận diện
                ocrResult.innerHTML = '<div style="color: red;">Error analyzing image: ' + err.message + '</div>';  // Hiển thị thông báo lỗi vào phần tử 'ocrResult'
            });
        }


        // Lắng nghe sự kiện DOMContentLoaded
        document.addEventListener('DOMContentLoaded', function() {
            initializeQuiz();  // Khởi tạo quiz khi trang đã tải xong

            // Xử lý thay đổi câu trả lời
            const answerRadios = document.querySelectorAll('input[name="answer"]');  // Lấy tất cả câu trả lời trắc nghiệm (radio buttons)
            const textAnswer = document.getElementById('textAnswer');  // Lấy phần tử câu trả lời văn bản (input)


            answerRadios.forEach(function(radio) {  // Duyệt qua tất cả các câu trả lời trắc nghiệm (radio buttons)

                radio.addEventListener('change', handleAnswerChange);  // Lắng nghe sự kiện thay đổi câu trả lời trắc nghiệm
            });

            if (textAnswer) {  // Nếu có ô nhập câu trả lời văn bản
                textAnswer.addEventListener('input', handleAnswerChange);  // Lắng nghe sự kiện thay đổi câu trả lời văn bản
                textAnswer.addEventListener('blur', saveCurrentAnswer);  // Lưu câu trả lời khi mất focus (rời khỏi ô nhập liệu)
            }

            // Các nút điều hướng
            const nextBtn = document.getElementById('nextBtn');  // Lấy nút "Next"
            const prevBtn = document.getElementById('prevBtn');  // Lấy nút "Previous"
            const scoreBtn = document.getElementById('scoreExamBtn');  // Lấy nút "Score Exam"
            const peekBtn = document.getElementById('peekAnswerBtn');  // Lấy nút "Peek Answer"
            const reviewBtn = document.getElementById('reviewProgressBtn');  // Lấy nút "Review Progress"

            if (nextBtn) nextBtn.addEventListener('click', nextQuestion);  // Lắng nghe sự kiện nút "Next" để chuyển sang câu hỏi tiếp theo
            if (prevBtn) prevBtn.addEventListener('click', prevQuestion);  // Lắng nghe sự kiện nút "Previous" để quay lại câu hỏi trước
            if (scoreBtn) scoreBtn.addEventListener('click', showScoreExamModal);  // Lắng nghe sự kiện nút "Score Exam" để hiển thị modal chấm điểm
            if (peekBtn) peekBtn.addEventListener('click', showPeekAnswer);  // Lắng nghe sự kiện nút "Peek Answer" để hiển thị đáp án
            if (reviewBtn) reviewBtn.addEventListener('click', showReviewProgress);  // Lắng nghe sự kiện nút "Review Progress" để hiển thị tiến độ làm bài

            // Đóng modal khi nhấp ra ngoài
            window.addEventListener('click', function(event) {  // Lắng nghe sự kiện nhấp chuột ngoài modal
                const modals = document.querySelectorAll('.modal');  // Lấy tất cả các modal trên trang
                modals.forEach(function(modal) {  // Duyệt qua tất cả các modal
                    if (event.target === modal) {  // Kiểm tra xem người dùng có nhấp vào chính modal không
                        modal.style.display = 'none';  // Đóng modal nếu nhấp ra ngoài
                    }
                });
            });

            // Lưu câu trả lời trước khi thoát trang
            window.addEventListener('beforeunload', function() {  // Lắng nghe sự kiện khi người dùng chuẩn bị rời khỏi trang
                saveCurrentAnswer();  // Lưu câu trả lời trước khi thoát
            });
        });

    </script>

</body>
</html>