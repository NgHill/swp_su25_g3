<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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

        .text-input {
            width: 100%;
            padding: 12px;
            font-size: 14px;
            border: 2px solid #e9ecef;
            border-radius: 4px;
            margin-bottom: 15px;
        }

        .text-input:focus {
            outline: none;
            border-color: #007bff;
        }

        .quiz-footer {
            background: #f8f9fa;
            padding: 15px 20px;
            border-top: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.2s;
        }

        .btn-primary {
            background: #007bff;
            color: white;
        }

        .btn-primary:hover {
            background: #0056b3;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-success {
            background: #28a745;
            color: white;
        }

        .btn-warning {
            background: #ffc107;
            color: #212529;
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
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
        }

        .close {
            font-size: 24px;
            cursor: pointer;
            color: #6c757d;
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
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
            text-decoration: none;
            color: #6c757d;
        }

        .question-number:hover {
            background-color: #f8f9fa;
        }

        .question-number.answered {
            background-color: #28a745;
            color: white;
            border-color: #28a745;
        }

        .question-number.current {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }

        .hidden {
            display: none;
        }
    </style>
</head>
<body>
    <div class="quiz-container">
        <!-- Header -->
        <div class="quiz-header">
            <div class="quiz-info">
                <div class="quiz-title">${quiz.title}</div>
                <div class="question-counter">
                    ${currentQuestionIndex + 1} / ${totalQuestions}
                </div>
            </div>
            <div class="timer" id="timer">00:00:00</div>
        </div>

        <!-- Body -->
        <div class="quiz-body">
            <div class="question-header">
                Question ${currentQuestionIndex + 1}
            </div>

            <div class="question-text">
                ${currentQuestion.content}
            </div>

            <!-- Form để lưu answer -->
            <form id="answerForm">
                <input type="hidden" name="action" value="saveAnswer">
                <input type="hidden" name="questionIndex" value="${currentQuestionIndex}">
                
                <div class="options">
                    <c:choose>
                        <c:when test="${currentQuestion.questionType == 'text_input'}">
                            <!-- Text Input Question -->
                            <input type="text" 
                                   name="textAnswer" 
                                   id="textAnswer" 
                                   placeholder="Enter your answer here..."
                                   value="${userAnswers[currentQuestionIndex]}"
                                   class="text-input"
                                   onchange="saveAnswer()">

                        </c:when>
                        <c:otherwise>
                            <!-- Multiple Choice Question -->
                            <c:forEach var="answer" items="${currentQuestion.answers}" varStatus="status">
                                <div class="option">
                                    <input type="radio" 
                                    name="answer" 
                                    value="${answer.id}" 
                                    id="option${status.index}"
                                    onchange="saveAnswer()"
                                    <c:if test="${userAnswers[currentQuestionIndex] eq answer.id.toString()}">checked</c:if>>
                                    <label for="option${status.index}" class="option-text">
                                        ${answer.content}
                                    </label>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </form>
        </div>

        <!-- Footer -->
        <div class="quiz-footer">
            <div class="left-buttons">
                <button class="btn btn-primary" onclick="showProgressModal()">Review Progress</button>
                <c:if test="${isPracticeMode}">
                    <button class="btn btn-warning" onclick="showAnswerModal()">Peek Answer</button>
                </c:if>
            </div>
            <div class="right-buttons">
                <c:if test="${currentQuestionIndex > 0}">
                    <form method="post" style="display: inline;" onsubmit="return submitWithCurrentAnswer(this, 'prev')">
                        <input type="hidden" name="action" value="navigate">
                        <input type="hidden" name="currentIndex" value="${currentQuestionIndex}">
                        <input type="hidden" name="direction" value="prev">
                        <input type="hidden" name="quizId" value="${quiz.id}">
                        <input type="hidden" name="userId" value="${sessionScope.currentUserId}">
                        <input type="hidden" name="answer" value="">
                        <input type="hidden" name="textAnswer" value="">
                        <button type="submit" class="btn btn-secondary">Previous</button>
                    </form>
                </c:if>

                <!-- Next Button -->
                <c:if test="${currentQuestionIndex < totalQuestions - 1}">
                    <form method="post" style="display: inline;" onsubmit="return submitWithCurrentAnswer(this, 'next')">
                        <input type="hidden" name="action" value="navigate">
                        <input type="hidden" name="currentIndex" value="${currentQuestionIndex}">
                        <input type="hidden" name="direction" value="next">
                        <input type="hidden" name="quizId" value="${quiz.id}">
                        <input type="hidden" name="userId" value="${sessionScope.currentUserId}">
                        <input type="hidden" name="answer" value="">
                        <input type="hidden" name="textAnswer" value="">
                        <input type="hidden" name="imagePath" value="">
                        <button type="submit" class="btn btn-primary">Next</button>
                    </form>
                </c:if>
                
                <!-- Submit Button -->
                <c:if test="${currentQuestionIndex == totalQuestions - 1}">
                    <button class="btn btn-success" onclick="showSubmitModal()">Submit Quiz</button>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Progress Modal -->
    <div id="progressModal" class="modal">
        <div class="modal-content" style="max-width: 600px;">
            <div class="modal-header">
                <h3>Review Progress</h3>
                <span class="close" onclick="closeModal('progressModal')">&times;</span>
            </div>
            <div class="modal-body">
                <div class="question-grid">
                    <c:forEach var="i" begin="0" end="${totalQuestions - 1}">
                        <a href="quizhandle?quizId=${quiz.id}&userId=${sessionScope.currentUserId}&questionIndex=${i}" 
                           class="question-number 
                                  <c:if test="${i == currentQuestionIndex}">current</c:if>
                                  <c:if test="${not empty userAnswers[i]}">answered</c:if>">
                            ${i + 1}
                        </a>
                    </c:forEach>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-success" onclick="submitQuiz()">Submit Quiz</button>
            </div>
        </div>
    </div>

    <!-- Submit Confirmation Modal -->
    <div id="submitModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Submit Quiz?</h3>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to submit your quiz? You cannot change answers after submitting.</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeModal('submitModal')">Cancel</button>
                <button class="btn btn-success" onclick="submitQuiz()">Submit</button>
            </div>
        </div>
    </div>

    <!-- Answer Modal -->
    <div id="answerModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Correct Answer</h3>
                <span class="close" onclick="closeModal('answerModal')">&times;</span>
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
                        <c:forEach var="answer" items="${currentQuestion.answers}">
                            <c:if test="${answer.correct}">
                                <p><strong>Correct Answer:</strong> ${answer.content}</p>
                            </c:if>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        // Global variables
        let timeLeft = ${timeLeft};  // Thời gian còn lại, lấy từ biến server-side
        let timerInterval;  // Biến lưu trữ interval của đồng hồ

        // Initialize when page loads
        document.addEventListener('DOMContentLoaded', function() {
            startTimer();  // Bắt đầu đếm ngược thời gian           
        });
      
        // Timer functions: Functions to start and update the quiz timer
        function startTimer() {
            updateTimerDisplay();  // Cập nhật hiển thị đồng hồ ngay khi bắt đầu
            timerInterval = setInterval(() => {  // Thiết lập hàm chạy mỗi giây
                timeLeft--;  // Giảm thời gian còn lại mỗi giây
                if (timeLeft <= 0) {
                    alert('Time is up! Quiz will be submitted.');  // Thông báo khi hết thời gian
                    submitQuiz();  // Nộp bài thi khi hết giờ
                    return;
                }
                updateTimerDisplay();  // Cập nhật lại đồng hồ
            }, 1000);  // Chạy mỗi 1 giây
        }

        // Update the display of the timer
        function updateTimerDisplay() {
            const hours = Math.floor(timeLeft / 3600);  // Tính giờ
            const minutes = Math.floor((timeLeft % 3600) / 60);  // Tính phút
            const seconds = timeLeft % 60;  // Tính giây

            document.getElementById('timer').textContent = 
                hours.toString().padStart(2, '0') + ':' +
                minutes.toString().padStart(2, '0') + ':' +
                seconds.toString().padStart(2, '0');  // Hiển thị đồng hồ trên giao diện
        }

        // Save answer via AJAX
        function saveAnswer() {
            const form = document.getElementById('answerForm');  // Lấy form chứa câu trả lời
            const formData = new FormData(form);  // Lấy tất cả dữ liệu trong form

            // Gửi dữ liệu lên server
            fetch('quizhandle', {
                method: 'POST',  // Sử dụng phương thức POST
                body: formData   // Gửi dữ liệu form lên server
            })
        }

        // Submit quiz
        function submitQuiz() {
            clearInterval(timerInterval);  // Dừng đồng hồ đếm ngược khi nộp bài, tránh đồng hồ tiếp tục chạy sau khi nộp quiz

            // Lấy câu trả lời hiện tại
            let lastAnswer = '';  // Khởi tạo biến để lưu giá trị của đáp án dạng radio
            let lastTextAnswer = '';  // Khởi tạo biến để lưu giá trị của câu trả lời dạng text

            // Lấy đáp án radio đã chọn từ form
            const selectedRadio = document.querySelector('input[name="answer"]:checked');  // Lấy phần tử radio được chọn (nếu có)
            if (selectedRadio) {
                lastAnswer = selectedRadio.value;  // Nếu có đáp án radio được chọn, lưu giá trị của nó vào lastAnswer
            }

            // Lấy giá trị từ ô nhập liệu dạng text
            const textInput = document.getElementById('textAnswer');  // Lấy phần tử input có id "textAnswer"
            if (textInput && textInput.value.trim()) {  // Kiểm tra nếu có giá trị nhập vào ô text và không phải chuỗi trắng
                lastTextAnswer = textInput.value.trim();  // Lưu câu trả lời text vào lastTextAnswer
            }

            // Tạo form ẩn để gửi câu trả lời cuối cùng cùng với submit
            const form = document.createElement('form');  // Tạo một form mới để gửi dữ liệu (sẽ không hiển thị trên trang)
            form.method = 'GET';  // Đặt phương thức của form là GET
            form.action = 'quizhandle';  // Địa chỉ URL nơi gửi dữ liệu (ở đây là 'quizhandle')

            // Các parameters cần thiết để gửi
            const params = {
                'action': 'submit',  // Tham số action để chỉ ra hành động submit
                'quizId': '${quiz.id}',  // ID quiz từ server (được truyền từ JSP)
                'userId': '${sessionScope.currentUserId}',  // ID người dùng từ session (được truyền từ JSP)
                'lastQuestionIndex': '${currentQuestionIndex}',  // Chỉ số câu hỏi cuối cùng (được truyền từ JSP)
                'lastAnswer': lastAnswer,  // Đáp án radio cuối cùng mà người dùng đã chọn
                'lastTextAnswer': lastTextAnswer  // Câu trả lời text cuối cùng mà người dùng đã nhập
            };

            // Thêm các input hidden vào form để gửi dữ liệu
            for (const [key, value] of Object.entries(params)) {  // Duyệt qua các tham số cần gửi
                if (value) {  // Chỉ thêm tham số nếu có giá trị (tránh trường hợp null hoặc empty string)
                    const input = document.createElement('input');  // Tạo input hidden mới
                    input.type = 'hidden';  // Đặt loại input là "hidden" để nó không hiển thị trên form
                    input.name = key;  // Đặt tên input theo tên tham số
                    input.value = value;  // Đặt giá trị của input là giá trị tham số
                    form.appendChild(input);  // Thêm input vào form
                }
            }

            // Thêm form vào body của trang
            document.body.appendChild(form);  // Thêm form vào phần tử body của trang, nhưng form sẽ không hiển thị
            form.submit();  // Gửi form đi (kích hoạt submit của form, gửi tất cả dữ liệu đã thêm vào backend)
        }


        // Modal functions
        function showProgressModal() {
            document.getElementById('progressModal').style.display = 'block';  // Hiển thị modal tiến độ
        }

        function showSubmitModal() {
            document.getElementById('submitModal').style.display = 'block';  // Hiển thị modal xác nhận nộp bài
        }

        function showAnswerModal() {
            document.getElementById('answerModal').style.display = 'block';  // Hiển thị modal câu trả lời đúng
        }

        // Close modal
        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';  // Đóng modal
        }

        // Close modals when clicking outside
        window.onclick = function(event) {
            const modals = document.querySelectorAll('.modal');  // Lấy tất cả modals
            modals.forEach(modal => {
                if (event.target === modal) {  // Nếu click vào phần nền
                    modal.style.display = 'none';  // Đóng modal
                }
            });
        }
       
        // Submit with current answer (used for previous/next navigation)
        function submitWithCurrentAnswer(form, direction) {
            // Lấy đáp án multiple choice hiện tại
            const selectedRadio = document.querySelector('input[name="answer"]:checked');
            if (selectedRadio) {
                form.querySelector('input[name="answer"]').value = selectedRadio.value;
            }

            // Lấy đáp án text hiện tại
            const textInput = document.getElementById('textAnswer');
            if (textInput && textInput.value.trim()) {
                form.querySelector('input[name="textAnswer"]').value = textInput.value.trim();
            }
            return true;  // Cho phép form submit
        }
    </script>

</body>
</html>