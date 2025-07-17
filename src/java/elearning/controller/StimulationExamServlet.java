package elearning.controller;

import elearning.BasicDAO.StimulationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import elearning.entities.StimulationExam;

@WebServlet("/stimulation-exam")
public class StimulationExamServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("search");
        StimulationDAO dao = new StimulationDAO();
        List<StimulationExam> list;

        try {
            if (keyword != null && !keyword.trim().isEmpty()) {
                list = dao.searchByKeyword(keyword.trim());
            } else {
                list = dao.getAllStimulationExams();
            }

            request.setAttribute("stimulationList", list);
            request.setAttribute("search", keyword);
            request.getRequestDispatcher("/StimulationExam.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi truy vấn dữ liệu");
        }
    }
}
