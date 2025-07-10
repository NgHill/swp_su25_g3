<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Subject List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 30px;
            background-color: #f8f9fa;
        }
        h1 { margin-bottom: 20px; }
        .filters {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 10px;
            align-items: center;
        }
        .filters label { font-weight: bold; }
        .filters select, .filters input[type="text"], .filters input[type="number"] {
            padding: 6px;
            width: 150px;
        }
        .search-group {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 10px;
        }
        .add-btn {
            float: right;
            padding: 8px 16px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: white;
            table-layout: fixed;
        }
        th, td {
            padding: 10px;
            text-align: center;
            border: 1px solid #ccc;
            word-wrap: break-word;
        }
        th { background-color: #e9ecef; }
        .pagination {
            margin-top: 20px;
            text-align: center;
        }
        .pagination a {
            padding: 6px 10px;
            margin: 0 2px;
            text-decoration: none;
            border: 1px solid #aaa;
            border-radius: 3px;
            background-color: white;
            color: black;
        }
        .pagination a:hover {
            background-color: #007bff;
            color: white;
        }
    </style>
    <script>
        function toggleColumn(columnClass, checkbox) {
            var cells = document.querySelectorAll('.' + columnClass);
            cells.forEach(function(cell) {
                cell.style.display = checkbox.checked ? '' : 'none';
            });
        }

        function initializeColumns() {
            var checkboxes = document.querySelectorAll('.column-toggle');
            checkboxes.forEach(function(checkbox) {
                toggleColumn(checkbox.value, checkbox);
                checkbox.addEventListener('change', function() {
                    toggleColumn(this.value, this);
                });
            });
        }

        window.onload = initializeColumns;
    </script>
</head>
<body>
<form method="get" action="subject-list">
    <h1>Subject List</h1>
    <div class="filters">
        <label>Status:</label>
        <select name="status">
            <option value="" ${empty param.status ? 'selected' : ''}>All</option>
            <option value="Show" ${param.status == 'Show' ? 'selected' : ''}>Show</option>
            <option value="Hide" ${param.status == 'Hide' ? 'selected' : ''}>Hide</option>
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
        <button type="submit">Search</button>
    </div>

    <div>
        <label>Filter by:</label>
        <label><input type="checkbox" class="column-toggle" value="col-id" checked/> ID</label>
        <label><input type="checkbox" class="column-toggle" value="col-name" checked/> Name</label>
        <label><input type="checkbox" class="column-toggle" value="col-category" checked/> Category</label>
        <label><input type="checkbox" class="column-toggle" value="col-lessons" checked/> Number Of Lesson</label>
        <label><input type="checkbox" class="column-toggle" value="col-owner" checked/> Owner</label>
        <label><input type="checkbox" class="column-toggle" value="col-status" checked/> Status</label>
    </div>

    <a href="add-subject" class="add-btn">+ Add new subject</a>

    <table>
        <thead>
        <tr>
            <th class="col-id">ID</th>
            <th class="col-name">Name</th>
            <th class="col-category">Category</th>
            <th class="col-lessons">Number of Lesson</th>
            <th class="col-owner">Owner</th>
            <th class="col-status">Status</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="subject" items="${subjectList}">
            <tr>
                <td class="col-id">${subject.id}</td>
                <td class="col-name">${subject.name}</td>
                <td class="col-category">${subject.category}</td>
                <td class="col-lessons">${subject.lessons}</td>
                <td class="col-owner">${subject.owner}</td>
                <td class="col-status">${subject.status}</td>
                <td><a href="subject-detail.jsp?id=${subject.id}">👁️</a></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <div class="pagination">
        <c:set var="currentPage" value="${param.page != null ? param.page : 1}" />
        <a href="subject-list?page=${currentPage > 1 ? currentPage-1 : 1}&status=${param.status}&category=${param.category}&lines=${param.lines}&search=${param.search}"><<</a>
        <a href="subject-list?page=${currentPage}&status=${param.status}&category=${param.category}&lines=${param.lines}&search=${param.search}">${currentPage}</a>
        <a href="subject-list?page=${currentPage+1}&status=${param.status}&category=${param.category}&lines=${param.lines}&search=${param.search}">>></a>
    </div>
</form>
</body>
</html>