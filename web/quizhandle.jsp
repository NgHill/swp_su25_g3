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

        .upload-button {
            background: #007bff;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            cursor: pointer;
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

                            <!-- Image Upload for illustration -->
                            <div class="image-section" style="border: 2px dashed #dee2e6; border-radius: 8px; padding: 20px; margin-top: 15px; background-color: #f8f9fa;">
                                <p style="margin-bottom: 10px; color: #6c757d;">Upload an image to illustrate your answer (optional):</p>
                                <input type="file" id="imageUpload" accept="image/*" style="display: none;" onchange="handleImageUpload(event)">
                                <button type="button" class="upload-button" onclick="document.getElementById('imageUpload').click()">
                                    📷 Add Illustration
                                </button>

                                <div id="imagePreview" class="<c:if test='${empty userImages[currentQuestionIndex]}'>hidden</c:if>">
                                    <img id="previewImg" class="image-preview" 
                                         src="<c:if test='${not empty userImages[currentQuestionIndex]}'>quiz-images/${userImages[currentQuestionIndex]}</c:if>" 
                                         alt="Preview" 
                                         style="max-width: 300px; max-height: 200px; border: 1px solid #ddd; border-radius: 4px; margin: 10px auto; display: block;">
                                    <button type="button" class="remove-image-btn" onclick="removeImage()" style="background: #dc3545; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; font-size: 12px;">Remove Image</button>
                                </div>

                                <!-- Hidden input để lưu tên file ảnh -->
                                <input type="hidden" name="imagePath" id="imagePath" value="${userImages[currentQuestionIndex]}">
                            </div>
                        </c:when>
                        <c:otherwise>
<!-- Thay thế toàn bộ đoạn Multiple Choice Question -->
    <!-- Multiple Choice Question -->
    <c:forEach var="answer" items="${currentQuestion.answers}" varStatus="status">
        <div class="option">
            <input type="radio" 
                   name="answer" 
                   value="${answer.id}" 
                   id="option${status.index}"
                   onchange="saveAnswer()"
                   <c:if test="${userAnswers[currentQuestionIndex] eq answer.id}">checked</c:if>>
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
                        <input type="hidden" name="imagePath" value="">
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
    clearInterval(timerInterval);  // Dừng đồng hồ đếm ngược

    // Lấy câu trả lời hiện tại
    let lastAnswer = '';
    let lastTextAnswer = '';

    // Lấy đáp án radio đã chọn
    const selectedRadio = document.querySelector('input[name="answer"]:checked');
    if (selectedRadio) {
        lastAnswer = selectedRadio.value;
    }

    // Lấy giá trị từ ô text input
    const textInput = document.getElementById('textAnswer');
    if (textInput && textInput.value.trim()) {
        lastTextAnswer = textInput.value.trim();
    }

    // Tạo form để submit
    const form = document.createElement('form');
    form.method = 'GET';
    form.action = 'quizhandle';

    const params = {
        'action': 'submit',
        'quizId': '${quiz.id}',
        'userId': '${sessionScope.currentUserId}',
        'lastQuestionIndex': '${currentQuestionIndex}',
        'lastAnswer': lastAnswer,
        'lastTextAnswer': lastTextAnswer
    };

    // Thêm các input hidden vào form
    for (const [key, value] of Object.entries(params)) {
        if (value !== null && value !== '') {  // Cho phép cả giá trị rỗng
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = key;
            input.value = value;
            form.appendChild(input);
        }
    }

    // Submit form
    document.body.appendChild(form);
    form.submit();

    // Đóng modal nếu đang mở
    closeModal('submitModal');
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

            // THÊM: Lưu imagePath hiện tại
            const imagePathInput = document.getElementById('imagePath');
            if (imagePathInput) {
                let imagePathHidden = form.querySelector('input[name="imagePath"]');
                if (!imagePathHidden) {
                    imagePathHidden = document.createElement('input');
                    imagePathHidden.type = 'hidden';
                    imagePathHidden.name = 'imagePath';
                    form.appendChild(imagePathHidden);
                }
                imagePathHidden.value = imagePathInput.value;
            }

            return true;  // Cho phép form submit
        }

        // CODE MỚI (~8 dòng) - Đơn giản hóa
        function handleImageUpload(event) {
            const file = event.target.files[0];
            if (!file) return;

            // Preview ngay lập tức
            const img = document.getElementById('previewImg');
            img.src = URL.createObjectURL(file);
            document.getElementById('imagePreview').classList.remove('hidden');

            uploadImageToServer(file);
        }

        // Upload file to server
        function uploadImageToServer(file) {
            const formData = new FormData();
            formData.append('imageFile', file);  // Thêm tệp ảnh vào FormData
            formData.append('action', 'uploadImage');  // Thêm action vào FormData
            formData.append('questionIndex', document.querySelector('input[name="questionIndex"]').value);  // Thêm chỉ số câu hỏi

            // Gửi tệp ảnh lên server
            fetch('quizhandle', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())  // Xử lý phản hồi JSON từ server
            .then(data => {
                if (data.success) {
                    document.getElementById('imagePath').value = data.filename;  // Lưu tên tệp vào input ẩn
                    saveAnswer();
                } else {
                    alert('Failed to upload image: ' + data.error);  // Hiển thị lỗi nếu upload không thành công
                }
            })
            .catch(error => {
                console.error('Upload error:', error);  // Ghi lỗi nếu có lỗi
                alert('Failed to upload image');
            });
        }

        // Remove uploaded image
        function removeImage() {
            document.getElementById('imageUpload').value = '';  // Xóa giá trị tệp đã chọn
            document.getElementById('imagePath').value = '';  // Xóa giá trị đường dẫn ảnh
            document.getElementById('imagePreview').classList.add('hidden');  // Ẩn ảnh đã tải lên
        }
    </script>

</body>
</html>