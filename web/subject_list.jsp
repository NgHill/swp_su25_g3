<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
    <a href="home" class="back-home-btn">🏠 Back to Homepage</a>
    <title>Subject List</title>
    <style>
        .back-home-btn {
            display: inline-block;
            margin-bottom: 16px;
            padding: 10px 18px;
            background-color: #9d4edd;
            color: white;
            text-decoration: none;
            font-weight: 600;
            border-radius: 8px;
            transition: background-color 0.3s ease;
        }

        .back-home-btn:hover {
            background-color: #7b2cbf;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            padding: 30px;
            background-color: #f3e8ff; /* nền tím nhạt */
            color: #333;
        }

        h1 {
            font-size: 28px;
            margin-bottom: 25px;
            color: #5a189a;
        }

        /* --- Filter group --- */
        .filters {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 20px;
            align-items: center;
            background-color: #fff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(90, 24, 154, 0.05);
        }

        .filters label {
            font-weight: 600;
            font-size: 14px;
            color: #4b0082;
        }

        .filters select,
        .filters input[type="text"],
        .filters input[type="number"] {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 14px;
            min-width: 150px;
            outline: none;
        }

        /* --- Search --- */
        .search-group {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 20px 0;
        }

        .search-group input[type="text"] {
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
            width: 250px;
            outline: none;
        }

        .search-group button {
            padding: 10px 20px;
            background-color: #7b2cbf;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .search-group button:hover {
            background-color: #5a189a;
        }

        /* --- Checkbox filter --- */
        form > div:nth-of-type(3) {
            background-color: #ffffff;
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 1px 8px rgba(0, 0, 0, 0.05);
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: center;
        }

        /* --- Add button --- */
        .add-btn {
            float: right;
            padding: 10px 18px;
            background-color: #9d4edd;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        .add-btn:hover {
            background-color: #7b2cbf;
        }

        /* --- Table --- */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 30px;
            background-color: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
        }

        th, td {
            padding: 14px 12px;
            text-align: center;
            border-bottom: 1px solid #eee;
            font-size: 14px;
        }

        th {
            background-color: #e0c9ff;
            color: #4b0082;
            font-weight: 600;
        }

        tr:hover {
            background-color: #f5edff;
        }

        /* --- Pagination --- */
        .pagination {
            margin-top: 25px;
            text-align: center;
        }

        .pagination a {
            padding: 8px 14px;
            margin: 0 3px;
            text-decoration: none;
            border: 1px solid #9d4edd;
            border-radius: 6px;
            background-color: white;
            color: #5a189a;
            font-weight: 500;
            transition: background 0.3s ease;
        }

        .pagination a:hover {
            background-color: #d0aaff;
            color: white;
        }

        /* Optional: icon eye in action */
        td a {
            text-decoration: none;
            font-size: 18px;
        }
    </style>

    <script>
        function toggleColumn(columnClass, checkbox) {
            var cells = document.querySelectorAll('.' + columnClass);
            cells.forEach(function (cell) {
                cell.style.display = checkbox.checked ? '' : 'none';
            });
        }

        function initializeColumns() {
            var checkboxes = document.querySelectorAll('.column-toggle');
            checkboxes.forEach(function (checkbox) {
                toggleColumn(checkbox.value, checkbox);

                checkbox.addEventListener('change', function () {
                    // Kiểm tra nếu người dùng bỏ chọn cột "Name"
                    var nameCheckbox = document.querySelector('input.column-toggle[value="col-name"]');

                    if (!nameCheckbox.checked) {
                        alert(" [Title] cannot be hidden. Please keep it.");
                        nameCheckbox.checked = true;
                        toggleColumn("col-name", nameCheckbox);
                        return;
                    }

                    toggleColumn(checkbox.value, checkbox);
                });
            });
        }

        window.onload = initializeColumns;
    </script>
</head>
<body>
    <form method="get" action="subject-list2">
        <h1>Subject List</h1>
        <div class="filters">
            <label>Status:</label>
            <select name="status">
                <option value="" ${empty param.status ? 'selected' : ''}>All</option>
                <option value="Show" ${param.status == 'published' ? 'selected' : ''}>Published</option>
                <option value="Hide" ${param.status == 'un-published' ? 'selected' : ''}>Unpublished</option>
            </select>

            <label>Category:</label>
            <select name="category">
                <option value="" ${empty param.category ? 'selected' : ''}>All</option>
                <c:forEach var="cat" items="${categoryList}">
                    <option value="${cat}" ${cat == param.category ? 'selected' : ''}>${cat}</option>
                </c:forEach>
            </select>

            <label>Number of lines:</label>
            <input type="number" name="lines" value="${param.lines}" min="1" />
        </div>

        <div class="search-group">
            <input type="text" name="search" placeholder="Search by name..." value="${param.search}" />
            <button type="submit">Search</button>l
        </div>

        <div>
            <label>Filter by:</label>
            <label><input type="checkbox" class="column-toggle" value="col-id" checked/> ID</label>
            <label><input type="checkbox" class="column-toggle" value="col-name" checked/> Title</label>
            <label><input type="checkbox" class="column-toggle" value="col-category" checked/> Category</label>
            <label><input type="checkbox" class="column-toggle" value="col-lessons" checked/> BriefInfo</label>
            <label><input type="checkbox" class="column-toggle" value="col-owner" checked/> OriginalPrice</label>
            <label><input type="checkbox" class="column-toggle" value="col-status" checked/> Status</label>
        </div>

        <a href="add-subject" class="add-btn">+ Add new subject</a>

        <!--ID,Title, Category, BriefInfo, OriginalPrice,Status,-->
        <table>
            <thead>
                <tr>
                    <th class="col-id">ID</th>
                    <th class="col-name">Title</th>
                    <th class="col-category">Category</th>
                    <th class="col-lessons">Brief Info</th>
                    <th class="col-owner">Original Price</th>
                    <th class="col-status">Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="subject" items="${subjectPackage}">
                    <tr>
                        <td class="col-id">${subject.getId()}</td>
                        <td class="col-name">${subject.getTitle()}</td>
                        <td class="col-category">${subject.getCategory()}</td>
                        <td class="col-lessons">${subject.getBriefInfo()}</td>
                        <td class="col-owner">${subject.getOriginalPrice()}</td>
                        <td class="col-status">${subject.getStatus()}</td>
                        <td><a href="edit-subject?id=${subject.getId()}">👁️</a></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="pagination">
            <c:set var="currentPage" value="${param.page != null ? param.page : 1}" />
            <a href="subject-list2?page=${currentPage > 1 ? currentPage-1 : 1}&status=${param.status}&category=${param.category}&lines=${param.lines}&search=${param.search}"><<</a>
            <a href="subject-list2?page=${currentPage}&status=${param.status}&category=${param.category}&lines=${param.lines}&search=${param.search}">${currentPage}</a>
            <a href="subject-list2?page=${currentPage+1}&status=${param.status}&category=${param.category}&lines=${param.lines}&search=${param.search}">>></a>
        </div>
    </form>
    <script>
        // Embed Java value into JavaScript
            const username = '<%= request.getAttribute("subjectPackage") %>';
        console.log("Username from Servlet:", username);
    </script>
</body>
</html>