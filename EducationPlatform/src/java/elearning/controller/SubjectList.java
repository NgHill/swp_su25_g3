package elearning.controller;

import elearning.anotation.AccessRoles;
import elearning.BasicDAO.SubjectPackageBasicDAO;
import elearning.entities.SubjectPackage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/subject-list")
public class SubjectList extends HttpServlet {

    @Override
    @AccessRoles(roles = "customer")
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy các tham số từ request
        String search = request.getParameter("search");
        String category = request.getParameter("cat");

        if (search == null) search = "";
        if (category == null) category = "";

        // 2. Xử lý phân trang: page và pageSize
        int page = 1;
        int pageSize = 9;
        String rawPage = request.getParameter("page");
        String rawPageSize = request.getParameter("pageSize");

        try {
            if (rawPage != null) {
                page = Integer.parseInt(rawPage);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException ignored) {}

        try {
            if (rawPageSize != null) {
                pageSize = Integer.parseInt(rawPageSize);
                if (pageSize < 1) pageSize = 1;
                if (pageSize > 100) pageSize = 100;
            }
        } catch (NumberFormatException ignored) {}

        SubjectPackageBasicDAO dao = new SubjectPackageBasicDAO();

        try {
            // Tìm kiếm và/hoặc lọc theo category với phân trang
            int totalRecords = dao.countByKeywordAndCategory(search, category);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
            List<SubjectPackage> list = dao.findByKeywordAndCategory(search, category, page, pageSize);

            // Gửi dữ liệu về JSP
            request.setAttribute("subjects", list);
            request.setAttribute("search", search);
            request.setAttribute("cat", category);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);

        } catch (SQLException e) {
            throw new ServletException("Lỗi khi truy xuất SubjectPackages", e);
        }

        // Forward về JSP
        request.getRequestDispatcher("subjectList.jsp").forward(request, response);
    }
}
