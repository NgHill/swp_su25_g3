/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package elearning.controller;

import elearning.BasicDAO.SubjectListDAO;
import elearning.entities.SubjectList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;

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
        SubjectList subject = subjectListDAO.getSubjectById(subjectId);
        request.setAttribute("subject", subject);
        request.getRequestDispatcher("subject_detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        int numberOfLesson = Integer.parseInt(request.getParameter("numberOfLesson"));
        String owner = request.getParameter("owner");
        String status = request.getParameter("display");
        boolean featured = request.getParameter("featured") != null;
        String description = request.getParameter("description");

        // Xử lý upload ảnh nếu có
        Part filePart = request.getPart("thumbnail");
        String fileName = filePart.getSubmittedFileName();
        String thumbnailUrl = null;

        if (fileName != null && !fileName.isEmpty()) {
            String uploadPath = getServletContext().getRealPath("/") + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            filePart.write(uploadPath + File.separator + fileName);
            thumbnailUrl = "uploads/" + fileName;
        } else {
            // Nếu không upload lại ảnh, giữ nguyên ảnh cũ
            thumbnailUrl = request.getParameter("existingThumbnail");
        }

        SubjectList updatedSubject = SubjectList.builder()
                .id(id)
                .name(name)
                .category(category)
                .lessons(numberOfLesson)
                .owner(owner)
                .status(status)
                .featured(featured)
                .description(description)
                .thumbnailUrl(thumbnailUrl)
                .build();

        subjectListDAO.updateSubject2(updatedSubject);
        response.sendRedirect("subject-list2");
    }
}
