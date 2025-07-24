package elearning.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

@WebServlet("/quiz-images/*")
public class QuizImageServlet extends HttpServlet {
    
    private static final String UPLOAD_DIR = "C:\\Users\\" + System.getProperty("user.name") + "\\uploads\\quiz-images\\";
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
        
        String filename = request.getPathInfo().substring(1); // Bỏ dấu /
        String imagePath = UPLOAD_DIR + filename;
        
        File imageFile = new File(imagePath);
        if (imageFile.exists()) {
            String contentType = getServletContext().getMimeType(filename);
            if (contentType == null) {
                contentType = "image/jpeg";
            }
            response.setContentType(contentType);
            Files.copy(imageFile.toPath(), response.getOutputStream());
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}