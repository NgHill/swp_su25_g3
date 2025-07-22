package elearning.controller;

import elearning.BasicDAO.RegistrationBasicDAO;
import elearning.anotation.AccessRoles;
import elearning.entities.Registration;
import elearning.entities.User;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "MyRegistration", urlPatterns = {"/my-registration"})
public class MyRegistration extends HttpServlet {

    private RegistrationBasicDAO registrationDAO;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        registrationDAO = new RegistrationBasicDAO();
    }

    @Override
    @AccessRoles(roles = "customer")
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("userAuth");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String keyword = request.getParameter("search");
        String[] selectedCategories = request.getParameterValues("cat");

        try {
            // Gán danh sách tất cả category cố định
            List<String> allCategories = Arrays.asList("Communication", "Self improve", "Teamwork", "Thinking");
            request.setAttribute("allCategories", allCategories);
            request.setAttribute("search", keyword);
            request.setAttribute("selectedCategories", selectedCategories);

            List<Registration> registrations;

            if ((keyword != null && !keyword.trim().isEmpty()) || (selectedCategories != null && selectedCategories.length > 0)) {
                registrations = registrationDAO.searchByKeywordAndCategories(user.getId(), keyword, selectedCategories);
            } else {
                registrations = registrationDAO.findByUserId(user.getId());
            }

            request.setAttribute("registrations", registrations);

        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi lấy danh sách đăng ký: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("myRegistration.jsp").forward(request, response);
    }

    @Override
    @AccessRoles(roles = "customer")
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                registrationDAO.deleteById(id);
            } catch (Exception e) {
                request.setAttribute("error", "Lỗi khi xoá đăng ký: " + e.getMessage());
                e.printStackTrace();
            }
        }

        response.sendRedirect("my-registration");
    }
}
