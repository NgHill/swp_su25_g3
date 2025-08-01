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

@WebServlet(name="QuizHandleServlet", urlPatterns={"/quizhandle"})
public class QuizHandleServlet extends HttpServlet {
    private QuizDAO quizDAO;
    private QuizResultDAO quizResultDAO;
    
    
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

        if ("saveAnswer".equals(action)) {
            saveAnswer(request, response, session);
        } else if ("navigate".equals(action)) {
            navigateQuestion(request, response, session);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
       
    
    private void saveAnswer(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
    throws ServletException, IOException {

        int questionIndex = getIntParameter(request, "questionIndex", -1);
        String answer = request.getParameter("answer");
        String textAnswer = request.getParameter("textAnswer");

        if (questionIndex >= 0) {
            @SuppressWarnings("unchecked")
            Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
            if (userAnswers == null) {
                userAnswers = new HashMap<>();
                session.setAttribute("userAnswers", userAnswers);
            }

            // Lưu text answer
            String finalAnswer = textAnswer != null ? textAnswer.trim() : answer;
            if (finalAnswer != null && !finalAnswer.isEmpty()) {
                userAnswers.put(questionIndex, finalAnswer);
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

        // Lưu đáp án nếu có
        if (answer != null && !answer.trim().isEmpty()) {
            userAnswers.put(currentIndex, answer);
        } else if (textAnswer != null && !textAnswer.trim().isEmpty()) {
            userAnswers.put(currentIndex, textAnswer.trim());
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

        Quiz quiz = (Quiz) session.getAttribute("currentQuiz");
        Integer userId = (Integer) session.getAttribute("currentUserId");

        if (quiz == null || userId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quiz session not found");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
        if (userAnswers == null) {
            userAnswers = new HashMap<>();
        }

        // Lưu câu trả lời cuối cùng
        String lastAnswer = request.getParameter("lastAnswer");
        String lastTextAnswer = request.getParameter("lastTextAnswer");
        String lastQuestionIndex = request.getParameter("lastQuestionIndex");

        if (lastQuestionIndex != null) {
            try {
                int questionIndex = Integer.parseInt(lastQuestionIndex);
                if (questionIndex >= 0 && questionIndex < quiz.getQuestions().size()) {
                    String finalAnswer = lastTextAnswer != null && !lastTextAnswer.trim().isEmpty() 
                        ? lastTextAnswer.trim() : lastAnswer;
                    if (finalAnswer != null && !finalAnswer.isEmpty()) {
                        userAnswers.put(questionIndex, finalAnswer);
                    }
                }
            } catch (NumberFormatException e) {
                // Ignore invalid question index
            }
        }

        // Tính điểm
        double score = calculateScore(quiz, userAnswers);

        // Tạo QuizResult
        QuizResult result = new QuizResult();
        result.setUserId(userId);
        result.setQuizId(quiz.getId());
        result.setScore(score);
        result.setSubmittedAt(LocalDateTime.now());

        // SỬA: Lưu QuizResult trước và lấy ID
        int quizResultId = quizResultDAO.saveQuizResultWithId(result);

        if (quizResultId > 0) {
            saveUserAnswersWithResultId(userId, quiz, userAnswers, quizResultId);

            // Xóa session
            session.removeAttribute("currentQuiz");
            session.removeAttribute("userAnswers");
            session.removeAttribute("quizStartTime");
            session.removeAttribute("currentUserId");

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
                    // Lưu text answer
                    userAnswerDAO.saveTextAnswer(userId, quiz.getId(), question.getId(), userAnswer, isCorrect);
                } else {
                    // Multiple choice - cần lưu AnswerId thay vì TextAnswer
                    try {
                        int userAnswerId = Integer.parseInt(userAnswer);
                        QuestionAnswer correctAnswer = quizDAO.getCorrectAnswer(question.getId());
                        if (correctAnswer != null && userAnswerId == correctAnswer.getId()) {
                            isCorrect = true;
                        }
                        // SỬA: Sử dụng saveMultipleChoiceAnswer thay vì saveUserAnswer
                        userAnswerDAO.saveMultipleChoiceAnswer(userId, quiz.getId(), question.getId(), userAnswerId, isCorrect);
                    } catch (NumberFormatException e) {
                        // Nếu không parse được thì lưu như text
                        userAnswerDAO.saveTextAnswer(userId, quiz.getId(), question.getId(), userAnswer, isCorrect);
                    }
                }
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
    
    private void saveUserAnswersWithResultId(int userId, Quiz quiz, Map<Integer, String> userAnswers,int quizResultId) {
        UserAnswerDAO userAnswerDAO = new UserAnswerDAO();

        for (int i = 0; i < quiz.getQuestions().size(); i++) {
            Question question = quiz.getQuestions().get(i);
            String userAnswer = userAnswers != null ? userAnswers.get(i) : null;

            if (userAnswer != null && !userAnswer.trim().isEmpty()) {
                boolean isCorrect = false;

                if ("text_input".equals(question.getQuestionType())) {
                    isCorrect = quizDAO.isTextAnswerCorrect(question.getId(), userAnswer);
                    userAnswerDAO.saveUserAnswerWithResultId(userId, quiz.getId(), question.getId(), 
                        null, userAnswer, null, isCorrect, quizResultId);
                } else {
                    try {
                        int userAnswerId = Integer.parseInt(userAnswer);
                        QuestionAnswer correctAnswer = quizDAO.getCorrectAnswer(question.getId());
                        if (correctAnswer != null && userAnswerId == correctAnswer.getId()) {
                            isCorrect = true;
                        }
                        userAnswerDAO.saveUserAnswerWithResultId(userId, quiz.getId(), question.getId(), 
                            userAnswerId, null, null, isCorrect, quizResultId);
                    } catch (NumberFormatException e) {
                        // Log lỗi và bỏ qua câu trả lời không hợp lệ
                        System.err.println("Invalid answer format for multiple choice question: " + userAnswer);
                        // Không lưu câu trả lời không hợp lệ
                    }
                }
            }
        }
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