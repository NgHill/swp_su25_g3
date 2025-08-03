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
                font-family: 'Segoe UI', sans-serif;
                background: #f3e8ff; /* tím nhạt */
                margin: 0;
                padding: 30px;
                color: #333;
            }

            .container {
                max-width: 1100px;
                margin: auto;
                background-color: #ffffff;
                border-radius: 12px;
                padding: 30px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            }

            /* Nút Back */
            .btn-back {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 10px 18px;
                border: 2px solid #9d4edd;
                background-color: #f3e8ff;
                color: #6a1b9a;
                font-weight: 500;
                font-size: 15px;
                border-radius: 8px;
                transition: all 0.3s ease;
                text-decoration: none;
                margin-bottom: 25px;
                cursor: pointer;
            }

            .btn-back:hover {
                background-color: #9d4edd;
                color: white;
                border-color: #7b2cbf;
            }

            h1 {
                font-size: 32px;
                font-weight: bold;
                margin-bottom: 30px;
                color: #5a189a;
            }

            /* FILTER SECTION */
            .filter-section {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 30px;
                flex-wrap: wrap;
            }

            .filter-section label {
                font-weight: 600;
                font-size: 16px;
                color: #4b0082;
            }

            select, input[type="text"] {
                padding: 10px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 6px;
                min-width: 160px;
                outline: none;
            }

            .filter-section button {
                padding: 10px 24px;
                font-size: 15px;
                font-weight: 600;
                background-color: #7b2cbf;
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 4px 10px rgba(123, 44, 191, 0.2);
            }

            .filter-section button:hover {
                background-color: #5a189a;
                box-shadow: 0 6px 12px rgba(90, 24, 154, 0.3);
            }


            /* TABLE */
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
                background-color: #fff;
                border-radius: 8px;
                overflow: hidden;
            }

            th, td {
                padding: 14px 12px;
                border-bottom: 1px solid #ddd;
                text-align: left;
                font-size: 14px;
            }

            th {
                background-color: #e7d5f7;
                color: #4b0082;
                font-weight: 600;
            }

            tbody tr:hover {
                background-color: #f5f0ff;
            }

            td img.slider-img {
                width: 48px;
                border-radius: 4px;
                display: block;
                margin: auto;
            }

            td img.eye-icon {
                width: 24px;
                display: block;
                margin: auto;
            }

            td a {
                color: #5e35b1;
                text-decoration: none;
            }

            td a:hover {
                text-decoration: underline;
            }

            /* PAGINATION */
            .pagination {
                text-align: center;
                margin-top: 30px;
            }

            .pagination a,
            .pagination span {
                display: inline-block;
                padding: 6px 12px;
                margin: 0 3px;
                border: 1px solid #ccc;
                font-size: 14px;
                border-radius: 6px;
                min-width: 28px;
                text-decoration: none;
                color: #4b0082;
                transition: all 0.2s ease;
            }

            .pagination a:hover {
                background-color: #e0bbff;
            }

            .pagination .current {
                background-color: #5a189a;
                color: white;
                border-color: #5a189a;
            }
        </style>

    </head>
    <body>
        <div class="container">
            <button class="btn-back" onclick="history.back()">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" viewBox="0 0 24 24" width="18" height="18">
                <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
                </svg>
                Back
            </button>


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
                                    <td><a href="${slider.getDescription()}">${slider.getDescription()}</a></td>
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