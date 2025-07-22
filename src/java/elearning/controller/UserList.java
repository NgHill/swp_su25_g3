/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package elearning.controller;

import elearning.BasicDAO.PracticeListDAO;
import elearning.BasicDAO.UserListDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Lenovo
 */
@WebServlet(name="UserList", urlPatterns={"/userlist"})
public class UserList extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UserList</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UserList at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private final UserListDAO userlistDAO = new UserListDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Lấy dữ liệu filter & search từ request
        String search = request.getParameter("search");
        String genderFilter = request.getParameter("genderFilter");
        String roleFilter = request.getParameter("roleFilter");
        String statusFilter = request.getParameter("statusFilter");

        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        
        // Lấy tham số rowsPerPage mới
        String rowsPerPageStr = request.getParameter("rowsPerPage");
        int rowsPerPage = 500; // Giá trị mặc định
        
        // Xử lý và validate rowsPerPage
        if (rowsPerPageStr != null && !rowsPerPageStr.trim().isEmpty()) {
            try {
                rowsPerPage = Integer.parseInt(rowsPerPageStr.trim());
                // Validate giá trị hợp lệ (1-1000)
                if (rowsPerPage < 1) {
                    rowsPerPage = 1;
                } else if (rowsPerPage > 1000) {
                    rowsPerPage = 1000;
                }
            } catch (NumberFormatException e) {
                // Nếu không parse được, giữ giá trị mặc định
                rowsPerPage = 500;
            }
        }
        
        // Lấy thông tin sorting hiện tại từ session để xử lý toggle
        String currentSortBy = (String) request.getSession().getAttribute("currentSortBy");
        String currentSortOrder = (String) request.getSession().getAttribute("currentSortOrder");
        
        // Logic xử lý toggle sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            if (sortBy.equals(currentSortBy)) {
                // Nếu click vào cùng cột, toggle giữa asc và desc
                if ("asc".equals(currentSortOrder)) {
                    sortOrder = "desc";
                } else {
                    sortOrder = "asc";
                }
            } else {
                // Nếu click vào cột khác, mặc định là asc
                sortOrder = "asc";
            }
            
            // Lưu trạng thái sorting vào session
            request.getSession().setAttribute("currentSortBy", sortBy);
            request.getSession().setAttribute("currentSortOrder", sortOrder);
        } else {
            // Nếu không có tham số sortBy, sử dụng giá trị mặc định hoặc từ session
            if (currentSortBy != null) {
                sortBy = currentSortBy;
                sortOrder = currentSortOrder;
            } else {
                sortBy = "Id";
                sortOrder = "asc";
            }
        }
        
        // Đảm bảo không null
        search = (search == null) ? "" : search.trim();
        genderFilter = (genderFilter == null || genderFilter.equals("A")) ? "" : genderFilter.trim();
        roleFilter = (roleFilter == null || roleFilter.equals("A")) ? "" : roleFilter.trim();
        statusFilter = (statusFilter == null || statusFilter.equals("A")) ? "" : statusFilter.trim();
        
        // Gọi DAO để lấy dữ liệu
        List<elearning.entities.UserList> userLists = userlistDAO.searchAndFilterUsers(
            search,
            genderFilter,
            roleFilter,
            statusFilter,
            sortBy,
            sortOrder,
            rowsPerPage
        );

        // Gửi dữ liệu về lại JSP
        request.setAttribute("userLists", userLists);
        request.setAttribute("search", search);
        request.setAttribute("genderFilter", request.getParameter("genderFilter"));
        request.setAttribute("roleFilter", request.getParameter("roleFilter"));
        request.setAttribute("statusFilter", request.getParameter("statusFilter"));
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("rowsPerPage", rowsPerPage); 
        
        // Forward về trang hiển thị
        request.getRequestDispatcher("userList.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Set encoding để xử lý tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Kiểm tra action để phân biệt Add hay Edit
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            handleEditUser(request, response);
            return;
        }
        
        // Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String gender = request.getParameter("gender");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        // Biến để theo dõi có lỗi không
        boolean hasError = false;

        // Validate Full Name
        if (fullName == null || fullName.trim().length() < 5) {
            request.setAttribute("fullNameError", "Tên phải trên 5 ký tự");
            hasError = true;
        } else if (!isValidFullNameFormat(fullName.trim())) {
            request.setAttribute("fullNameError", "Tên phải viết hoa chữ cái đầu mỗi từ (VD: Phan Thành Đạt)");
            hasError = true;
        }

        // Validate Email
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("emailError", "Email không được để trống");
            hasError = true;
        } else if (!isValidEmail(email.trim())) {
            request.setAttribute("emailError", "Email phải có dạng: ten@domain.com");
            hasError = true;
        }

        // Validate Mobile
        if (mobile == null || mobile.trim().isEmpty()) {
            request.setAttribute("mobileError", "Số điện thoại không được để trống");
            hasError = true;
        } else if (!isValidMobile(mobile.trim())) {
            request.setAttribute("mobileError", "Số điện thoại phải có 10 chữ số và bắt đầu bằng số 0");
            hasError = true;
        }

        // Nếu có lỗi, quay lại trang với thông báo lỗi
        if (hasError) {
            // Giữ lại dữ liệu đã nhập
            request.setAttribute("inputFullName", fullName);
            request.setAttribute("inputEmail", email);
            request.setAttribute("inputMobile", mobile);
            request.setAttribute("inputGender", gender);
            request.setAttribute("inputRole", role);
            request.setAttribute("inputStatus", status);

            // Mở modal add user
            request.setAttribute("showAddModal", true);

            // Gọi lại doGet để hiển thị trang
            doGet(request, response);
            return;
        }

        // Nếu không có lỗi, lưu user vào database
        try {
            elearning.entities.UserList newUser = new elearning.entities.UserList();
            newUser.setFullName(fullName.trim());
            newUser.setEmail(email.trim());
            newUser.setMobile(mobile.trim());
            newUser.setGender(Integer.parseInt(gender));
            newUser.setRole(role);
            newUser.setStatus(status);

            // Gọi DAO để lưu user
            boolean success = userlistDAO.addUser(newUser);

            if (success) {
                request.setAttribute("successMessage", "Thêm user thành công!");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi thêm user!");
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }

        // Redirect về trang userlist
        response.sendRedirect(request.getContextPath() + "/userlist");
    }
    
    private void handleEditUser(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String userIdStr = request.getParameter("userId");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        if (userIdStr != null && role != null && status != null) {
            try {
                int userId = Integer.parseInt(userIdStr);

                // Gọi DAO để update role và status
                boolean success = userlistDAO.updateUserRoleStatus(userId, role, status);

                if (success) {
                    request.setAttribute("successMessage", "Cập nhật user thành công!");
                } else {
                    request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật user!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "ID user không hợp lệ!");
            }
        }

        // Redirect về trang userlist
        response.sendRedirect(request.getContextPath() + "/userlist");
    }

    // Phương thức kiểm tra format tên
    private boolean isValidFullNameFormat(String name) {
        // Tách các từ bằng space
        String[] words = name.split("\\s+");

        for (String word : words) {
            if (word.length() == 0) continue;

            // Kiểm tra chữ cái đầu có viết hoa không
            char firstChar = word.charAt(0);
            if (!Character.isUpperCase(firstChar)) {
                return false;
            }

            // Kiểm tra các chữ cái sau có viết thường không
            for (int i = 1; i < word.length(); i++) {
                char c = word.charAt(i);
                if (Character.isLetter(c) && Character.isUpperCase(c)) {
                    return false;
                }
            }
        }
        return true;
    }

    // Phương thức kiểm tra email
    private boolean isValidEmail(String email) {
        if (!email.contains("@")) {
            return false;
        }

        int atIndex = email.indexOf("@");
        // @ không được ở đầu hoặc cuối
        if (atIndex == 0 || atIndex == email.length() - 1) {
            return false;
        }

        // Kiểm tra chỉ có 1 ký tự @
        if (email.indexOf("@", atIndex + 1) != -1) {
            return false;
        }

        // Kiểm tra có ít nhất 1 ký tự trước và sau @
        String beforeAt = email.substring(0, atIndex);
        String afterAt = email.substring(atIndex + 1);

        return beforeAt.length() > 0 && afterAt.length() > 0 && afterAt.contains(".");
    }

    // Phương thức kiểm tra số điện thoại
    private boolean isValidMobile(String mobile) {
        // Kiểm tra độ dài = 10
        if (mobile.length() != 10) {
            return false;
        }

        // Kiểm tra bắt đầu bằng số 0
        if (!mobile.startsWith("0")) {
            return false;
        }

        // Kiểm tra tất cả đều là số
        for (char c : mobile.toCharArray()) {
            if (!Character.isDigit(c)) {
                return false;
            }
        }

        return true;
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
