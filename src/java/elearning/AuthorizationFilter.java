/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Filter.java to edit this template
 */
package elearning;

import elearning.anotation.AccessRoles;
import elearning.entities.User;
import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 *
 * @author admin
 */
//@WebFilter("/*") // Áp dụng cho tất cả các Servlet
public class AuthorizationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String servletPath = req.getServletPath();
        System.out.println(servletPath);

        try {
            //Lấy Servlet đang xử lý request
            Object servletInstance = req.getServletContext().getAttribute(servletPath);
            if (servletInstance == null) {
                chain.doFilter(request, response); // Không tìm thấy Servlet -> Tiếp tục bình thường
                return;
            }

            //Lấy phương thức đang được gọi (doGet, doPost, ...)
            String methodName = req.getMethod().toLowerCase().equals("get") ? "doGet" : "doPost";
            Method method = servletInstance.getClass().getMethod(methodName, HttpServletRequest.class, HttpServletResponse.class);

            //Kiểm tra nếu phương thức có annotation @AccessRoles
            if (method.isAnnotationPresent(AccessRoles.class)) {
                AccessRoles rolesAllowed = method.getAnnotation(AccessRoles.class);
                List<String> requiredRoles = Arrays.asList(rolesAllowed.roles());

                //Lấy roles của user từ session
                User userAuth = (User) req.getSession().getAttribute("userAuth");
                List<String> userRoles = new ArrayList<>();
                if (userAuth != null) {
                    userRoles.add(userAuth.getRole());
                }

                //Kiểm tra quyền
                if (userAuth == null || userRoles.stream().noneMatch(requiredRoles::contains)) {
                    if (userAuth == null) {
                        res.sendRedirect("/EducationPlatform/login"); // Redirect nếu không có quyền
                    } else {
                        res.sendRedirect("/EducationPlatform/error");
                    }
                    return;
                }
            }
        } catch (NoSuchMethodException ignored) {
            ignored.printStackTrace();
        }

        //Tiếp tục nếu hợp lệ
        chain.doFilter(request, response);
    }
}
