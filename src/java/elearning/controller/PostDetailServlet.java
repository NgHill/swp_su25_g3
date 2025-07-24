package elearning.controller;

import elearning.BasicDAO.PostBasicDAO;
import elearning.entities.Post;
import elearning.entities.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.sql.Date;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.InputStream;
import java.nio.file.Files;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet này xử lý cả GET và POST cho trang chi tiết bài viết. GET: hiển thị
 * form. POST: xử lý lưu bài viết mới vào cơ sở dữ liệu.
 */
@MultipartConfig // Cho phép xử lý multipart/form-data (upload file)
public class PostDetailServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads"; // Tên thư mục để lưu ảnh thumbnail

    /**
     * Xử lý method GET: tải danh sách từ DB và hiển thị form.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy đối tượng User từ session thông qua attribute tên "userAuth"
        User u = (User) request.getSession().getAttribute("userAuth");
        // Kiểm tra nếu người dùng chưa đăng nhập (u == null)
        if (u == null) {
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
        
        // Khởi tạo đối tượng DAO để làm việc với cơ sở dữ liệu
        PostBasicDAO dao = new PostBasicDAO();
        List<String> categories = new ArrayList<>();

        try {
            // Lấy danh sách các category từ DB
            categories = dao.getAllCategory();
        } catch (SQLException ex) {
            Logger.getLogger(PostDetailServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Gửi categories tới trang JSP để hiển thị trong form
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("post_detail.jsp").forward(request, response);
    }

    /**
     * Xử lý method POST: nhận dữ liệu từ form, upload ảnh và lưu bài viết mới.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User u = (User) req.getSession().getAttribute("userAuth");
        if (u == null) {
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }

        req.setCharacterEncoding("UTF-8"); // Đảm bảo dữ liệu không bị lỗi tiếng Việt

        // Tạo đường dẫn tới thư mục uploads
        String appPath = req.getServletContext().getRealPath("");
        String uploadPath = appPath + File.separator + UPLOAD_DIR;

        // Nếu thư mục uploads chưa tồn tại thì tạo mới
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Lấy file thumbnail từ form
        Part filePart = req.getPart("thumbnail");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String savedFileName = System.currentTimeMillis() + "_" + fileName; // Đổi tên file để tránh trùng

        // Lưu file vào thư mục
        File file = new File(uploadPath + File.separator + savedFileName);
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, file.toPath());
        }

        // Lấy dữ liệu từ các field còn lại
        String title = req.getParameter("title");
        String category = req.getParameter("category");
//        String author = req.getParameter("author");
        String content = req.getParameter("content");
        String description = req.getParameter("briefInfo");
        String status = req.getParameter("status");
        String date = req.getParameter("date");

        // Ép kiểu dữ liệu phù hợp
//        int authorId = Integer.parseInt(author); // Giả định đây là ID tác giả
        Date createdAt = Date.valueOf(date);

        // Tạo đối tượng Post để lưu vào DB
        Post post = new Post();
        post.setTitle(title);
        post.setCategory(category);
        post.setAuthorId(u.getId());
        post.setContent(content);
        post.setDescription(description);
        post.setStatus(status);
        post.setCreatedAt(createdAt);
        post.setThumbnail(savedFileName); // Lưu tên file ảnh đã upload

        // Lưu bài viết vào DB
        new PostBasicDAO().insert(post);

        // Sau khi lưu xong thì redirect về danh sách bài viết
        resp.sendRedirect("mtk_dashboard");
    }

    /**
     * Hàm phụ trợ (không dùng trong code hiện tại): lấy tên file từ header của
     * file upload.
     */
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) {
            return null;
        }
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                return new File(token.split("=")[1].replace("\"", "")).getName();
            }
        }
        return null;
    }

    /**
     * Mô tả ngắn gọn về servlet.
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
