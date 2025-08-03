/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package elearning.controller;

import elearning.BasicDAO.ProfileDAO;
import elearning.BasicDAO.UserListDAO;
import elearning.anotation.AccessRoles;
import elearning.entities.Profile;
import java.io.IOException;
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
@WebServlet(name="UserDetails", urlPatterns={"/userdetails"})
public class UserDetails extends HttpServlet {

    private final UserListDAO userlistDAO = new UserListDAO();
    private final ProfileDAO profileDAO = new ProfileDAO();
    
    @Override
    @AccessRoles(roles = "admin")
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        // Lấy ID từ parameter
        String userIdStr = request.getParameter("id");
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            // Nếu không có ID, redirect về trang user list
            response.sendRedirect(request.getContextPath() + "/userlist");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            
            // Lấy thông tin user từ database
            elearning.entities.UserList user = userlistDAO.getUserById(userId);
            
            if (user == null) {
                // Nếu không tìm thấy user, redirect về trang user list với thông báo lỗi
                request.getSession().setAttribute("errorMessage", "Không tìm thấy người dùng với ID: " + userId);
                response.sendRedirect(request.getContextPath() + "/userlist");
                return;
            }
            
            // Lấy thông tin profile để có avatar
            List<Profile> profiles = profileDAO.getProfileById(userId);
            if (!profiles.isEmpty()) {
                request.setAttribute("profile", profiles.get(0));
            }
            
            // Gửi dữ liệu user về JSP
            request.setAttribute("user", user);
            
            // Kiểm tra và hiển thị thông báo từ session
            String successMessage = (String) request.getSession().getAttribute("successMessage");
            String errorMessage = (String) request.getSession().getAttribute("errorMessage");

            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                request.getSession().removeAttribute("successMessage");
            }

            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                request.getSession().removeAttribute("errorMessage");
            }
            
            // Forward đến trang hiển thị chi tiết
            request.getRequestDispatcher("userDetails.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // Nếu ID không hợp lệ, redirect về trang user list
            request.getSession().setAttribute("errorMessage", "ID người dùng không hợp lệ: " + userIdStr);
            response.sendRedirect(request.getContextPath() + "/userlist");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/userlist");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            boolean success = false;

            if ("updateRole".equals(action)) {
                String newRole = request.getParameter("role");
                if (newRole != null && !newRole.trim().isEmpty()) {
                    // Lấy status hiện tại để không bị thay đổi
                    elearning.entities.UserList currentUser = userlistDAO.getUserById(userId);
                    if (currentUser != null) {
                        success = userlistDAO.updateUserRoleStatus(userId, newRole, currentUser.getStatus());
                    }
                }
            } else if ("updateStatus".equals(action)) {
                String newStatus = request.getParameter("status");
                if (newStatus != null && !newStatus.trim().isEmpty()) {
                    // Lấy role hiện tại để không bị thay đổi
                    elearning.entities.UserList currentUser = userlistDAO.getUserById(userId);
                    if (currentUser != null) {
                        success = userlistDAO.updateUserRoleStatus(userId, currentUser.getRole(), newStatus);
                    }
                }
            }

            if (success) {
                request.getSession().setAttribute("successMessage", "Cập nhật thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật!");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID người dùng không hợp lệ!");
        }

        // Redirect về trang user details
        response.sendRedirect(request.getContextPath() + "/userdetails?id=" + userIdStr);
    }

    @Override
    public String getServletInfo() {
        return "User Details Servlet";
    }
}