<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Blog List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .sidebar-title {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 1rem;
        }
        .blog-image {
            width: 100px;
            height: 80px;
            object-fit: cover;
        }
        .post-item {
            border: 1px solid #ccc;
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: 6px;
            background-color: #fff;
        }
        .latest-post-title {
            font-size: 0.9rem;
            font-weight: bold;
        }
        .latest-post-desc {
            font-size: 0.85rem;
        }
        .pagination a {
            cursor: pointer;
        }
        .contact-info {
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

<div class="container mt-4">
    <a href="javascript:history.back()" class="btn btn-dark mb-3">Back</a>
    <h1 class="fw-bold">Blog list</h1>

    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-3">

            <!-- Search -->
            <div class="sidebar-section mb-4">
                <h5 class="sidebar-title">Search</h5>
                <form method="get" action="blog">
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" name="search" 
                               value="${search != null ? search : ''}" placeholder="Search..." />
                        <button class="btn btn-primary btn-sm" type="submit">Search</button>
                    </div>
                </form>
            </div>

            <!-- Categories -->
            <div class="sidebar-section mb-4">
                <h5 class="sidebar-title">Category</h5>
                <ul class="list-unstyled">
                    <li class="${selectedCategory == 'All' ? 'fw-bold' : ''}">
                        <a href="blog?category=All" 
                           class="text-decoration-none ${selectedCategory == 'All' ? 'text-primary' : ''}">All</a>
                    </li>
                    <c:forEach var="cate" items="${categories}">
                        <li class="${cate == selectedCategory ? 'fw-bold' : ''}">
                            <a href="blog?category=${cate}" 
                               class="text-decoration-none ${cate == selectedCategory ? 'text-primary' : ''}">${cate}</a>
                        </li>
                    </c:forEach>
                </ul>
            </div>

            <!-- Latest Posts -->
            <div class="sidebar-section mb-4">
                <h5 class="sidebar-title">Latest Posts</h5>
                <c:forEach var="latest" items="${latestPosts}">
                    <div class="mb-2">
                        <p class="latest-post-title"><a href="blog-detail?id=${latest.id}">${latest.title}</a></p>
                    </div>
                </c:forEach>
            </div>

            <!-- Contacts -->
            <div class="sidebar-section">
                <h5 class="sidebar-title">Contacts</h5>
                <p class="contact-info">Abcxyz@gmail.com</p>
                <p class="contact-info">Hotline: 0985657246</p>
            </div>
        </div>

        <!-- Blog Posts -->
        <div class="col-md-9">
            <c:forEach var="post" items="${posts}">
                <div class="post-item d-flex">
                    <img src="uploads/${post.thumbnail}" class="blog-image me-3" alt="Post image" />
                    <div>
                        <h5>${post.title}</h5>
                        <p class="mb-1">
                            ${post.category} - 
                            <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy" /> by ${post.getAuthorFunc().getFullName()}
                        </p>
                        <a href="blog-detail?id=${post.id}">Link - Abcxyz.com</a>
                        
                    </div>
                </div>
            </c:forEach>

            <!-- Pagination -->
            <c:if test="${empty search and (empty selectedCategory || selectedCategory == 'All')}">
                <nav>
                    <ul class="pagination justify-content-center">
                        <c:forEach begin="1" end="${totalPage}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="blog?page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
