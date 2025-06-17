/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package elearning.controller;

import elearning.BasicDAO.PracticeListDAO;
import elearning.entities.PracticeList;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Lenovo
 */
@WebServlet(name="practiceList", urlPatterns={"/practicelist"})
public class practiceList extends HttpServlet {
   
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
            out.println("<title>Servlet practiceList</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet practiceList at " + request.getContextPath () + "</h1>");
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
    private final PracticeListDAO practiceListDAO = new PracticeListDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        int userId = 2; // lấy từ session thực tế
        String scoreFilter = request.getParameter("scoreFilter");
        String search = request.getParameter("search");

        List<PracticeList> practiceLists = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            String keyword = search.trim().toLowerCase();

            if (scoreFilter == null || scoreFilter.isEmpty() || "A".equals(scoreFilter)) {
                // Có search nhưng không filter điểm, gọi trực tiếp DAO tìm theo userId và title
                practiceLists = practiceListDAO.getPracticeListBySearch(userId, keyword);
            } else {
                // Có search và filter điểm, gọi DAO lấy danh sách đã filter điểm
                List<PracticeList> rawList = practiceListDAO.getPracticeListFiltered(userId, scoreFilter);
                List<PracticeList> filteredList = new ArrayList<>();

                // Lọc danh sách theo title trong Java
                for (PracticeList pl : rawList) {
                    if (pl.getQuizTitle().toLowerCase().contains(keyword)) {
                        filteredList.add(pl);
                    }
                }
                practiceLists = filteredList;
            }
        } else {
            // Không có search, chỉ có filter điểm hoặc không
            if (scoreFilter == null || scoreFilter.isEmpty() || "A".equals(scoreFilter)) {
                practiceLists = practiceListDAO.getPracticeListByUserId(userId);
            } else {
                practiceLists = practiceListDAO.getPracticeListFiltered(userId, scoreFilter);
            }
        }
        
        request.setAttribute("userId", userId);
        request.setAttribute("practiceLists", practiceLists);
        request.setAttribute("scoreFilter", scoreFilter);

        request.getRequestDispatcher("practiceList.jsp").forward(request, response);
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
