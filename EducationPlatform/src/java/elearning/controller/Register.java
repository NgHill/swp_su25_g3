/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package elearning.controller;

import elearning.DAO.UserDAO;
import elearning.entities.User;
import elearning.utils.MailUtils;
import elearning.utils.RandomUtils;
import jakarta.servlet.ServletConfig;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Date;

/**
 *
 * @author admin
 */
@WebServlet(name = "Register", urlPatterns = {"/register"})
public class Register extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        config.getServletContext().setAttribute("/register", this);
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    public void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Register</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Register at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // Phương thức xử lý khi người dùng gửi yêu cầu GET đến servlet (thường là khi mở trang đăng ký)
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng request đến trang register.jsp để hiển thị giao diện đăng ký
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

// Phương thức xử lý khi người dùng gửi yêu cầu POST đến servlet (khi submit form đăng ký)
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy dữ liệu từ form gửi lên
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String mobile = request.getParameter("mobile");
            // Kiểm tra giới tính: nếu giá trị là "1" thì là nam (true), ngược lại là nữ (false)
            boolean gender = request.getParameter("gender").equals("1");

            // Kiểm tra xem người dùng đã tồn tại qua email hoặc số điện thoại chưa
            User user = userDAO.findByEmailOrPhone(email, mobile);

            if (user == null) { // Nếu chưa tồn tại
                // Tạo đối tượng người dùng mới với trạng thái pending (chờ xác thực)
                user = User.builder()
                        .fullName(fullName)
                        .email(email)
                        .mobile(mobile)
                        .gender(gender)
                        .activeCode(RandomUtils.getRandomActiveCode(10L)) // Mã xác thực ngẫu nhiên dài 10 ký tự
                        .status("pending")
                        .role("customer")
                        .createdAt(new Date())
                        .build();

                // Gửi email kích hoạt tài khoản tới email người dùng
                MailUtils.sentEmail(email, "Welcome to ELearning", "Enter this link to active your account: "
                        + "<a href='http://localhost:9999/EducationPlatform/active-account?email="
                        + email + "&activeCode=" + user.getActiveCode() + "'>Click here</a>"
                        + "<br> <h3 style='color:red'>Dont share it to anyone!</h3>");

                // Lưu người dùng mới vào cơ sở dữ liệu
                userDAO.insert(user);

                // Gửi lại thông tin về trang đăng ký cùng thông báo yêu cầu kiểm tra email
                request.setAttribute("fullName", fullName);
                request.setAttribute("email", email);
                request.setAttribute("mobile", mobile);
                request.setAttribute("error", "Click the link in email: " + email + " to register account!");

                // Gọi lại phương thức doGet để hiển thị lại trang register.jsp
                doGet(request, response);
                return;
            }

            // Nếu email hoặc số điện thoại đã tồn tại thì báo lỗi
            request.setAttribute("error", "Email or mobile is existed");
        } catch (Exception e) {
            // Ghi log lỗi nếu có ngoại lệ xảy ra
            e.printStackTrace();
            // Báo lỗi hệ thống
            request.setAttribute("error", "System error");
        }

        // Trả về trang register.jsp kèm theo thông báo lỗi
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
