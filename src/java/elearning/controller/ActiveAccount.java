/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package elearning.controller;

import elearning.DAO.UserDAO;
import elearning.entities.User;
import elearning.utils.RandomUtils;
import jakarta.servlet.ServletConfig;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
@WebServlet(name = "ActiveAccount", urlPatterns = {"/active-account"})
public class ActiveAccount extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        config.getServletContext().setAttribute("/active-account", this);
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
            out.println("<title>Servlet ActiveAccount</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ActiveAccount at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // Phương thức xử lý khi người dùng truy cập vào liên kết kích hoạt (GET request)
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy email và mã kích hoạt từ URL (thường được truyền qua liên kết trong email)
        String email = request.getParameter("email");
        String activeCode = request.getParameter("activeCode");

        // Gửi dữ liệu vào request để hiển thị lại ở trang kích hoạt (active-account.jsp)
        request.setAttribute("email", email);
        request.setAttribute("activeCode", activeCode);

        // Chuyển hướng người dùng tới trang active-account.jsp để nhập mật khẩu mới và kích hoạt tài khoản
        request.getRequestDispatcher("complete-register.jsp").forward(request, response);
    }

// Phương thức xử lý khi người dùng submit form kích hoạt tài khoản (POST request)
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy dữ liệu từ form gửi lên
            String email = request.getParameter("email");
            String activeCode = request.getParameter("activeCode");
            String password = request.getParameter("password");

            // Tìm người dùng dựa vào email (hoặc mobile – ở đây dùng chung giá trị email)
            User user = userDAO.findByEmailOrPhone(email, email);

            // Kiểm tra mã kích hoạt có khớp với mã đang lưu trong hệ thống hay không
            if (activeCode != null && activeCode.equals(user.getActiveCode())) {
                // Nếu hợp lệ: cập nhật trạng thái tài khoản thành 'active'
                user.setStatus("active");
                // Đổi mã kích hoạt để tránh bị dùng lại (giá trị mới ngẫu nhiên)
                user.setActiveCode(RandomUtils.getRandomActiveCode(10L));
                // Lưu mật khẩu mới mà người dùng vừa nhập
                user.setPassword(password);
                // Cập nhật lại thông tin người dùng trong database
                userDAO.update(user);

                // Đặt thông báo thành công vào session và chuyển hướng sang trang đăng nhập
                request.getSession().setAttribute("success_message", "Account active successfully, please login!");
                response.sendRedirect("login");
                return;
            }

            // Nếu mã kích hoạt không hợp lệ thì hiển thị lỗi
            request.setAttribute("erorr", "Active link is not valid!");

        } catch (Exception e) {
            // In log lỗi nếu có exception xảy ra
            e.printStackTrace();
            // Thông báo lỗi hệ thống
            request.setAttribute("erorr", "System error!");
        }

        // Nếu xảy ra lỗi thì hiển thị lại trang kích hoạt cùng thông báo lỗi
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
