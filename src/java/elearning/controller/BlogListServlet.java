/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package elearning.controller;

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
import java.util.stream.Collectors;

/**
 *
 * @author admin
 */
public class BlogListServlet extends HttpServlet {

    private final PostBasicDAO postDAO = new PostBasicDAO();
    private static final int PAGE_SIZE = 6;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Lấy các tham số từ URL
            String category = req.getParameter("category"); // lọc theo danh mục
            String search = req.getParameter("search");     // từ khóa tìm kiếm
            String pageRaw = req.getParameter("page");      // phân trang

            // Lấy tất cả bài viết và danh sách danh mục từ cơ sở dữ liệu
            List<Post> allPosts = postDAO.getAll();
            List<String> categories = postDAO.getAllCategory();

            // Loại bỏ các danh mục bị trùng
            categories = categories.stream().distinct().collect(Collectors.toList());
            req.setAttribute("categories", categories);

            // Lấy 5 bài viết mới nhất (có ID lớn nhất)
            List<Post> latestPosts = allPosts.stream()
                    .sorted(Comparator.comparing(Post::getId).reversed())
                    .limit(5)
                    .collect(Collectors.toList());
            req.setAttribute("latestPosts", latestPosts);

            // Tạm thời gán danh sách tất cả bài viết vào filteredPosts để lọc
            List<Post> filteredPosts = allPosts;

            // Nếu có tìm kiếm (search không null và không rỗng)
            if (search != null && !search.trim().isEmpty()) {
                // Lọc các bài viết có tiêu đề chứa từ khóa (không phân biệt hoa thường)
                filteredPosts = filteredPosts.stream()
                        .filter(p -> p.getTitle().toLowerCase().contains(search.toLowerCase()))
                        .collect(Collectors.toList());

                // Gửi kết quả lọc và từ khóa tìm kiếm sang JSP
                req.setAttribute("search", search);
                req.setAttribute("posts", filteredPosts);
                req.getRequestDispatcher("blog_list.jsp").forward(req, resp);
                return;
            }

            // Nếu có lọc theo danh mục cụ thể (không phải "All")
            if (category != null && !category.equalsIgnoreCase("All")) {
                // Lọc bài viết theo danh mục
                filteredPosts = filteredPosts.stream()
                        .filter(p -> p.getCategory().equalsIgnoreCase(category))
                        .collect(Collectors.toList());

                // Gửi danh mục đã chọn và bài viết lọc sang JSP
                req.setAttribute("selectedCategory", category);
                req.setAttribute("posts", filteredPosts);
                req.getRequestDispatcher("blog_list.jsp").forward(req, resp);
                return;
            }

            // ========================= PHÂN TRANG =========================
            int page = 1; // Mặc định là trang đầu tiên
            try {
                page = Integer.parseInt(pageRaw); // Parse trang hiện tại từ request
            } catch (Exception e) {
                // Bỏ qua nếu không parse được (giữ mặc định = 1)
            }

            // Tính tổng số trang = tổng bài viết / số bài trên mỗi trang
            int totalPage = (int) Math.ceil((double) filteredPosts.size() / PAGE_SIZE);

            // Tính vị trí bắt đầu và kết thúc của danh sách con
            int start = (page - 1) * PAGE_SIZE;
            int end = Math.min(start + PAGE_SIZE, filteredPosts.size());

            // Cắt danh sách bài viết cho trang hiện tại
            List<Post> pagePosts = filteredPosts.subList(start, end);

            // Gửi thông tin trang và danh sách bài viết sang JSP
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPage", totalPage);
            req.setAttribute("posts", pagePosts);

            // Chuyển tiếp sang blog_list.jsp để hiển thị kết quả
            req.getRequestDispatcher("blog_list.jsp").forward(req, resp);

        } catch (SQLException e) {
            // Nếu có lỗi database, ném lỗi lên servlet container để xử lý
            throw new ServletException("Database error", e);
        }
    }

}
