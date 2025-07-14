package elearning.controller;

import elearning.BasicDAO.RegistrationBasicDAO;
import elearning.BasicDAO.SubjectPackageBasicDAO;
import elearning.entities.Registration;
import elearning.entities.SubjectPackage;
import elearning.entities.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "SubjectRegister", urlPatterns = {"/subject-register"})
public class SubjectRegister extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String subjectIdStr = request.getParameter("subjectId");

        if (subjectIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/subject-list");
            return;
        }

        try {
            int subjectId = Integer.parseInt(subjectIdStr);

            SubjectPackageBasicDAO subjectDAO = new SubjectPackageBasicDAO();
            SubjectPackage subject = subjectDAO.getById(subjectId);

            if (subject == null) {
                response.sendRedirect(request.getContextPath() + "/subject-list");
                return;
            }

            request.setAttribute("subject", subject);
            HttpSession session = request.getSession(false);
            if (session != null) {
                request.setAttribute("userAuth", session.getAttribute("userAuth"));
            }

            request.getRequestDispatcher("subjectRegister.jsp").forward(request, response);

        } catch (NumberFormatException | SQLException ex) {
            Logger.getLogger(SubjectRegister.class.getName()).log(Level.SEVERE, null, ex);
            response.sendRedirect(request.getContextPath() + "/subject-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String confirm = request.getParameter("confirm");
        String subjectIdStr = request.getParameter("subjectId");
        String packageMonthsStr = request.getParameter("packageMonths");
        String priceStr = request.getParameter("price");

        int subjectId;
        int packageMonths;
        double price;

        try {
            subjectId = Integer.parseInt(subjectIdStr);
            packageMonths = (packageMonthsStr != null) ? Integer.parseInt(packageMonthsStr) : 1;
            price = (priceStr != null) ? Double.parseDouble(priceStr) : 0.0;
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/subject-list");
            return;
        }

        SubjectPackageBasicDAO subjectDAO = new SubjectPackageBasicDAO();
        SubjectPackage subject = null;
        try {
            subject = subjectDAO.getById(subjectId);
        } catch (SQLException ex) {
            Logger.getLogger(SubjectRegister.class.getName()).log(Level.SEVERE, null, ex);
        }

        HttpSession session = request.getSession(false);
        Object userObj = (session != null) ? session.getAttribute("userAuth") : null;

        // Tạo đối tượng đăng ký
        Registration registration = new Registration();
        registration.setSubjectId(subjectId);
        registration.setTotalCost(price);
        registration.setStatus("submitted");
        registration.setPackageMonths(packageMonths);

        Date now = new Date();
        registration.setCreatedAt(now);
        registration.setValidFrom(now);

        Calendar cal = Calendar.getInstance();
        cal.setTime(now);
        cal.add(Calendar.MONTH, packageMonths);
        registration.setValidTo(cal.getTime());

        if (userObj != null) {
            User user = (User) userObj;
            registration.setUserId(user.getId());
        } else {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String mobile = request.getParameter("mobile");
            String genderStr = request.getParameter("gender");

            registration.setRegisteredFullName(fullName);
            registration.setRegisteredEmail(email);
            registration.setRegisteredMobile(mobile);
            if (genderStr != null) {
                registration.setRegisteredGender(Boolean.parseBoolean(genderStr));
            }
        }

        if (confirm == null) {
            // Hiển thị lại để xác nhận
            request.setAttribute("registration", registration);
            request.setAttribute("subject", subject);
            request.setAttribute("userAuth", userObj);
            request.getRequestDispatcher("subjectRegister.jsp").forward(request, response);
        } else {
            // Xác nhận và lưu
            try {
                RegistrationBasicDAO dao = new RegistrationBasicDAO();
                dao.insert(registration);
                response.sendRedirect(request.getContextPath() + "/my-registration");
            } catch (SQLException ex) {
                Logger.getLogger(SubjectRegister.class.getName()).log(Level.SEVERE, null, ex);
                request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
                request.setAttribute("subject", subject);
                request.setAttribute("registration", registration);
                request.setAttribute("userAuth", userObj);
                request.getRequestDispatcher("subjectRegister.jsp").forward(request, response);
            }
        }
    }
}
