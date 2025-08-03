<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="elearning.entities.Post"%>
<%@page import="elearning.entities.Slider"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Dashboard</title>
        <style>
            * {
                box-sizing: border-box;
            }
            body {
                font-family: 'Segoe UI', sans-serif;
                margin: 0;
                background-color: #f0f2f5;
            }

            .sidebar {
                width: 240px;
                height: 100vh;
                position: fixed;
                background: #243447;
                color: #fff;
                padding: 25px 20px;
                display: flex;
                flex-direction: column;
                box-shadow: 2px 0 10px rgba(0,0,0,0.05);
            }

            .sidebar h2 {
                font-size: 22px;
                color: #ffffff;
                margin-bottom: 40px;
                font-weight: bold;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .sidebar a {
                text-decoration: none;
                color: #ffffff;
                padding: 12px 18px;
                margin-bottom: 12px;
                border-radius: 6px;
                transition: all 0.3s ease;
                font-size: 15px;
                display: block;
            }

            .sidebar a:hover {
                background-color: #375a7f;
            }

            .content {
                margin-left: 260px;
                padding: 30px;
            }

            h2 {
                color: #333;
                margin-bottom: 15px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05);
                border-radius: 6px;
                overflow: hidden;
            }

            th, td {
                padding: 14px 12px;
                border-bottom: 1px solid #eee;
                text-align: left;
            }

            th {
                background-color: #007bff;
                color: white;
                font-weight: 600;
            }

            tr:hover {
                background-color: #f5f5f5;
            }

            img {
                max-width: 80px;
                height: auto;
                border-radius: 4px;
            }

            .pagination-wrapper {
                display: flex;
                justify-content: center;
                margin: 20px 0;
                gap: 5px;
            }

            .pagination-wrapper form {
                display: inline;
            }

            .pagination-wrapper button {
                padding: 6px 12px;
                border: 1px solid #007bff;
                background-color: white;
                color: #007bff;
                border-radius: 4px;
                cursor: pointer;
                font-weight: 500;
            }

            .pagination-wrapper button:hover {
                background-color: #007bff;
                color: white;
            }

            .pagination-wrapper button:disabled {
                background-color: #007bff;
                color: white;
                font-weight: bold;
                cursor: default;
            }
            .sidebar a:last-child {
                margin-top: auto;
                font-weight: bold;
                background-color: #1d3557;
            }

            .sidebar a:last-child:hover {
                background-color: #457b9d;
            }

        </style>
    </head>
    <body>

        <div class="sidebar">
            <h2>📊 Dashboard</h2>
            <a href="post-detail">➕ Add New Post</a>
            <a href="slider-list">📋 View All Slider List</a>
            <a href="#">🖼️ Add New Slider</a>
            <a href="home">🏠 Back to Homepage</a>

        </div>

        <div class="content">
            <h2>Post List</h2>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Created</th>
                    <th>Content</th>
                    <th>Status</th>
                </tr>
                <%
                    List<Post> postList = (List<Post>) request.getAttribute("postList");
                    for (Post p : postList) {
                %>
                <tr>
                    <td><%= p.getId() %></td>
                    <td><%= p.getTitle() %></td>
                    <td><%= p.getCreatedAt() %></td>
                    <td><%= p.getContent() %></td>
                    <td><a href="post_detail.jsp?id=<%= p.getId() %>">&#128065;</a></td>
                </tr>
                <% } %>
            </table>

            <div class="pagination-wrapper">
                <%
                    Integer postPage = (Integer) request.getAttribute("postPage");
                    int postTotalPages = (int) request.getAttribute("postTotalPages");
                    for (int i = 1; i <= postTotalPages; i++) {
                %>
                <form action="mtk-dashboard" method="get">
                    <input type="hidden" name="postPage" value="<%= i %>"/>
                    <input type="hidden" name="sliderPage" value="<%= request.getAttribute("sliderPage") %>"/>
                    <button <%= (i == postPage) ? "disabled" : "" %>><%= i %></button>
                </form>
                <% } %>
            </div>

            <h2>Slider List</h2>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Image</th>
                    <th>Backlink</th>
                    <th>Status</th>
                </tr>
                <%
                    List<Slider> sliderList = (List<Slider>) request.getAttribute("sliderList");
                    for (Slider s : sliderList) {
                %>
                <tr>
                    <td><%= s.getId() %></td>
                    <td><%= s.getTitle() %></td>
                    <td><img src="<%= s.getImage() %>" alt="No Image"/></td>
                    <td><%= s.getDescription() %></td>
                    <td><%= s.getType() %></td>
                </tr>
                <% } %>
            </table>

            <div class="pagination-wrapper">
                <%
                    Integer sliderPage = (Integer) request.getAttribute("sliderPage");
                    int sliderTotalPages = (int) request.getAttribute("sliderTotalPages");
                    for (int i = 1; i <= sliderTotalPages; i++) {
                %>
                <form action="mtk-dashboard" method="get">
                    <input type="hidden" name="sliderPage" value="<%= i %>"/>
                    <input type="hidden" name="postPage" value="<%= request.getAttribute("postPage") %>"/>
                    <button <%= (i == sliderPage) ? "disabled" : "" %>><%= i %></button>
                </form>
                <% } %>
            </div>
        </div>

    </body>
</html>
