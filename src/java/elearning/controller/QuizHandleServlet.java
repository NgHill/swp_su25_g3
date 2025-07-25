/*
 * Simplified QuizHandleServlet
 */

package elearning.controller;

import elearning.BasicDAO.QuizDAO;
import elearning.BasicDAO.QuizResultDAO;
import elearning.BasicDAO.UserAnswerDAO;
import elearning.entities.Question;
import elearning.entities.QuestionAnswer;
import elearning.entities.Quiz;
import elearning.entities.QuizResult;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // 5MB max
@WebServlet(name="QuizHandleServlet", urlPatterns={"/quizhandle"})
public class QuizHandleServlet extends HttpServlet {
    private QuizDAO quizDAO;
    private QuizResultDAO quizResultDAO;
    
    private static final String UPLOAD_DIR = "C:\\Users\\" + System.getProperty("user.name") + "\\uploads\\quiz-images\\";
    
    @Override
    public void init() throws ServletException {
        super.init();
        quizDAO = new QuizDAO();
        quizResultDAO = new QuizResultDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        // Lấy parameters
        int quizId = getIntParameter(request, "quizId", -1);
        int userId = getIntParameter(request, "userId", -1);
        int questionIndex = getIntParameter(request, "questionIndex", 0);
        String action = request.getParameter("action");

        // Validate required parameters
        if (quizId == -1 || userId == -1) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters: quizId or userId");
            return;
        }
        
        HttpSession session = request.getSession();
        
        // Xử lý action submit
        if ("submit".equals(action)) {
            submitQuiz(request, response, session);
            return;
        }
        
        // Lấy quiz từ session hoặc database
        Quiz quiz = (Quiz) session.getAttribute("currentQuiz");
        Integer sessionUserId = (Integer) session.getAttribute("currentUserId");

        // Reset session nếu quiz hoặc user khác
        if (quiz == null || quiz.getId() != quizId || sessionUserId == null || sessionUserId != userId) {
            quiz = quizDAO.getQuizWithQuestions(quizId);
            if (quiz == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Quiz not found");
                return;
            }

            // Clear old session data
            session.removeAttribute("userAnswers");
            session.removeAttribute("userImages"); 

            // Set new session data
            session.setAttribute("currentQuiz", quiz);
            session.setAttribute("currentUserId", userId);
            session.setAttribute("quizStartTime", System.currentTimeMillis());

            // Initialize empty user answers
            Map<Integer, String> userAnswers = new HashMap<>();
            session.setAttribute("userAnswers", userAnswers);
        }
        
        // Validate question index
        if (questionIndex < 0 || questionIndex >= quiz.getQuestions().size()) {
            questionIndex = 0;
        }
        
        // Lấy userAnswers từ session
        @SuppressWarnings("unchecked")
        Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
        if (userAnswers == null) {
            userAnswers = new HashMap<>();
            session.setAttribute("userAnswers", userAnswers);
        }
        
        // THÊM: Lấy userImages từ session
        @SuppressWarnings("unchecked")
        Map<Integer, String> userImages = (Map<Integer, String>) session.getAttribute("userImages");
        if (userImages == null) {
            userImages = new HashMap<>();
            session.setAttribute("userImages", userImages);
        }
        
        // Tính thời gian còn lại
        Long startTime = (Long) session.getAttribute("quizStartTime");
        long elapsedSeconds = (System.currentTimeMillis() - startTime) / 1000;
        int timeLeft = (int) Math.max(0, quiz.getDuration() * 60 - elapsedSeconds);
        
        // Set attributes cho JSP
        Question currentQuestion = quiz.getQuestions().get(questionIndex);
        request.setAttribute("quiz", quiz);
        request.setAttribute("currentQuestion", currentQuestion);
        request.setAttribute("currentQuestionIndex", questionIndex);
        request.setAttribute("totalQuestions", quiz.getQuestions().size());
        request.setAttribute("userAnswers", userAnswers);
        request.setAttribute("timeLeft", timeLeft);
        request.setAttribute("isPracticeMode", true);
        
