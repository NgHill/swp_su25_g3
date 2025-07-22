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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        

        String keyword = request.getParameter("search");
        String[] categories = request.getParameterValues("cat");

        StimulationDAO dao = new StimulationDAO();
        List<StimulationExam> list;
        List<String> allCategories;

        try {
            // Lấy danh sách tất cả categories để hiển thị trong filter
            allCategories = dao.getAllCategories();
            request.setAttribute("allCategories", allCategories);

            // Xử lý tìm kiếm và lọc
            if ((keyword != null && !keyword.trim().isEmpty())
                    || (categories != null && categories.length > 0)) {
                // Có tìm kiếm hoặc lọc category
                list = dao.searchByKeywordAndCategories(
                        (keyword != null && !keyword.trim().isEmpty()) ? keyword.trim() : null,
                        categories
                );
            } else {
                // Không có filter nào, lấy tất cả
                list = dao.getAllStimulationExams();
            }

            // Set attributes cho JSP
            request.setAttribute("stimulationList", list);
            request.setAttribute("search", keyword);
            request.setAttribute("selectedCategories", categories);

            // Forward đến JSP
            request.getRequestDispatcher("/StimulationExam.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Lỗi khi truy vấn dữ liệu: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển POST request thành GET request để xử lý filter
        doGet(request, response);
    }
}