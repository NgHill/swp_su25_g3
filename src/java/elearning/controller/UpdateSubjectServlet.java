/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package elearning.controller;

import elearning.BasicDAO.SubjectListDAO;
import elearning.entities.SubjectList;
import elearning.entities.SubjectPackage;
import elearning.entities.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet("/edit-subject")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class UpdateSubjectServlet extends HttpServlet {

    private final SubjectListDAO subjectListDAO = new SubjectListDAO();
   

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int subjectId = Integer.parseInt(request.getParameter("id"));
        SubjectPackage subject = subjectListDAO.getSubjectById(subjectId);
        List<String> categoryList = subjectListDAO.getAllCategory();
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("subject", subject);
        request.getRequestDispatcher("subject_detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

         // Lấy các giá trị từ form
        String id = request.getParameter("id");
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

        // Xử lý upload ảnh nếu có
        Part filePart = request.getPart("thumbnail");
        String fileName = filePart.getSubmittedFileName();
        String thumbnailUrl = null;

        if (fileName != null && !fileName.isEmpty()) {
            String uploadPath = getServletContext().getRealPath("/") + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            filePart.write(uploadPath + File.separator + fileName);
            thumbnailUrl = "uploads/" + fileName;
        } else {
            // Nếu không upload lại ảnh, giữ nguyên ảnh cũ
            thumbnailUrl = request.getParameter("existingThumbnail");
        }

         // Tạo đối tượng Subject từ dữ liệu form
        SubjectPackage subject = new SubjectPackage();
        subject.setId(Integer.valueOf(id));
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

        subjectListDAO.updateSubject2(subject);
        response.sendRedirect("subject-list2");
    }
    
     private Double formatDouble (String num) {
        return Double.valueOf(num.replace(".", ""));
    }
}
