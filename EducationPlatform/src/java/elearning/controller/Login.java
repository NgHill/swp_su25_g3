/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package elearning.controller;

import elearning.DAO.UserDAO;
import elearning.entities.User;
import jakarta.servlet.ServletConfig;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;

/**
 *
 * @author admin
 */
@WebServlet(name = "Login", urlPatterns = {"/login"})
public class Login extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        config.getServletContext().setAttribute("/login", this);
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
            out.println("<title>Servlet Login</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Login at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // Phương thức xử lý khi người dùng truy cập trang login (GET request)
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra xem có thông báo thành công (sau khi kích hoạt tài khoản) lưu trong session không
        if (request.getSession().getAttribute("success_message") != null) {
            // Gán lại thông báo thành công vào request để hiển thị lên trang login.jsp
            request.setAttribute("success_message", request.getSession().getAttribute("success_message"));
            // Xóa thông báo trong session để tránh hiển thị lại lần sau
            request.getSession().setAttribute("success_message", null);
        }

        // Kiểm tra nếu người dùng đã đăng nhập rồi (tồn tại userAuth trong session)
        User userAuth = (User) request.getSession().getAttribute("userAuth");
        if (userAuth != null) {
            // Nếu đã đăng nhập, chuyển hướng về trang blog (không cần hiển thị lại login)
            response.sendRedirect("blog");
            return;
        }

        // Nếu chưa đăng nhập, hiển thị trang đăng nhập login.jsp
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

// Phương thức xử lý khi người dùng submit form login (POST request)
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy thông tin username và password từ form gửi lên
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            // Gọi hàm login từ DAO để kiểm tra thông tin đăng nhập
            User userAuth = userDAO.login(username, password);

            // Nếu thông tin đăng nhập hợp lệ
            if (userAuth != null) {
                if (userAuth.getStatus().equals("active")) {
                    request.getSession().setAttribute("userAuth", userAuth);
                    // Chuyển hướng đến trang blog
                    response.sendRedirect("blog");
                    return;

                // Nếu tài khoản chưa kích hoạt
                }
                request.setAttribute("error", "Account is not active");
            } else {
                // Nếu thông tin đăng nhập không đúng
                request.setAttribute("error", "Login fail");
            }

        } catch (SQLException ex) {
            // In lỗi nếu có exception xảy ra khi truy vấn DB
            ex.printStackTrace();
            // Thông báo lỗi hệ thống
            request.setAttribute("error", "System error");
        }

        // Gọi lại phương thức doGet để hiển thị lại trang login.jsp với thông báo lỗi
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