        // Forward to JSP
        request.getRequestDispatcher("/quizhandle.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("uploadImage".equals(action)) {
            handleImageUpload(request, response);
        } else if ("saveAnswer".equals(action)) {
            saveAnswer(request, response, session);
        } else if ("navigate".equals(action)) {
            navigateQuestion(request, response, session);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    private void handleImageUpload(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Lấy phần tệp ảnh từ yêu cầu (request)
            Part filePart = request.getPart("imageFile");  // `getPart("imageFile")` lấy phần tệp ảnh từ form gửi lên

            if (filePart != null && filePart.getSize() > 0) {  

                // Tạo tên tệp với thời gian hiện tại + tên gốc của tệp để tránh trùng lặp
                String filename = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();  // Tạo tên tệp mới
                
                String uploadPath = UPLOAD_DIR;  
                Path uploadDir = Paths.get(uploadPath);  // Chuyển đổi đường dẫn thành đối tượng Path (để thao tác với thư mục)

                // Kiểm tra nếu thư mục chưa tồn tại, thì tạo thư mục
                if (!Files.exists(uploadDir)) {  
                    Files.createDirectories(uploadDir);  // Nếu chưa tồn tại, tạo thư mục
                }
              
                Path filePath = uploadDir.resolve(filename);  // Kết hợp thư mục và tên tệp để tạo đường dẫn đầy đủ cho tệp ảnh

                Files.copy(filePart.getInputStream(), filePath);  // Sao chép tệp từ InputStream vào thư mục đích trên server

                // Gửi phản hồi thành công với thông tin tên tệp đã lưu
                response.setContentType("application/json");  // Đặt loại nội dung phản hồi là JSON
                response.getWriter().write("{\"success\": true, \"filename\": \"" + filename + "\"}");  // Gửi JSON chứa tên tệp
            } else {
                // Nếu không có tệp được tải lên, trả về thông báo lỗi
                response.setContentType("application/json");  // Đặt loại nội dung phản hồi là JSON
                response.getWriter().write("{\"success\": false, \"error\": \"No file uploaded\"}");  // Gửi phản hồi lỗi
            }
        } catch (Exception e) {  // Bắt lỗi nếu có lỗi trong quá trình xử lý
            e.printStackTrace();  // In ra thông báo lỗi
            response.setContentType("application/json");  // Đặt loại nội dung phản hồi là JSON
            response.getWriter().write("{\"success\": false, \"error\": \"Upload failed: " + e.getMessage() + "\"}");  // Gửi phản hồi lỗi
        }
    }

    
    private void saveAnswer(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
    throws ServletException, IOException {

        int questionIndex = getIntParameter(request, "questionIndex", -1);
        String answer = request.getParameter("answer");
        String textAnswer = request.getParameter("textAnswer");
        String imagePath = request.getParameter("imagePath");

        if (questionIndex >= 0) {
            @SuppressWarnings("unchecked")
            Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
            if (userAnswers == null) {
                userAnswers = new HashMap<>();
                session.setAttribute("userAnswers", userAnswers);
            }

            @SuppressWarnings("unchecked")
            Map<Integer, String> userImages = (Map<Integer, String>) session.getAttribute("userImages");
            if (userImages == null) {
                userImages = new HashMap<>();
                session.setAttribute("userImages", userImages);
            }

            // Lưu text answer
            String finalAnswer = textAnswer != null ? textAnswer.trim() : answer;
            if (finalAnswer != null && !finalAnswer.isEmpty()) {
                userAnswers.put(questionIndex, finalAnswer);
            }

            // Lưu image path
            if (imagePath != null && !imagePath.trim().isEmpty()) {
                userImages.put(questionIndex, imagePath.trim());
            }
    }
    }
    
    private void navigateQuestion(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
    throws ServletException, IOException {
        
        int currentIndex = getIntParameter(request, "currentIndex", 0);
        String answer = request.getParameter("answer");
        String textAnswer = request.getParameter("textAnswer");

        // Lưu đáp án trước khi chuyển câu
        @SuppressWarnings("unchecked")
        Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
        if (userAnswers == null) {
            userAnswers = new HashMap<>();
            session.setAttribute("userAnswers", userAnswers);
        }

        // SỬAR: Khởi tạo userImages trước
        @SuppressWarnings("unchecked")
        Map<Integer, String> userImages = (Map<Integer, String>) session.getAttribute("userImages");
        if (userImages == null) {
            userImages = new HashMap<>();
            session.setAttribute("userImages", userImages);
        }

        // Lưu đáp án nếu có
        if (answer != null && !answer.trim().isEmpty()) {
            userAnswers.put(currentIndex, answer);
        } else if (textAnswer != null && !textAnswer.trim().isEmpty()) {
            userAnswers.put(currentIndex, textAnswer.trim());
        }

        // SỬA: Lưu image path - lưu cả khi rỗng để tránh mất dữ liệu
        String imagePath = request.getParameter("imagePath");
        if (imagePath != null) {
            if (!imagePath.trim().isEmpty()) {
                userImages.put(currentIndex, imagePath.trim());
                System.out.println("Saved image for question " + currentIndex + ": " + imagePath.trim()); // Debug log
            } else {
                // Nếu imagePath rỗng, kiểm tra xem có ảnh cũ không, nếu có thì giữ lại
                if (!userImages.containsKey(currentIndex)) {
                    userImages.put(currentIndex, "");
                }
            }
        }

        int targetIndex = getIntParameter(request, "targetIndex", currentIndex);
        String direction = request.getParameter("direction");

        Quiz quiz = (Quiz) session.getAttribute("currentQuiz");
        Integer userId = (Integer) session.getAttribute("currentUserId");

        if (quiz == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quiz session not found");
            return;
        }

        if ("next".equals(direction) && currentIndex < quiz.getQuestions().size() - 1) {
            targetIndex = currentIndex + 1;
        } else if ("prev".equals(direction) && currentIndex > 0) {
            targetIndex = currentIndex - 1;
        }

        if (targetIndex < 0 || targetIndex >= quiz.getQuestions().size()) {
            targetIndex = currentIndex;
        }

        response.sendRedirect("quizhandle?quizId=" + quiz.getId() + "&userId=" + userId + "&questionIndex=" + targetIndex);
    }
    
    private void submitQuiz(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
    throws ServletException, IOException {
        
        // Lấy thông tin quiz và user từ session
        Quiz quiz = (Quiz) session.getAttribute("currentQuiz");  // Lấy đối tượng quiz hiện tại từ session
        Integer userId = (Integer) session.getAttribute("currentUserId");  // Lấy ID người dùng từ session

        // Kiểm tra xem quiz và userId có hợp lệ không
        if (quiz == null || userId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quiz session not found");  // Nếu không có thông tin quiz hoặc user, trả về lỗi 400
            return;
        }

        // Lấy câu trả lời của người dùng từ session
        @SuppressWarnings("unchecked")
        Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");  // Lấy các câu trả lời của người dùng từ session

        // Nếu không có câu trả lời nào, khởi tạo một Map mới để tránh lỗi
        if (userAnswers == null) {
            userAnswers = new HashMap<>();
        }

        // Lưu câu trả lời cuối cùng trước khi submit
        String lastAnswer = request.getParameter("lastAnswer");  // Lấy câu trả lời cuối cùng
        String lastTextAnswer = request.getParameter("lastTextAnswer");  // Lấy câu trả lời dạng text cuối cùng
        String lastQuestionIndex = request.getParameter("lastQuestionIndex");  // Lấy chỉ số câu hỏi cuối cùng

        // Kiểm tra nếu có lastQuestionIndex, lưu câu trả lời cuối cùng vào Map
        if (lastQuestionIndex != null) {
            try {
                int questionIndex = Integer.parseInt(lastQuestionIndex);  // Chuyển lastQuestionIndex sang kiểu int
                if (questionIndex >= 0 && questionIndex < quiz.getQuestions().size()) {  // Kiểm tra chỉ số câu hỏi hợp lệ
                    // Kiểm tra nếu có câu trả lời text thì sử dụng nó, nếu không dùng đáp án radio
                    String finalAnswer = lastTextAnswer != null && !lastTextAnswer.trim().isEmpty() 
                        ? lastTextAnswer.trim() : lastAnswer;
                    // Nếu có câu trả lời hợp lệ, lưu vào Map
                    if (finalAnswer != null && !finalAnswer.isEmpty()) {
                        userAnswers.put(questionIndex, finalAnswer);  // Lưu câu trả lời vào Map
                    }
                }
            } catch (NumberFormatException e) {
                // Nếu chỉ số câu hỏi không hợp lệ, bỏ qua lỗi
            }
        }

        // Tính điểm dựa trên các câu trả lời đã lưu
        double score = calculateScore(quiz, userAnswers);  // Tính điểm bằng cách gọi hàm calculateScore

        // Lưu câu trả lời và hình ảnh vào cơ sở dữ liệu
        @SuppressWarnings("unchecked")
        Map<Integer, String> userImages = (Map<Integer, String>) session.getAttribute("userImages");  // Lấy đường dẫn ảnh từ session
        saveUserAnswers(userId, quiz, userAnswers, userImages);  // Lưu các câu trả lời và ảnh vào cơ sở dữ liệu

        // Tạo đối tượng QuizResult để lưu kết quả bài thi
        QuizResult result = new QuizResult();
        result.setUserId(userId);  // Set ID người dùng
        result.setQuizId(quiz.getId());  // Set ID quiz
        result.setScore(score);  // Set điểm thi
        result.setSubmittedAt(LocalDateTime.now());  // Set thời gian nộp bài

        // Lưu kết quả bài thi vào cơ sở dữ liệu
        boolean saved = quizResultDAO.saveQuizResult(result);  // Gọi hàm để lưu kết quả thi vào cơ sở dữ liệu

        if (saved) {
            // Nếu lưu thành công, xóa tất cả dữ liệu liên quan đến bài thi trong session
            session.removeAttribute("currentQuiz");
            session.removeAttribute("userAnswers");
            session.removeAttribute("userImages");
            session.removeAttribute("quizStartTime");
            session.removeAttribute("currentUserId");

            // Điều hướng người dùng về trang practice list với thông báo thành công
            response.sendRedirect(request.getContextPath() + "/practicelist");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to save quiz result");
        }
    }

    
    private void saveUserAnswers(int userId, Quiz quiz, Map<Integer, String> userAnswers, Map<Integer, String> userImages) {
        UserAnswerDAO userAnswerDAO = new UserAnswerDAO();

        for (int i = 0; i < quiz.getQuestions().size(); i++) {
            Question question = quiz.getQuestions().get(i);
            String userAnswer = userAnswers != null ? userAnswers.get(i) : null;
            String imagePath = userImages != null ? userImages.get(i) : null;

            if (userAnswer != null && !userAnswer.trim().isEmpty()) {
                boolean isCorrect = false;

                // Kiểm tra đáp án đúng
                if ("text_input".equals(question.getQuestionType())) {
                    isCorrect = quizDAO.isTextAnswerCorrect(question.getId(), userAnswer);
                } else {
                    // Multiple choice
                    try {
                        int userAnswerId = Integer.parseInt(userAnswer);
                        QuestionAnswer correctAnswer = quizDAO.getCorrectAnswer(question.getId());
                        if (correctAnswer != null && userAnswerId == correctAnswer.getId()) {
                            isCorrect = true;
                        }
                    } catch (NumberFormatException e) {
                        // Handle string comparison if needed
                    }
                }

                userAnswerDAO.saveUserAnswer(userId, quiz.getId(), question.getId(), userAnswer, imagePath, isCorrect);
            }
        }
    }
    
    private double calculateScore(Quiz quiz, Map<Integer, String> userAnswers) {
        if (userAnswers == null || userAnswers.isEmpty()) {
            return 0.0;
        }

        double correctAnswers = 0;
        double totalQuestions = quiz.getQuestions().size();

        for (int i = 0; i < quiz.getQuestions().size(); i++) {
            Question question = quiz.getQuestions().get(i);
            String userAnswer = userAnswers.get(i);

            if (userAnswer != null && !userAnswer.trim().isEmpty()) {
                if ("text_input".equals(question.getQuestionType())) {
                    if (quizDAO.isTextAnswerCorrect(question.getId(), userAnswer)) {
                        correctAnswers++;
                    }
                } else {
                    // Multiple choice
                    QuestionAnswer correctAnswer = null;
                    for (QuestionAnswer answer : question.getAnswers()) {
                        if (answer.isCorrect()) {
                            correctAnswer = answer;
                            break;
                        }
                    }

                    if (correctAnswer != null) {
                        try {
                            int userAnswerId = Integer.parseInt(userAnswer);
                            if (userAnswerId == correctAnswer.getId()) {
                                correctAnswers++;
                            }
                        } catch (NumberFormatException e) {
                            if (userAnswer.equals(correctAnswer.getContent())) {
                                correctAnswers++;
                            }
                        }
                    }
                }
            }
        }
        return (correctAnswers / totalQuestions) * 10.0;
    }
    
    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        String param = request.getParameter(paramName);
        if (param != null && !param.trim().isEmpty()) {
            try {
                return Integer.parseInt(param);
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }
}