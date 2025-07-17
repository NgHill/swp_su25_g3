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
