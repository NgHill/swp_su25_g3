/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package elearning.controller;

import elearning.BasicDAO.QuizDAO;
import elearning.BasicDAO.QuizResultDAO;
import elearning.entities.Question;
import elearning.entities.QuestionAnswer;
import elearning.entities.Quiz;
import elearning.entities.QuizResult;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Lenovo
 */
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
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet QuizHandleServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet QuizHandleServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Lấy tham số
        int quizId = 2; // Mặc định quizId = 1
        int userId = 1; // Mặc định userId = 1
        
        String quizIdParam = request.getParameter("quizId");
        String userIdParam = request.getParameter("userId");
        
        if (quizIdParam != null && !quizIdParam.trim().isEmpty()) {
            try {
                quizId = Integer.parseInt(quizIdParam);
            } catch (NumberFormatException e) {
                quizId = 1;
            }
        }
        
        if (userIdParam != null && !userIdParam.trim().isEmpty()) {
            try {
                userId = Integer.parseInt(userIdParam);
            } catch (NumberFormatException e) {
                userId = 1;
            }
        }
        
        // Lấy thông tin quiz và questions
        Quiz quiz = quizDAO.getQuizWithQuestions(quizId);
        
        if (quiz == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Quiz not found");
            return;
        }
        
        // Lấy session để lưu trữ thông tin quiz
        HttpSession session = request.getSession();
        session.setAttribute("currentQuiz", quiz);
        session.setAttribute("currentUserId", userId);
        
        // Lấy thông tin về question index hiện tại
        int currentQuestionIndex = 0;
        String indexParam = request.getParameter("questionIndex");
        if (indexParam != null && !indexParam.trim().isEmpty()) {
            try {
                currentQuestionIndex = Integer.parseInt(indexParam);
                if (currentQuestionIndex < 0 || currentQuestionIndex >= quiz.getQuestions().size()) {
                    currentQuestionIndex = 0;
                }
            } catch (NumberFormatException e) {
                currentQuestionIndex = 0;
            }
        }
        
        // Lấy câu hỏi hiện tại
        Question currentQuestion = quiz.getQuestions().get(currentQuestionIndex);
        
        // Lấy answers từ session (nếu có)
        @SuppressWarnings("unchecked")
        Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
        if (userAnswers == null) {
            userAnswers = new HashMap<>();
            session.setAttribute("userAnswers", userAnswers);
        }
        
        // Chuẩn bị dữ liệu cho JSP
        request.setAttribute("quiz", quiz);
        request.setAttribute("currentQuestion", currentQuestion);
        request.setAttribute("currentQuestionIndex", currentQuestionIndex);
        request.setAttribute("totalQuestions", quiz.getQuestions().size());
        request.setAttribute("userAnswers", userAnswers);
        request.setAttribute("isPracticeMode", true); // Có thể thay đổi theo logic
        
        // Lưu thời gian bắt đầu quiz
        Long startTime = (Long) session.getAttribute("quizStartTime");
        if (startTime == null) {
            startTime = System.currentTimeMillis();
            session.setAttribute("quizStartTime", startTime);
        }

        // Tính thời gian còn lại
        long elapsedSeconds = (System.currentTimeMillis() - startTime) / 1000;
        int timeLeft = (int) (quiz.getDuration() * 60 - elapsedSeconds);
        if (timeLeft < 0) timeLeft = 0;
        request.setAttribute("timeLeft", timeLeft);

        // Chuyển đến JSP
        request.getRequestDispatcher("/quizhandle.jsp").forward(request, response);
    
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("saveAnswer".equals(action)) {
            saveAnswer(request, response);
        } else if ("submitQuiz".equals(action)) {
            submitQuiz(request, response);
        } else if ("navigation".equals(action)) {
            handleNavigation(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }      
    }
    
    private void saveAnswer(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
    
        String questionIndexStr = request.getParameter("questionIndex");
        String selectedAnswer = request.getParameter("selectedAnswer");
        String textAnswer = request.getParameter("textAnswer");
        String extractedText = request.getParameter("extractedText");

        if (questionIndexStr != null && (selectedAnswer != null || textAnswer != null)) {
            try {
                int questionIndex = Integer.parseInt(questionIndexStr);
                HttpSession session = request.getSession();
                
                Quiz quiz = (Quiz) session.getAttribute("currentQuiz");
                if (quiz == null || questionIndex < 0 || questionIndex >= quiz.getQuestions().size()) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\": false, \"message\": \"Invalid question index\"}");
                    return;
                }
                
                Question question = quiz.getQuestions().get(questionIndex);
                String answerToSave = null;
                
                // Xác định loại câu hỏi và lưu đáp án tương ứng
                if ("text_input".equals(question.getQuestionType())) {
                    // Kết hợp text input + OCR text
                    String finalAnswer = "";
                    if (textAnswer != null && !textAnswer.trim().isEmpty()) {
                        finalAnswer = textAnswer.trim();
                    } else if (extractedText != null && !extractedText.trim().isEmpty()) {
                        finalAnswer = extractedText.trim();
                    }
                    answerToSave = finalAnswer;
                }

                @SuppressWarnings("unchecked")
                Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
                if (userAnswers == null) {
                    userAnswers = new HashMap<>();
                    session.setAttribute("userAnswers", userAnswers);
                }

                userAnswers.put(questionIndex, answerToSave);

                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"message\": \"Answer saved\", \"questionType\": \"" + question.getQuestionType() + "\"}");
            } catch (NumberFormatException e) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Invalid question index\"}");
            }
        } else {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid data\"}");
        }
    }
    
    private void submitQuiz(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
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
            // Xóa session data
            session.removeAttribute("currentQuiz");
            session.removeAttribute("userAnswers");
            
            // Chuyển đến trang kết quả
            response.sendRedirect("home.jsp");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to save quiz result");
        }
    }
    
    private void handleNavigation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String direction = request.getParameter("direction");
        String currentIndexParam = request.getParameter("currentIndex");
        
        int currentIndex = 0;
        if (currentIndexParam != null && !currentIndexParam.trim().isEmpty()) {
            try {
                currentIndex = Integer.parseInt(currentIndexParam);
            } catch (NumberFormatException e) {
                currentIndex = 0;
            }
        }
        
        HttpSession session = request.getSession();
        Quiz quiz = (Quiz) session.getAttribute("currentQuiz");
        
        if (quiz == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Quiz session not found");
            return;
        }
        
        int newIndex = currentIndex;
        
        if ("next".equals(direction)) {
            if (currentIndex < quiz.getQuestions().size() - 1) {
                newIndex = currentIndex + 1;
            }
        } else if ("prev".equals(direction)) {
            if (currentIndex > 0) {
                newIndex = currentIndex - 1;
            }
        } else if ("goto".equals(direction)) {
            String gotoIndexParam = request.getParameter("gotoIndex");
            if (gotoIndexParam != null && !gotoIndexParam.trim().isEmpty()) {
                try {
                    int gotoIndex = Integer.parseInt(gotoIndexParam);
                    if (gotoIndex >= 0 && gotoIndex < quiz.getQuestions().size()) {
                        newIndex = gotoIndex;
                    }
                } catch (NumberFormatException e) {
                    // Keep current index
                }
            }
        }
        
        // Redirect với question index mới
        response.sendRedirect("handle?quizId=" + quiz.getId() + "&questionIndex=" + newIndex);
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
                    // Xử lý câu hỏi text input
                    if (quizDAO.isTextAnswerCorrect(question.getId(), userAnswer)) {
                        correctAnswers++;
                    }
                } else {
                    // Xử lý câu hỏi multiple choice
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
                            // Fallback: so sánh với content
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

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
