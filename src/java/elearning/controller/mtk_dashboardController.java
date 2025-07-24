package elearning.controller;

import elearning.BasicDAO.mtk_dashboardDAO;
import elearning.entities.Post;
import elearning.entities.Slider;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/mtk-dashboard")
public class mtk_dashboardController extends HttpServlet {
    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int postPage = getPageParam(request, "postPage");
        int sliderPage = getPageParam(request, "sliderPage");

        mtk_dashboardDAO dao = new mtk_dashboardDAO();
        List<Post> postList = dao.getPagedPosts(postPage, PAGE_SIZE);
        List<Slider> sliderList = dao.getPagedSliders(sliderPage, PAGE_SIZE);

        int postTotal = dao.countPosts();
        int sliderTotal = dao.countSliders();

        request.setAttribute("postList", postList);
        request.setAttribute("postPage", postPage);
        request.setAttribute("postTotalPages", getTotalPages(postTotal, PAGE_SIZE));

        request.setAttribute("sliderList", sliderList);
        request.setAttribute("sliderPage", sliderPage);
        request.setAttribute("sliderTotalPages", getTotalPages(sliderTotal, PAGE_SIZE));

        request.getRequestDispatcher("mtk_dashboard.jsp").forward(request, response);
    }

    private int getPageParam(HttpServletRequest req, String name) {
        try {
            return Integer.parseInt(req.getParameter(name));
        } catch (Exception e) {
            return 1;
        }
    }

    private int getTotalPages(int totalItems, int pageSize) {
        return (int) Math.ceil((double) totalItems / pageSize);
    }
}