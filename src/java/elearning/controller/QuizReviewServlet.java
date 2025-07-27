package elearning.controller;

import elearning.BasicDAO.QuizDAO;
import elearning.BasicDAO.UserAnswerDAO;
import elearning.BasicDAO.QuizResultDAO;
import elearning.entities.Quiz;
import elearning.entities.Question;
import elearning.entities.UserAnswer;
import elearning.entities.QuizResult;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "QuizReviewServlet", urlPatterns = {"/quizreview", "/quizreview/delete"})
public class QuizReviewServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        String path = request.getServletPath();

        // Xử lý delete request
        if ("/quizreview/delete".equals(path)) {
            String quizIdParam = request.getParameter("quizId");
            Integer userId = (session != null)
                    ? (Integer) session.getAttribute("currentUserId")
                    : null;
            if (quizIdParam != null && userId != null) {
                int quizId = Integer.parseInt(quizIdParam);
                new UserAnswerDAO().deleteAnswersByQuiz(userId, quizId);
                // Redirect về lại review với quizId
                response.sendRedirect(request.getContextPath()
                        + "/quizreview?quizId=" + quizId);
            }            
            return;
        }

        // Hiển thị review (/quizreview?quizId=...)
        String quizIdParam = request.getParameter("quizId");
        if (quizIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/practicelist");
            return;
        }
        int quizId = Integer.parseInt(quizIdParam);
        if (session != null) {
            session.setAttribute("currentQuizId", quizId);
        }

        Integer userId = (session != null) ? (Integer) session.getAttribute("currentUserId") : null;
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Load dữ liệu quiz, câu hỏi, kết quả
        Quiz quiz = new QuizDAO().getQuizWithQuestions(quizId);
        UserAnswerDAO uaDAO = new UserAnswerDAO();
        List<UserAnswer> userAnswers = new ArrayList<>();
        if (quiz != null && quiz.getQuestions() != null) {
            for (Question q : quiz.getQuestions()) {
                userAnswers.add(
                        uaDAO.getUserAnswerByQuestion(userId, quizId, q.getId())
                );
            }
        }
        QuizResult quizResult = new QuizResultDAO().getQuizResult(userId, quizId);

        // Đẩy sang JSP
        request.setAttribute("quiz", quiz);
        request.setAttribute("userAnswers", userAnswers);
        request.setAttribute("quizResult", quizResult);
        request.getRequestDispatcher("/quizreview.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
