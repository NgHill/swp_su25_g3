/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package elearning.controller;

import elearning.BasicDAO.HomeDAO;
import elearning.BasicDAO.ProfileDAO;
import elearning.BasicDAO.UserBasicDAO;
import elearning.entities.HomeFeatureSubject;
import elearning.entities.HomePost;
import elearning.entities.HomeSlider;
import elearning.entities.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Lenovo
 */
@WebServlet(name="HomeServlet", urlPatterns={"/home"})
public class HomeServlet extends HttpServlet {
   
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
            out.println("<title>Servlet HomeServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet HomeServlet at " + request.getContextPath () + "</h1>");
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
    
    private final HomeDAO homeDAO = new HomeDAO();
    private final UserBasicDAO userDAO = new UserBasicDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Cập nhật thông tin user trong session để có avatar mới nhất
        HttpSession session = request.getSession();
        User userAuth = (User) session.getAttribute("userAuth");
        
        // Nếu user đã login, cập nhật thông tin mới nhất từ database
        if (userAuth != null) {
            try {
                User updatedUser = userDAO.getById(userAuth.getId());
                if (updatedUser != null) {
                    session.setAttribute("userAuth", updatedUser);
                    userAuth = updatedUser;
                }
            } catch (Exception e) {
                e.printStackTrace();
                // Nếu có lỗi, vẫn sử dụng thông tin cũ
            }
        }
        
        List<HomePost> hotPosts = homeDAO.getHotPosts();
        List<HomePost> latestPosts = homeDAO.getLatestPosts(); // 👈 thêm dòng này
        List<HomeSlider> sliders = homeDAO.getHomepageSliders();
        List<HomeFeatureSubject> featuredSubjects = homeDAO.getFeaturedSubjects();

        request.setAttribute("hotPosts", hotPosts);
        request.setAttribute("latestPosts", latestPosts); // 👈 thêm dòng này
        request.setAttribute("sliders", sliders);
        request.setAttribute("featureSubjects", featuredSubjects);
        
        request.getRequestDispatcher("home.jsp").forward(request, response);
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
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Handles homepage loading";
    }// </editor-fold>

}
