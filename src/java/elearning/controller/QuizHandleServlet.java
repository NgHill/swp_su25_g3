/*
 * Simplified QuizHandleServlet
 */

package elearning.controller;

import elearning.BasicDAO.QuizDAO;
import elearning.BasicDAO.QuizResultDAO;
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
        int quizId = getIntParameter(request, "quizId", 1);
        int userId = getIntParameter(request, "userId", 1);
        int questionIndex = getIntParameter(request, "questionIndex", 0);
        String action = request.getParameter("action");
        
        HttpSession session = request.getSession();
        
        // Xử lý action submit
        if ("submit".equals(action)) {
            submitQuiz(request, response, session);
            return;
        }
        
        // Lấy quiz từ session hoặc database
        Quiz quiz = (Quiz) session.getAttribute("currentQuiz");
        if (quiz == null || quiz.getId() != quizId) {
            quiz = quizDAO.getQuizWithQuestions(quizId);
            if (quiz == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Quiz not found");
                return;
            }
            session.setAttribute("currentQuiz", quiz);
            session.setAttribute("currentUserId", userId);
            session.setAttribute("quizStartTime", System.currentTimeMillis());
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
        
        if (questionIndex >= 0 && (answer != null || textAnswer != null)) {
            @SuppressWarnings("unchecked")
            Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
            if (userAnswers == null) {
                userAnswers = new HashMap<>();
                session.setAttribute("userAnswers", userAnswers);
            }
            
            String finalAnswer = textAnswer != null ? textAnswer.trim() : answer;
            if (finalAnswer != null && !finalAnswer.isEmpty()) {
                userAnswers.put(questionIndex, finalAnswer);
            }
            
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true}");
        } else {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false}");
        }
    }
    
    private void navigateQuestion(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
    throws ServletException, IOException {
        
        int currentIndex = getIntParameter(request, "currentIndex", 0);
        int targetIndex = getIntParameter(request, "targetIndex", currentIndex);
        String direction = request.getParameter("direction");
        
        Quiz quiz = (Quiz) session.getAttribute("currentQuiz");
        if (quiz == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quiz session not found");
            return;
        }
        
        // Xử lý direction
        if ("next".equals(direction) && currentIndex < quiz.getQuestions().size() - 1) {
            targetIndex = currentIndex + 1;
        } else if ("prev".equals(direction) && currentIndex > 0) {
            targetIndex = currentIndex - 1;
        }
        
        // Validate target index
        if (targetIndex < 0 || targetIndex >= quiz.getQuestions().size()) {
            targetIndex = currentIndex;
        }
        
        // Redirect với index mới
        response.sendRedirect("quizhandle?quizId=" + quiz.getId() + "&questionIndex=" + targetIndex);
    }
    
    private void submitQuiz(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
    throws ServletException, IOException {
        
        Quiz quiz = (Quiz) session.getAttribute("currentQuiz");
        Integer userId = (Integer) session.getAttribute("currentUserId");
        
        @SuppressWarnings("unchecked")
        Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
        
        if (quiz == null || userId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quiz session not found");
            return;
        }
        
        // Tính điểm
        double score = calculateScore(quiz, userAnswers);
        
        // Lưu kết quả
        QuizResult result = new QuizResult();
        result.setUserId(userId);
        result.setQuizId(quiz.getId());
        result.setScore(score);
        result.setSubmittedAt(LocalDateTime.now());
        
        boolean saved = quizResultDAO.saveQuizResult(result);
        
        if (saved) {
            // Clear session
            session.removeAttribute("currentQuiz");
            session.removeAttribute("userAnswers");
            session.removeAttribute("quizStartTime");
            response.sendRedirect("home.jsp");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to save quiz result");
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