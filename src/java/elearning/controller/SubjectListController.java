package elearning.controller;

import elearning.BasicDAO.SubjectListDAO;
import elearning.entities.SubjectList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "SubjectListController", urlPatterns = {"/subject-list2"})
public class SubjectListController extends HttpServlet {

    private final SubjectListDAO dao = new SubjectListDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String category = request.getParameter("category");
        String status = request.getParameter("status");
        String search = request.getParameter("search");
        String linesStr = request.getParameter("lines");

        int linesPerPage = 5;// Giá trị mặc định
        if (linesStr != null && !linesStr.isEmpty()) {
            try {
                linesPerPage = Integer.parseInt(linesStr); // Lấy giá trị "lines" từ URL
            } catch (NumberFormatException ignored) {
            }
        }

        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException ignored) {
            }
        }

        int offset = (page - 1) * linesPerPage;// Tính offset để phân trang

        // Lấy danh sách chủ đề dựa trên các tham số lọc và phân trang
        //  Bắt SQLException ở đây
        List<SubjectList> subjectList = dao.getFilteredSubjects(category, status, search, offset, linesPerPage);
        List<String> categoryList = dao.getAllCategory();
        request.setAttribute("subjectList", subjectList);
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("filterBy", request.getParameterValues("filterBy"));

        request.getRequestDispatcher("subject_list.jsp").forward(request, response);

    }
}
