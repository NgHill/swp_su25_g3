/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package elearning.controller;

import elearning.BasicDAO.QuizDAO;
import elearning.BasicDAO.QuizResultDAO;
import elearning.BasicDAO.UserAnswerDAO;
import elearning.entities.Quiz;
import elearning.entities.QuizResult;
import elearning.entities.UserAnswerReview;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Lenovo
 */
@WebServlet(name="QuizReviewServlet", urlPatterns={"/quiz-review"})
public class QuizReviewServlet extends HttpServlet {
   
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
            out.println("<title>Servlet QuizReviewServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet QuizReviewServlet at " + request.getContextPath () + "</h1>");
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
        try {
            // Lấy resultId từ parameter
            String resultIdParam = request.getParameter("resultId");
            if (resultIdParam == null) {
                response.sendRedirect(request.getContextPath() + "/practicelist");
                return;
            }

            int resultId = Integer.parseInt(resultIdParam);

            // Khởi tạo các DAO
            QuizResultDAO quizResultDAO = new QuizResultDAO();
            QuizDAO quizDAO = new QuizDAO();
            UserAnswerDAO userAnswerDAO = new UserAnswerDAO();

            // Lấy quiz result
            QuizResult quizResult = quizResultDAO.getQuizResultById(resultId);
            if (quizResult == null) {
                response.sendRedirect(request.getContextPath() + "/practicelist");
                return;
            }

            // Lấy quiz với questions
            Quiz quiz = quizDAO.getQuizWithQuestions(quizResult.getQuizId());

            List<UserAnswerReview> userAnswers = userAnswerDAO.getUserAnswersForReviewByResultId(resultId);

            // Tính toán thống kê
            int correctCount = 0;
            int incorrectCount = 0;
            for (UserAnswerReview userAnswer : userAnswers) {
                if (userAnswer.isCorrect()) {
                    correctCount++;
                } else {
                    incorrectCount++;
                }
            }

            request.setAttribute("correctCount", correctCount);
            request.setAttribute("incorrectCount", incorrectCount);
            
            // Set attributes
            request.setAttribute("quiz", quiz);
            request.setAttribute("quizResult", quizResult);
            request.setAttribute("userAnswers", userAnswers);

            // Forward đến quizreview.jsp
            request.getRequestDispatcher("quizreview.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/practicelist");
        }
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
        processRequest(request, response);
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
