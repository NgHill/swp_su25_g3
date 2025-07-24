package elearning.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

@WebServlet(name="Avatar", urlPatterns={"/avatar/*"})
public class AvatarServlet extends HttpServlet {
    
    private static final String UPLOAD_BASE_PATH = System.getProperty("user.home") + File.separator + "uploads";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo(); // VD: /avatars/2024/07/filename.jpg
        if (pathInfo == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        File file = new File(UPLOAD_BASE_PATH + pathInfo);
        
        if (file.exists() && file.isFile()) {
            // Set content type
            String contentType = getServletContext().getMimeType(file.getName());
            if (contentType == null) {
                contentType = "application/octet-stream";
            }
            response.setContentType(contentType);
            
            // Set cache headers
            response.setHeader("Cache-Control", "public, max-age=31536000"); // 1 year
            
            // Copy file to response
            Files.copy(file.toPath(), response.getOutputStream());
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}