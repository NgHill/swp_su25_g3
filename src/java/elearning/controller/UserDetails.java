/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package elearning.controller;

import elearning.BasicDAO.UserListDAO;
import elearning.anotation.AccessRoles;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Lenovo
 */
@WebServlet(name="UserDetails", urlPatterns={"/userdetails"})
public class UserDetails extends HttpServlet {

    private final UserListDAO userlistDAO = new UserListDAO();
    
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
            
            // Gửi dữ liệu user về JSP
            request.setAttribute("user", user);
            
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
        // Redirect POST requests to GET
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "User Details Servlet";
    }
}