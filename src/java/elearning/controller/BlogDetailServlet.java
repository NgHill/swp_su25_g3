package elearning.controller;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import elearning.BasicDAO.PostBasicDAO;
import elearning.entities.Post;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.Comparator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

/**
 *
 * @author admin
 */
public class BlogDetailServlet extends HttpServlet {

    private final PostBasicDAO postDAO = new PostBasicDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {
            // Lấy tham số "id" từ request và chuyển đổi thành kiểu int
            int id = Integer.parseInt(req.getParameter("id"));

            // Truy xuất bài viết cụ thể theo ID từ database
            Post post = postDAO.getById(id);

            // Đưa bài viết này vào attribute để hiển thị trên JSP
            req.setAttribute("post", post);

            // Lấy toàn bộ bài viết từ cơ sở dữ liệu
            List<Post> allPosts = postDAO.getAll();

            // Lấy toàn bộ danh mục (category) bài viết
            List<String> categories = postDAO.getAllCategory();

            // Loại bỏ các danh mục trùng lặp (distinct)
            categories = categories.stream().distinct().collect(Collectors.toList());

            // Gán danh sách danh mục vào attribute để hiển thị trên sidebar
            req.setAttribute("categories", categories);

            // Lọc ra 5 bài viết mới nhất theo ID giảm dần (bài mới có ID lớn hơn)
            List<Post> latestPosts = allPosts.stream()
                    .sorted(Comparator.comparing(Post::getId).reversed())
                    .limit(5)
                    .collect(Collectors.toList());

            // Gán danh sách bài viết mới nhất vào attribute
            req.setAttribute("latestPosts", latestPosts);

        } catch (SQLException ex) {
            // Ghi log nếu có lỗi SQL xảy ra
            Logger.getLogger(BlogDetailServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Chuyển tiếp request đến trang JSP để hiển thị chi tiết bài viết
        req.getRequestDispatcher("blog-detail.jsp").forward(req, resp);
    }

}
