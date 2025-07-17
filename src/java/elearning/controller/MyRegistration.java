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

        try {
            // ✅ Đúng phương thức
            List<Registration> registrations = registrationDAO.findByUserId(user.getId());
            request.setAttribute("registrations", registrations);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi lấy danh sách đăng ký: " + e.getMessage());
            e.printStackTrace(); // để log ra cho dễ debug
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

        // ✅ Sau khi xoá thì redirect để load lại danh sách
        response.sendRedirect("my-registration");
    }
}
