<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Sliders List</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #fff;
                margin: 0;
                padding: 20px;
            }

            .container {
                max-width: 1080px;
                margin: auto;
            }

            .btn-back {
                padding: 6px 12px;
                margin-bottom: 20px;
                border: 1px solid #888;
                border-radius: 4px;
                background: #f8f8f8;
                cursor: pointer;
            }

            h1 {
                font-size: 42px;
                font-weight: bold;
                margin-bottom: 30px;
            }

            .filter-section {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 30px;
            }

            .filter-section label {
                font-weight: bold;
                font-size: 18px;
            }

            select, input[type="text"] {
                padding: 8px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 2px;
            }

            .filter-section button {
                padding: 8px 18px;
                font-size: 14px;
                background-color: #2a5ca6;
                color: white;
                border: none;
                border-radius: 2px;
                cursor: pointer;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }

            th, td {
                padding: 12px 10px;
                border: 1px solid #ccc;
                text-align: left;
            }

            th {
                background-color: #e0e0e0;
            }

            td img.slider-img {
                width: 48px;
                display: block;
                margin: auto;
            }

            td img.eye-icon {
                width: 24px;
                display: block;
                margin: auto;
            }

            .pagination {
                text-align: center;
                margin-top: 20px;
            }

            .pagination a,
            .pagination span {
                display: inline-block;
                padding: 4px 8px;
                margin: 0 2px;
                border: 1px solid #ccc;
                font-size: 13px;
                border-radius: 2px;
                min-width: 24px;
                text-decoration: none;
                color: #000;
            }

            .pagination .current {
                background-color: #333;
                color: white;
            }

        </style>
    </head>
    <body>
        <div class="container">
            <button onclick="history.back()">Back</button>
            <h1>Sliders List</h1>

            <!-- FILTER FORM -->
            <form method="get">
                <label for="status"><strong>Status</strong></label>
                <select id="status" name="status">
                    <option value="All"  ${status == 'All' || empty status ? 'selected' : ''}>All</option>
                    <option value="Show" ${status == 'Show' ? 'selected' : ''}>Show</option>
                    <option value="Hide" ${status == 'Hide' ? 'selected' : ''}>Hide</option>
                </select>

                <input type="text" name="search" placeholder="Search title..." value="${fn:escapeXml(search)}"/>
                <input type="hidden" name="page" value="1"/>
                <button type="submit">Search</button>
            </form>

            <!-- SLIDER TABLE -->
            <table border="1" width="100%" cellpadding="5" cellspacing="0">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Image</th>
                        <th>Backlink</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty sliderList}">
                            <c:forEach var="slider" items="${sliderList}">
                                <tr>
                                    <td>${slider.id}</td>
                                    <td>${slider.title}</td>
                                    <td><img src="${slider.image}" class="slider-img" alt="slider"/></td>
                                    <td><a href="${slider.backlink}">${slider.backlink}</a></td>
                                    <td>${slider.type}</td>
                                    <td style="text-align:center;">
                                        <a href="viewSlider?id=${slider.id}" title="View">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none"
                                                 viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M2.458 12C3.732 7.943 7.522 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.478 0-8.268-2.943-9.542-7z"/>
                                            </svg>
                                        </a>
                                    </td>

                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" style="text-align:center">Không có slider nào.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <!-- PAGINATION -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="?status=${status}&search=${fn:escapeXml(search)}&page=${currentPage - 1}">Prev</a>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span class="current">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="?status=${status}&search=${fn:escapeXml(search)}&page=${i}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <a href="?status=${status}&search=${fn:escapeXml(search)}&page=${currentPage + 1}">Next</a>
                    </c:if>
                </div>
            </c:if>
        </div>
    </body>
</html>