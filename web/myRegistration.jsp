<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My registration list</title>
        <style>
            /* Định dạng tổng thể */
            body {
                display: flex;
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f4f4f4;
            }

            /* Sidebar */
            .sidebar {
                width: 220px;
                background: #2c3e50;
                color: white;
                padding: 20px;
                min-height: 100vh;
                position: fixed;
                left: 0;
                top: 0;
                transition: transform 0.3s ease-in-out;
            }

            /* Ẩn sidebar khi có class "hidden" */
            .sidebar.hidden {
                transform: translateX(-100%);
            }

            /* Danh sách sidebar */
            .sidebar ul {
                list-style: none;
                padding: 0;
            }

            .sidebar ul li {
                margin: 15px 0;
            }

            .sidebar ul li a {
                color: white;
                text-decoration: none;
                font-size: 16px;
                display: block;
                padding: 10px;
                border-radius: 5px;
            }

            .sidebar ul li a:hover {
                background-color: #deddf0;
            }

            /* Nội dung chính */
            main {
                flex-grow: 1;
                padding: 20px;
                margin-left: 240px;
                transition: margin-left 0.3s ease-in-out;
            }

            /* Khi sidebar ẩn, dịch nội dung chính sang trái */
            .sidebar.hidden + main {
                margin-left: 0;
            }

            /* Header */
            header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px;
                border-radius: 8px;
                color: rgb(0, 0, 0);
            }

            /* Nút Toggle Sidebar */
            #toggleSidebar {
                background-color: #34495e;
                color: white;
                text-decoration: none;
                padding: 10px 15px;
                font-size: 16px;
                cursor: pointer;
                border-radius: 5px;
                margin-right: 15px;
            }

            #toggleSidebar:hover {
                background-color: #2c3e50;
            }

            /* Khu vực chứa hai nút xanh */
            .controls {
                display: flex;
                justify-content: center;
                gap: 15px;
                margin: 20px 0;
            }

            /* Nút liên kết trong .controls */
            .controls a {
                font-size: 16px;
                background-color: #27ae60;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                text-decoration: none;
                display: inline-block;
                transition: background-color 0.3s ease;
            }

            .controls a:hover {
                background-color: #2ecc71;
            }

            /* Bảng dữ liệu */
            table {
                width: 100%;
                border-collapse: collapse;
                background-color: white;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            }

            th, td {
                padding: 12px;
                text-align: center;
                border-bottom: 1px solid #ddd;
            }

            th {
                background-color: #2980b9;
                color: white;
            }

            tr:hover {
                background-color: #f2f2f2;
            }

            /* Nút chỉnh sửa */
            button.action {
                background-color: #27ae60;
                color: white;
                padding: 8px 12px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }

            button.action:hover {
                background-color: #2ecc71;
            }

            /* Ô tìm kiếm */
            .search-box {
                display: flex;
                align-items: center;
                background-color: white;
                padding: 10px;
                border-radius: 25px;
                border: 2px solid #003366;
                box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.2);
                width: 350px;
            }

            .search-box input[type="search"] {
                flex: 1;
                padding: 10px;
                border: none;
                border-radius: 25px;
                outline: none;
                font-size: 16px;
            }

            /* Nút tìm kiếm */
            .search-button {
                background-color: #003366;
                color: white;
                border: none;
                padding: 10px 15px;
                border-radius: 25px;
                cursor: pointer;
                font-size: 16px;
                margin-left: 8px;
            }

            .search-button:hover {
                background-color: #0056b3;
            }

            /* Bao bọc ô tìm kiếm để định vị dropdown */
            .search-container {
                position: relative;
            }

            /* Nút mũi tên dropdown */
            .dropdown-toggle {
                background-color: white;
                border: none;
                cursor: pointer;
                font-size: 18px;
                padding-left: 10px;
                text-decoration: none;
                color: #003366;
            }

            /* Dropdown menu */
            .dropdown-menu {
                display: none;
                position: absolute;
                top: calc(100% + 5px);
                right: 0;
                width: 280px;
                background-color: white;
                border: 2px solid #003366;
                border-radius: 5px;
                box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
                padding: 15px;
                z-index: 100;
            }

            .dropdown-menu.visible {
                display: block;
            }

            .dropdown-menu .filter-section {
                margin-bottom: 15px;
            }

            .dropdown-menu .filter-title {
                font-weight: bold;
                color: #003366;
                margin-bottom: 8px;
                border-bottom: 1px solid #e0e0e0;
                padding-bottom: 5px;
            }

            .dropdown-menu .filter-options {
                max-height: 150px;
                overflow-y: auto;
            }

            .dropdown-menu .filter-item {
                display: flex;
                align-items: center;
                padding: 8px 0;
                font-size: 14px;
            }

            .dropdown-menu .filter-item input[type="checkbox"] {
                margin-right: 8px;
                transform: scale(1.2);
            }

            .dropdown-menu .filter-item label {
                cursor: pointer;
                flex: 1;
            }

            .dropdown-menu .filter-actions {
                display: flex;
                gap: 10px;
                margin-top: 15px;
                padding-top: 10px;
                border-top: 1px solid #e0e0e0;
            }

            .dropdown-menu .btn-clear, .dropdown-menu .btn-apply {
                padding: 8px 16px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 12px;
                flex: 1;
            }

            .dropdown-menu .btn-clear {
                background-color: #e74c3c;
                color: white;
            }

            .dropdown-menu .btn-apply {
                background-color: #27ae60;
                color: white;
            }

            .dropdown-menu .btn-clear:hover {
                background-color: #c0392b;
            }

            .dropdown-menu .btn-apply:hover {
                background-color: #229954;
            }

            /* Active filter indicator */
            .search-box.has-filters {
                border-color: #27ae60;
                box-shadow: 0px 2px 6px rgba(39, 174, 96, 0.3);
            }

            .dropdown-toggle.has-filters {
                color: #27ae60;
                font-weight: bold;
            }

            /* Search results info */
            .search-info {
                margin: 15px 0;
                padding: 10px;
                background-color: #e8f4fd;
                border-left: 4px solid #3498db;
                border-radius: 4px;
                font-size: 14px;
                color: #2c3e50;
            }

        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <nav class="sidebar">
            <ul>
                <li><a href="home">Home</a></li>
                <li><a href="subject">Subject</a></li>
                <li><a href="myRegistration">My Registrations</a></li>
                <li><a href="#">Setting</a></li>
            </ul>
        </nav>

        <main>
            <!-- Header -->
            <header>
                <a href="#" id="toggleSidebar">☰ Toggle Sidebar</a>
                <h1>My Registrations List</h1>

                <!-- Thanh tìm kiếm với dropdown -->
                <div class="search-container">
                    <div class="search-box" id="searchBox">
                        <input type="search" id="searchInput" placeholder="Tìm kiếm theo tên môn học...">
                        <button class="search-button" id="searchBtn">🔍</button>
                        <a href="#" id="toggleDropdown" class="dropdown-toggle">▼</a>
                    </div>
                    <div class="dropdown-menu" id="dropdownMenu">
                        <div class="filter-section">
                            <div class="filter-title">Danh mục môn học</div>
                            <div class="filter-options" id="categoryFilters">
                                <!-- Categories will be populated dynamically -->
                            </div>
                        </div>
                        
                        <div class="filter-section">
                            <div class="filter-title">Trạng thái</div>
                            <div class="filter-options">
                                <div class="filter-item">
                                    <input type="checkbox" id="status-active" value="active">
                                    <label for="status-active">Đang hoạt động</label>
                                </div>
                                <div class="filter-item">
                                    <input type="checkbox" id="status-submitted" value="submitted">
                                    <label for="status-submitted">Đã đăng ký</label>
                                </div>
                                <div class="filter-item">
                                    <input type="checkbox" id="status-pending" value="pending">
                                    <label for="status-pending">Chờ xử lý</label>
                                </div>
                                <div class="filter-item">
                                    <input type="checkbox" id="status-expired" value="expired">
                                    <label for="status-expired">Đã hết hạn</label>
                                </div>
                            </div>
                        </div>

                        <div class="filter-actions">
                            <button class="btn-clear" id="clearFilters">Xóa bộ lọc</button>
                            <button class="btn-apply" id="applyFilters">Áp dụng</button>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Search info -->
            <div class="search-info" id="searchInfo" style="display: none;">
                <span id="searchInfoText"></span>
            </div>

            <!-- Nút Practice & Simulation Exam -->
            <div class="controls">
                <a href="practice">Practice</a>
                <a href="stimulationExam">Stimulation Exam</a>
            </div>

            <!-- Bảng đăng ký -->
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Subject</th>
                        <th>Registration Time</th>
                        <th>Status</th>
                        <th>Total Cost</th>
                        <th>Package</th>
                        <th>Valid from</th>
                        <th>Valid to</th>
                        <th>Option</th>
                    </tr>
                </thead>
                <tbody>

                </tbody>

            </table>
        </main>

        <script>
            // Global variables
            let allRegistrations = [];
            let filteredRegistrations = [];
            let activeFilters = {
                categories: [],
                statuses: [],
                searchTerm: ''
            };

            // Utility functions
            function formatDate(dateString) {
                if (!dateString) return 'N/A';
                const date = new Date(dateString);
                if (isNaN(date.getTime())) return 'Invalid Date';
                return date.toLocaleDateString('vi-VN', {
                    year: 'numeric',
                    month: '2-digit',
                    day: '2-digit',
                    hour: '2-digit',
                    minute: '2-digit'
                });
            }

            function formatCurrency(amount) {
                if (!amount && amount !== 0) return 'N/A';
                return new Intl.NumberFormat('vi-VN', {
                    style: 'currency',
                    currency: 'VND'
                }).format(amount);
            }

            function createStatusBadge(status) {
                const statusColors = {
                    'active': '#27ae60',
                    'inactive': '#e74c3c', 
                    'pending': '#f39c12',
                    'expired': '#95a5a6',
                    'submitted': '#3498db'
                };
                const color = statusColors[status && status.toLowerCase()] || '#6c757d';
                return '<span style="background-color: ' + color + '; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold;">' + (status || 'Unknown') + '</span>';
            }

            function getPackageInfo(subjectPackage) {
                if (!subjectPackage) return 'N/A';
                const salePrice = subjectPackage.salePrice ? formatCurrency(subjectPackage.salePrice) : '';
                const originalPrice = subjectPackage.originalPrice ? formatCurrency(subjectPackage.originalPrice) : '';
                let priceInfo = '';
                if (salePrice && originalPrice && subjectPackage.salePrice < subjectPackage.originalPrice) {
                    priceInfo = '<br><small style="color: #e74c3c; text-decoration: line-through;">' + originalPrice + '</small><br><small style="color: #27ae60; font-weight: bold;">' + salePrice + '</small>';
                } else if (originalPrice) {
                    priceInfo = '<br><small>' + originalPrice + '</small>';
                }
                return '<div><strong>' + (subjectPackage.title || 'Unknown Package') + '</strong>' + priceInfo + '<br><small style="color: #6c757d;">' + (subjectPackage.category || '') + '</small></div>';
            }

            // API functions
            async function fetchRegistrations() {
                try {
                    const response = await fetch('http://localhost:9999/EducationPlatform/registration-api', {
                        method: 'GET',
                        headers: {'Content-Type': 'application/json'},
                        credentials: 'same-origin'
                    });

                    if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
                    const result = await response.json();

                    if (result.success) {
                        allRegistrations = result.data;
                        filteredRegistrations = [...allRegistrations];
                        populateCategoryFilters();
                        populateRegistrationTable(filteredRegistrations);
                        updateSearchInfo();
                    } else {
                        console.error('API returned error:', result.message);
                        showErrorMessage('Failed to load registrations: ' + result.message);
                    }
                } catch (error) {
                    console.error('Error fetching registrations:', error);
                    showErrorMessage('Failed to connect to server. Please try again.');
                }
            }

            // Table population functions
            function populateRegistrationTable(registrations) {
                const tbody = document.querySelector('table tbody');
                tbody.innerHTML = '';

                if (!registrations || registrations.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="9">Không tìm thấy đăng ký nào</td></tr>';
                    return;
                }

                registrations.forEach(registration => {
                    const row = createRegistrationRow(registration);
                    tbody.appendChild(row);
                });
            }

            function createRegistrationRow(registration) {
                const row = document.createElement('tr');
                const registrationTime = formatDate(registration.createdAt);
                const validFrom = formatDate(registration.validFrom);
                const validTo = formatDate(registration.validTo);
                const totalCost = formatCurrency(registration.totalCost);
                const subjectTitle = registration.subjectPackage ? registration.subjectPackage.title : 'N/A';
                const statusBadge = createStatusBadge(registration.status);

                row.innerHTML = 
                    '<td>' + registration.id + '</td>' +
                    '<td>' + subjectTitle + '</td>' +
                    '<td>' + registrationTime + '</td>' +
                    '<td>' + statusBadge + '</td>' +
                    '<td>' + totalCost + '</td>' +
                    '<td>' + getPackageInfo(registration.subjectPackage) + '</td>' +
                    '<td>' + validFrom + '</td>' +
                    '<td>' + validTo + '</td>' +
                    '<td><button class="action" onclick="viewDetails(' + registration.id + ')">View Details</button></td>';
                return row;
            }

            // Filter functions
            function populateCategoryFilters() {
                const categories = [...new Set(allRegistrations
                    .map(reg => reg.subjectPackage?.category)
                    .filter(category => category)
                )];

                const categoryFiltersContainer = document.getElementById('categoryFilters');
                categoryFiltersContainer.innerHTML = '';

                categories.forEach(category => {
                    const filterId = 'category-' + category.replace(/\s+/g, '-').toLowerCase();
                    const filterItem = document.createElement('div');
                    filterItem.className = 'filter-item';
                    filterItem.innerHTML = 
                        '<input type="checkbox" id="' + filterId + '" value="' + category + '">' +
                        '<label for="' + filterId + '">' + category + '</label>';
                    categoryFiltersContainer.appendChild(filterItem);
                });
            }

            function applyFilters() {
                // Get search term
                activeFilters.searchTerm = document.getElementById('searchInput').value.toLowerCase().trim();

                // Get selected categories
                activeFilters.categories = [];
                document.querySelectorAll('#categoryFilters input[type="checkbox"]:checked').forEach(checkbox => {
                    activeFilters.categories.push(checkbox.value);
                });

                // Get selected statuses
                activeFilters.statuses = [];
                document.querySelectorAll('#dropdownMenu input[id^="status-"]:checked').forEach(checkbox => {
                    activeFilters.statuses.push(checkbox.value);
                });

                // Apply filters
                filteredRegistrations = allRegistrations.filter(registration => {
                    // Search term filter
                    if (activeFilters.searchTerm) {
                        const subjectTitle = registration.subjectPackage?.title?.toLowerCase() || '';
                        if (!subjectTitle.includes(activeFilters.searchTerm)) {
                            return false;
                        }
                    }

                    // Category filter
                    if (activeFilters.categories.length > 0) {
                        const category = registration.subjectPackage?.category;
                        if (!category || !activeFilters.categories.includes(category)) {
                            return false;
                        }
                    }

                    // Status filter
                    if (activeFilters.statuses.length > 0) {
                        const status = registration.status?.toLowerCase();
                        if (!status || !activeFilters.statuses.includes(status)) {
                            return false;
                        }
                    }

                    return true;
                });

                populateRegistrationTable(filteredRegistrations);
                updateSearchInfo();
                updateFilterIndicators();
                closeDropdown();
            }

            function clearAllFilters() {
                // Clear search input
                document.getElementById('searchInput').value = '';

                // Clear all checkboxes
                document.querySelectorAll('#dropdownMenu input[type="checkbox"]').forEach(checkbox => {
                    checkbox.checked = false;
                });

                // Reset filters
                activeFilters = { categories: [], statuses: [], searchTerm: '' };
                filteredRegistrations = [...allRegistrations];

                populateRegistrationTable(filteredRegistrations);
                updateSearchInfo();
                updateFilterIndicators();
            }

            function updateFilterIndicators() {
                const searchBox = document.getElementById('searchBox');
                const dropdownToggle = document.getElementById('toggleDropdown');
                
                const hasActiveFilters = activeFilters.searchTerm || 
                                       activeFilters.categories.length > 0 || 
                                       activeFilters.statuses.length > 0;

                if (hasActiveFilters) {
                    searchBox.classList.add('has-filters');
                    dropdownToggle.classList.add('has-filters');
                } else {
                    searchBox.classList.remove('has-filters');
                    dropdownToggle.classList.remove('has-filters');
                }
            }

            function updateSearchInfo() {
                const searchInfo = document.getElementById('searchInfo');
                const searchInfoText = document.getElementById('searchInfoText');
                
                const total = allRegistrations.length;
                const filtered = filteredRegistrations.length;
                
                if (filtered < total) {
                    searchInfoText.textContent = 'Hiển thị ' + filtered + ' trên tổng số ' + total + ' đăng ký';
                    searchInfo.style.display = 'block';
                } else {
                    searchInfo.style.display = 'none';
                }
            }

            // UI Event handlers
            function showErrorMessage(message) {
                const tbody = document.querySelector('table tbody');
                tbody.innerHTML = '<tr><td colspan="9" style="color: #e74c3c; text-align: center; padding: 20px;"><strong>Error:</strong> ' + message + '</td></tr>';
            }

            function showLoading() {
                const tbody = document.querySelector('table tbody');
                tbody.innerHTML = '<tr><td colspan="9" style="text-align: center; padding: 20px;">Đang tải...</td></tr>';
            }

            function viewDetails(registrationId) {
                window.location.href = '/registrationDetails?id=' + registrationId;
            }

            function closeDropdown() {
                document.getElementById('dropdownMenu').classList.remove('visible');
            }

            // Event listeners
            document.addEventListener('DOMContentLoaded', function() {
                // Sidebar toggle
                document.getElementById("toggleSidebar").addEventListener("click", function(event) {
                    event.preventDefault();
                    document.querySelector(".sidebar").classList.toggle("hidden");
                });

                // Dropdown toggle
                document.getElementById("toggleDropdown").addEventListener("click", function(event) {
                    event.preventDefault();
                    document.getElementById('dropdownMenu').classList.toggle("visible");
                });

                // Close dropdown when clicking outside
                document.addEventListener("click", function(event) {
                    const dropdownMenu = document.getElementById('dropdownMenu');
                    const toggleButton = document.getElementById("toggleDropdown");
                    const searchBox = document.getElementById("searchBox");

                    if (!toggleButton.contains(event.target) && 
                        !dropdownMenu.contains(event.target) && 
                        !searchBox.contains(event.target)) {
                        dropdownMenu.classList.remove("visible");
                    }
                });

                // Search functionality
                const searchInput = document.getElementById('searchInput');
                const searchBtn = document.getElementById('searchBtn');

                searchBtn.addEventListener('click', applyFilters);
                searchInput.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        applyFilters();
                    }
                });
                
                // Real-time search
                searchInput.addEventListener('input', function() {
                    clearTimeout(this.searchTimeout);
                    this.searchTimeout = setTimeout(applyFilters, 500);
                });

                // Filter actions
                document.getElementById('applyFilters').addEventListener('click', applyFilters);
                document.getElementById('clearFilters').addEventListener('click', clearAllFilters);

                // Initialize data
                showLoading();
                fetchRegistrations();
            });

            // Public functions for external use
            window.refreshRegistrations = function() {
                showLoading();
                fetchRegistrations();
            };
        </script>
    </body>
</html>