/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package elearning.controller;

import elearning.BasicDAO.SubjectListDAO;
import elearning.entities.SubjectPackage;
import elearning.entities.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.List;

/**
 *
 * @author admin
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50)
public class AddNewSubject extends HttpServlet {
     private final SubjectListDAO dao = new SubjectListDAO();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
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
            out.println("<title>Servlet AddNewSubject</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddNewSubject at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<String> categoryList = dao.getAllCategory();
        request.setAttribute("categoryList", categoryList);
        request.getRequestDispatcher("addnew_subject.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private String uploadPath;

    @Override
    public void init() throws ServletException {
        uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
         // Lấy các giá trị từ form
        String title = request.getParameter("title");
        String category = request.getParameter("category");
        String briefInfo = request.getParameter("briefInfo");
        String tagline = request.getParameter("tagline");
        String description = request.getParameter("description");
        String status = request.getParameter("status");

        String lowestPriceStr = request.getParameter("lowestPrice");
        String originalPriceStr = request.getParameter("originalPrice");
        String salePriceStr = request.getParameter("salePrice");

        // Lấy Owner từ session
        HttpSession session = request.getSession();
        User owner = (User) session.getAttribute("userAuth");
        
         // Đọc các giá trị số, chuyển về double
        double lowestPrice = lowestPriceStr != null && !lowestPriceStr.isEmpty() ? formatDouble(lowestPriceStr) : 0;
        double originalPrice = formatDouble(originalPriceStr);
        double salePrice = salePriceStr != null && !salePriceStr.isEmpty() ? formatDouble(salePriceStr) : 0;

        
        
        // Xử lý file upload
        Part filePart = request.getPart("thumbnail");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String filePath = null;

        if (!fileName.isEmpty()) {
            filePath = "uploads" + File.separator + System.currentTimeMillis() + "_" + fileName;
            filePart.write(uploadPath + File.separator + System.currentTimeMillis() + "_" + fileName);
        }
        // Tạo đối tượng Subject từ dữ liệu form
        SubjectPackage subject = new SubjectPackage();
        subject.setTitle(title);
        subject.setBriefInfo(briefInfo);
        subject.setDescription(description);
        subject.setTagLine(tagline);
        subject.setThumbnail(fileName);
        subject.setLowestPrice(lowestPrice);
        subject.setOriginalPrice(originalPrice);
        subject.setSalePrice(salePrice);
        subject.setStatus(status);
        subject.setCategory(category);
        subject.setOwnerId(owner.getId());
        
        // Gọi DAO để thêm dữ liệu vào database
        SubjectListDAO dao = new SubjectListDAO();
        try {
            dao.addSubject(subject);//add to DB
            response.sendRedirect("subject-list2");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
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
    
    private Double formatDouble (String num) {
        return Double.valueOf(num.replace(".", ""));
    }

}
