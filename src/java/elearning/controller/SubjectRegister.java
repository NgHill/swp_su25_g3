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

// Định nghĩa servlet với đường dẫn URL: /subject-register
@WebServlet(name = "SubjectRegister", urlPatterns = {"/subject-register"})
public class SubjectRegister extends HttpServlet {

    // =============================
    // XỬ LÝ YÊU CẦU GET (Hiển thị form xác nhận)
    // =============================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy subjectId từ query parameter (ví dụ: /subject-register?subjectId=3)
        String subjectIdStr = request.getParameter("subjectId");

        try {
            // Ép kiểu sang số nguyên
            int subjectId = Integer.parseInt(subjectIdStr);

            // Lấy thông tin môn học từ database
            SubjectPackageBasicDAO subjectDAO = new SubjectPackageBasicDAO();
            SubjectPackage subject = subjectDAO.getById(subjectId);

            // Đưa dữ liệu môn học vào request để hiển thị lên JSP
            request.setAttribute("subject", subject);

            // Nếu có session đang tồn tại (user đã đăng nhập), lấy thông tin user
            HttpSession session = request.getSession(false);
            if (session != null) {
                request.setAttribute("userAuth", session.getAttribute("userAuth"));
            }

            // Gửi request đến trang xác nhận đăng ký
            request.getRequestDispatcher("subjectRegister.jsp").forward(request, response);

        } catch (NumberFormatException | SQLException ex) {
            // Nếu lỗi hoặc không có subjectId hợp lệ → quay lại danh sách môn học
            Logger.getLogger(SubjectRegister.class.getName()).log(Level.SEVERE, null, ex);
            response.sendRedirect(request.getContextPath() + "/subject-list");
        }
    }

    // =============================
    // XỬ LÝ YÊU CẦU POST (Khi người dùng gửi form đăng ký)
    // =============================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy dữ liệu từ form POST gửi lên
        String confirm = request.getParameter("confirm"); // Nếu null → chưa xác nhận
        String subjectIdStr = request.getParameter("subjectId");
        String packageMonthsStr = request.getParameter("packageMonths");
        String priceStr = request.getParameter("price");

        int subjectId;
        int packageMonths;
        double price;

        try {
            // Ép kiểu dữ liệu từ form
            subjectId = Integer.parseInt(subjectIdStr);
            packageMonths = (packageMonthsStr != null) ? Integer.parseInt(packageMonthsStr) : 1;
            price = (priceStr != null) ? Double.parseDouble(priceStr) : 0.0;
        } catch (NumberFormatException e) {
            // Nếu lỗi dữ liệu → quay về trang danh sách
            response.sendRedirect(request.getContextPath() + "/subject-list");
            return;
        }

        // Lấy thông tin môn học tương ứng
        SubjectPackageBasicDAO subjectDAO = new SubjectPackageBasicDAO();
        SubjectPackage subject = null;
        try {
            subject = subjectDAO.getById(subjectId);
        } catch (SQLException ex) {
            Logger.getLogger(SubjectRegister.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Lấy thông tin người dùng nếu đã đăng nhập
        HttpSession session = request.getSession(false);
        Object userObj = (session != null) ? session.getAttribute("userAuth") : null;

        // Khởi tạo đối tượng đăng ký
        Registration registration = new Registration();
        registration.setSubjectId(subjectId);
        registration.setTotalCost(price);
        registration.setStatus("submitted");
        registration.setPackageMonths(packageMonths);

        // Tạo ngày bắt đầu và ngày kết thúc (dựa vào gói học)
        Date now = new Date();
        registration.setCreatedAt(now);
        registration.setValidFrom(now);

        Calendar cal = Calendar.getInstance();
        cal.setTime(now);
        cal.add(Calendar.MONTH, packageMonths); // Cộng thêm số tháng đã chọn
        registration.setValidTo(cal.getTime());

        // Nếu user đã login → gán userId
        if (userObj != null) {
            User user = (User) userObj;
            registration.setUserId(user.getId());
        } else {
            // Nếu chưa login → lấy thông tin từ form nhập tay
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

        // ===========================
        // Nếu người dùng chưa xác nhận → hiển thị lại để xác nhận lần cuối
        // ===========================
        if (confirm == null) {
            request.setAttribute("registration", registration);
            request.setAttribute("subject", subject);
            request.setAttribute("userAuth", userObj);
            request.getRequestDispatcher("subjectRegister.jsp").forward(request, response);
        } // ===========================
        // Nếu người dùng đã xác nhận → tiến hành lưu vào database
        // ===========================
        else {
            try {
                RegistrationBasicDAO dao = new RegistrationBasicDAO();
                dao.insert(registration); // Ghi dữ liệu vào bảng Registration
                response.sendRedirect(request.getContextPath() + "/my-registration");
            } catch (SQLException ex) {
                // Nếu lỗi khi insert → quay lại trang xác nhận, hiển thị lỗi
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
