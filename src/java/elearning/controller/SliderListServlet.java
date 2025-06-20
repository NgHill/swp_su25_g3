/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package elearning.controller;

import elearning.BasicDAO.SliderBasicDAO;
import elearning.entities.Slider;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author admin
 */
public class SliderListServlet extends HttpServlet {

    private SliderBasicDAO sliderDAO;

    @Override
    public void init() throws ServletException {
        sliderDAO = new SliderBasicDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy giá trị từ parameter trên URL (thanh địa chỉ)
            String search = request.getParameter("search");  // Lấy từ khóa tìm kiếm
            String status = request.getParameter("status");  // Lấy trạng thái ( Hide, Show )
            String pageStr = request.getParameter("page");   // Lấy số trang hiện tại (dưới dạng chuỗi)

            int page = 1;     // Mặc định trang hiện tại là 1
            int pageSize = 5; // Số mục hiển thị trên mỗi trang là 5

            // Kiểm tra nếu có giá trị page truyền vào
            if (pageStr != null) {
                try {
                    // Chuyển giá trị page từ chuỗi sang số nguyên
                    page = Integer.parseInt(pageStr);
                } catch (NumberFormatException e) {
                    // Nếu chuyển đổi thất bại (ví dụ: không phải số), giữ giá trị mặc định là 1
                    page = 1;
                }
            }

            // Lấy tất cả slider đã lọc
            List<Slider> filteredSliders = sliderDAO.getFiltered(search, status);

            // Tính phân trang
            int totalItems = filteredSliders.size();
            int totalPages = (int) Math.ceil((double) totalItems / pageSize);
            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, totalItems);

            // Cắt danh sách cho trang hiện tại
            List<Slider> pageSliders = filteredSliders.subList(start, end);

            // Gửi dữ liệu về JSP
            request.setAttribute("sliderList", pageSliders);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);
            request.setAttribute("search", search);
            request.setAttribute("status", status);
            request.setAttribute("totalFiltered", totalItems);

            request.getRequestDispatcher("slider-list.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error.");
        }
    }

}
