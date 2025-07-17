
package elearning.controller;

import elearning.BasicDAO.SubjectPackageBasicDAO;
import elearning.entities.SubjectPackage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/subject-detail")
public class SubjectDetail extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy id từ request
        String rawId = request.getParameter("id");
        if (rawId == null || !rawId.matches("\\d+")) {
            response.sendRedirect(request.getContextPath() + "/subject-list");
            return;
        }

        int id = Integer.parseInt(rawId);
        SubjectPackageBasicDAO dao = new SubjectPackageBasicDAO();

        try {
            SubjectPackage subject = dao.getById(id);
            if (subject == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy môn học.");
                return;
            }

            request.setAttribute("subject", subject);
            request.getRequestDispatcher("subjectDetail.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Lỗi khi lấy thông tin chi tiết môn học", e);
        }
    }
}