package elearning.controller;

import elearning.DAO.UserDAO;
import elearning.entities.User;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet(name = "Login", urlPatterns = {"/login"})
public class Login extends HttpServlet {

    // Khởi tạo DAO dùng để truy vấn thông tin người dùng
    private final UserDAO userDAO = new UserDAO();

    // Gán servlet login vào context (ít dùng, có thể bỏ nếu không cần thiết)
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        config.getServletContext().setAttribute("/login", this);
    }

    // Phương thức mặc định để test HTML (không sử dụng trong thực tế)
    public void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
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

    // ========================== Xử lý khi người dùng truy cập trang login [GET] ==========================
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Nếu session có thông báo thành công (từ trang khác chuyển về), thì đưa vào request
        if (request.getSession().getAttribute("success_message") != null) {
            request.setAttribute("success_message", request.getSession().getAttribute("success_message"));
            request.getSession().setAttribute("success_message", null);
        }

        // Nếu đã đăng nhập rồi thì chuyển hướng sang trang theo role
        User userAuth = (User) request.getSession().getAttribute("userAuth");


        if (userAuth != null) {
            // Nếu tài khoản bị khóa
            if ("inactive".equalsIgnoreCase(userAuth.getStatus())) {
                request.setAttribute("error", "Your account has been INACTIVE by the Admin!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Tài khoản hợp lệ và đang hoạt động
            request.getSession().setAttribute("userAuth", userAuth);

            switch (userAuth.getRole()) {
                case "mtk" ->
                    response.sendRedirect("mtk-dashboard");
                case "admin" ->
                    response.sendRedirect("userlist");
                case "courseContent" ->
                    response.sendRedirect("subject-list2");
                default ->
                    response.sendRedirect("home");
            }
            return;

        } else {
            // Không tìm thấy tài khoản
            request.setAttribute("error", "Thông tin đăng nhập sai.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }

        // Nếu chưa đăng nhập, thì hiển thị form đăng nhập
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    // ====================== [POST] ==========================
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy username và password từ form
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            // Kiểm tra trong DB xem có user hợp lệ không
            User userAuth = userDAO.login(username, password);

            if (userAuth != null) {
                // Nếu tài khoản bị khóa
                if ("inactive".equalsIgnoreCase(userAuth.getStatus())) {
                    request.setAttribute("error", "Your account has been INACTIVE by the Admin!");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                // Tài khoản hợp lệ và đang hoạt động
                request.getSession().setAttribute("userAuth", userAuth);

                switch (userAuth.getRole()) {
                    case "mtk" ->
                        response.sendRedirect("mtk-dashboard");
                    case "admin" ->
                        response.sendRedirect("userlist");
                    case "courseContent" ->
                        response.sendRedirect("subject-list2");
                    default ->
                        response.sendRedirect("home");
                }
                return;

            } else {
                // Không tìm thấy tài khoản
                request.setAttribute("error", "Thông tin đăng nhập sai.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (SQLException ex) {
            ex.printStackTrace(); // In lỗi ra console (gợi ý: log ra file thì tốt hơn)
            request.setAttribute("error", "Hệ thống đang bảo trì");
        }

        // Gọi lại doGet để hiển thị trang login cùng với thông báo lỗi
        doGet(request, response);
    }

    // Mô tả ngắn về servlet (thường không dùng)
    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
