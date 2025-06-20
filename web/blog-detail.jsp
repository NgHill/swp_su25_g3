<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- Cấu hình trang JSP: sử dụng JSTL core và format taglib, charset UTF-8 -->

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Blog Detail</title>

        <!-- Nhúng Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />

        <!-- CSS tùy chỉnh cho giao diện blog -->
        <style>
            .sidebar-title {
                font-size: 1.5rem;
                font-weight: bold;
                margin-bottom: 1rem;
            }
            .contact-info {
                font-size: 0.9rem;
            }
            .post-detail h2 {
                font-weight: bold;
            }
            .post-detail p.meta {
                font-size: 0.9rem;
                color: #555;
            }
            .post-detail img {
                max-width: 100%;
                height: auto;
                margin: 15px 0;
                display: block;
            }
            .post-detail video {
                max-width: 100%;
                height: auto;
                margin: 15px 0;
                display: block;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                max-height: 500px;
            }
        </style>
    </head>

    <body>
        <div class="container mt-3">
            <!-- Nút quay lại trang trước -->
            <a href="javascript:history.back()" class="btn btn-dark mb-3">Back</a>

            <div class="row">
                <!-- Cột trái: Sidebar -->
                <div class="col-md-3">
                    <!-- Form tìm kiếm -->
                    <div class="sidebar-section mb-4">
                        <h5 class="sidebar-title">Search</h5>
                        <form method="get" action="blog">
                            <div class="input-group mb-3">
                                <input type="text" class="form-control" name="search" placeholder="Search..." />
                                <button class="btn btn-primary btn-sm" type="submit">Search</button>
                            </div>
                        </form>
                    </div>

                    <!-- Danh mục Category -->
                    <div class="sidebar-section mb-4">
                        <h5 class="sidebar-title">Category</h5>
                        <ul class="list-unstyled">
                            <!-- Liên kết để xem tất cả bài viết -->
                            <li><a href="blog?category=All" class="text-decoration-none">All</a></li>
                            <!-- Duyệt qua danh sách category và tạo liên kết -->
                            <c:forEach var="cate" items="${categories}">
                                <li><a href="blog?category=${cate}" class="text-decoration-none">${cate}</a></li>
                                </c:forEach>
                        </ul>
                    </div>

                    <!-- Bài viết mới nhất -->
                    <div class="sidebar-section mb-4">
                        <h5 class="sidebar-title">Latest Posts</h5>
                        <c:forEach var="latest" items="${latestPosts}">
                            <div class="mb-2">
                                <p class="latest-post-title">
                                    <a href="blog-detail?id=${latest.id}">
                                        ${latest.title}
                                    </a>
                                </p>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Thông tin liên hệ -->
                    <div class="sidebar-section">
                        <h5 class="sidebar-title">Contacts</h5>
                        <p class="contact-info">Abcxyz@gmail.com</p>
                        <p class="contact-info">Hotline: 0985657246</p>
                    </div>
                </div>

                <!-- Cột phải: Nội dung chi tiết bài viết -->
                <div class="col-md-9 post-detail">
                    <!-- Danh mục bài viết -->
                    <p class="text-uppercase text-muted">${post.category}</p>

                    <!-- Tiêu đề bài viết -->
                    <h2>${post.title}</h2>

                    <!-- Thông tin cập nhật -->
                    <p class="meta">
                        Updated by ${post.getAuthorFunc().getFullName()} on 
                        <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy" />
                    </p>

                    <hr>

                    <!-- Nội dung bài viết (có thể chứa HTML, ảnh, video) -->
                    <p>${post.content}</p>
                </div>
            </div>
        </div>

        <!-- Nhúng Bootstrap JS bundle (gồm Popper) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
