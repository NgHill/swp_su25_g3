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

        // Nếu user không chọn gì → gán mặc định để không gây null pointer
        genderFilter = (genderFilter == null || genderFilter.equals("A")) ? "" : genderFilter;
        roleFilter = (roleFilter == null || roleFilter.equals("A")) ? "" : roleFilter;
        statusFilter = (statusFilter == null || statusFilter.equals("A")) ? "" : statusFilter;
        search = (search == null) ? "" : search;

        // Gọi DAO để lấy dữ liệu
        UserListDAO userListDAO = new UserListDAO();
        List<elearning.entities.UserList> userLists = userListDAO.searchAndFilterUsers(
            search.trim(),
            genderFilter.trim(),
            roleFilter.trim(),
            statusFilter.trim()
        );

        // Gửi dữ liệu về lại JSP
        request.setAttribute("userLists", userLists);
        request.setAttribute("search", search);
        request.setAttribute("genderFilter", request.getParameter("genderFilter"));
        request.setAttribute("roleFilter", request.getParameter("roleFilter"));
        request.setAttribute("statusFilter", request.getParameter("statusFilter"));

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
        processRequest(request, response);
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
