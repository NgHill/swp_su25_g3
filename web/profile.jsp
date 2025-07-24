<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Profile</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* RESET & BODY LAYOUT */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                color: #333;
            }

            .container {
                display: flex;
                min-height: 100vh;
            }

            /* === Sidebar (UPDATED) === */
            .sidebar {
                position: fixed;
                top: 0;
                left: 0;
                width: 220px;
                height: 100%;
                background: #2c3e50;
                color: white;
                padding: 20px;
                box-shadow: 2px 0 20px rgba(0,0,0,0.1);
                transition: transform 0.3s ease, left 0.3s ease;
                z-index: 200;
                overflow-y: auto;
            }

            .sidebar.hidden {
                transform: translateX(-100%);
            }

            .sidebar .avatar-wrapper {
                width: 60px;
                height: 60px;
                background-color: #95a5a6;
                border-radius: 50%;
                margin: 10px auto 20px;
                display: flex;
                justify-content: center;
                align-items: center;
                cursor: pointer;
                overflow: hidden;
            }

            .sidebar .avatar-img {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                object-fit: cover;
                background-color: transparent;
            }

            .sidebar .avatar-icon {
                font-size: 24px;
                color: white;
            }

            .sidebar ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .sidebar ul li {
                margin: 15px 0;
            }

            .sidebar ul li a {
                color: white;
                text-decoration: none;
                display: block;
                padding: 10px;
                border-radius: 5px;
                transition: background 0.3s, transform 0.2s;
            }

            .sidebar ul li a:hover {
                background-color: rgba(255, 255, 255, 0.05);
                transform: translateX(5px);
                color: #ecf0f1;
            }

            /* MAIN CONTENT */
            .main-content {
                flex-grow: 1;
                margin-left: 220px;
                padding: 20px;
                transition: margin-left 0.3s;
            }

            .content-wrapper {
                background:rgba(255,255,255,.95);
                backdrop-filter:blur(10px);
                border-radius:15px;
                padding:30px;
                box-shadow:0 8px 32px rgba(0,0,0,.1);
            }

            .page-header {
                font-size: 28px;
                font-weight: 700;
                color: #2d3748;
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 2px solid #e2e8f0;
            }

            /* PROFILE CONTENT (Original styles preserved) */
            .profile-container {
                width: 100%;
                max-width: 600px; /* Increased max-width for better spacing */
                margin: 0 auto; /* Center the form */
            }

            .profile-form {
                display: flex;
                flex-direction: column;
                gap: 15px;
            }

            .row {
                display: flex;
                gap: 15px;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                flex: 1;
            }

            .form-group label {
                margin-bottom: 5px;
                font-weight: bold;
                color: #2c3e50;
                font-size: 14px;
            }

            .form-group input,
            .form-group select,
            .form-group textarea {
                padding: 10px;
                border: 1px solid #bdc3c7;
                border-radius: 4px;
                font-size: 14px;
                background-color: white;
            }

            .form-group textarea {
                resize: vertical;
                min-height: 80px;
            }

            .save-btn {
                align-self: center;
                padding: 12px 30px;
                background-color: #667eea;
                color: white;
                border: none;
                border-radius: 25px;
                cursor: pointer;
                font-size: 16px;
                font-weight: 600;
                margin-top: 20px;
                transition: background-color .3s, transform .2s;
            }

            .save-btn:hover {
                background-color: #5a67d8;
                transform: scale(1.05);
            }

            /* AVATAR SECTION */
            .avatar-section {
                text-align: center;
                margin-bottom: 20px;
            }

            .avatar-container {
                position: relative;
                display: inline-block;
            }

            .avatar {
                width: 100px;
                height: 100px;
                border-radius: 50%;
                object-fit: cover;
                border: 3px solid #667eea;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .avatar-container:hover .avatar {
                transform: scale(1.05);
            }

            .avatar-overlay {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                opacity: 0;
                transition: all 0.3s ease;
                cursor: pointer;
            }

            .avatar-container:hover .avatar-overlay {
                opacity: 1;
            }

            .avatar-overlay span {
                color: white;
                font-size: 12px;
                font-weight: bold;
                text-align: center;
            }

            .avatar-input {
                display: none;
            }

            .no-select {
                background-color: #ecf0f1;
                color: #7f8c8d;
                cursor: not-allowed;
                user-select: none;
            }

            .error-message {
                color: #e53e3e;
                font-size: 12px;
                margin-top: 4px;
            }

            .success-message {
                color: #38a169;
                background-color: #f0fff4;
                border: 1px solid #9ae6b4;
                padding: 10px;
                border-radius: 5px;
                text-align: center;
                margin-bottom: 15px;
            }

            /* RESPONSIVE */
            @media (max-width: 768px) {
                .sidebar {
                    transform: translateX(-100%);
                }
                .sidebar.hidden {
                    transform: translateX(-100%);
                }
                .main-content {
                    margin-left: 0;
                    padding: 10px;
                }
                .row {
                    flex-direction: column;
                    gap: 15px;
                }
            }
        </style>
    </head>
    <body>

        <nav class="sidebar">
            <a href="${pageContext.request.contextPath}/profile">
                <div class="avatar-wrapper">
                    <c:choose>
                        <c:when test="${not empty sessionScope.userAuth.avatar}">
                            <img src="${pageContext.request.contextPath}/${sessionScope.userAuth.avatar}" alt="Avatar" class="avatar-img">
                        </c:when>
                        <c:otherwise>
                            <span class="avatar-icon">👤</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </a>
            <ul>
                <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/subject-list">Subject</a></li>
                <li><a href="${pageContext.request.contextPath}/my-registration">My registration</a></li>
                <li><a href="${pageContext.request.contextPath}/blog">Blog list</a></li>
                <li><a href="#">Setting</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <div class="content-wrapper">
                <h1 class="page-header">User Profile</h1>
                <div class="profile-container">
                    <form class="profile-form" method="post" action="${pageContext.request.contextPath}/profile" enctype="multipart/form-data">

                        <div class="avatar-section">
                            <div class="avatar-container">
                                <img src="${pageContext.request.contextPath}/${profile.avatar}" alt="Profile Avatar" class="avatar" id="avatarPreview">
                                <div class="avatar-overlay" onclick="document.getElementById('avatarInput').click()">
                                    <span>Change<br>Photo</span>
                                </div>
                            </div>
                        </div>

                        <input type="file" id="avatarInput" name="avatar" class="avatar-input" accept="image/*" onchange="previewAvatar(this)">

                        <c:if test="${not empty message}">
                            <div class="success-message">${message}</div>
                        </c:if>

                        <div class="row">
                            <div class="form-group">
                                <label for="fullName">Full Name</label>
                                <input type="text" id="fullName" name="fullName" value="${profile.fullName}" required>
                                <c:if test="${not empty errors.fullNameError}">
                                    <div class="error-message">${errors.fullNameError}</div>
                                </c:if>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="${profile.email}" readonly class="no-select">
                        </div>

                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" id="username" name="username" value="${profile.username}" required>
                            <c:if test="${not empty errors && not empty errors.usernameError}">
                                <div class="error-message">${errors.usernameError}</div>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="mobile">Phone Number</label>
                            <input type="text" id="mobile" name="mobile" value="${profile.mobile}" required>
                            <c:if test="${not empty errors.mobileError}">
                                <div class="error-message">${errors.mobileError}</div>
                            </c:if>
                        </div>

                        <div class="row">
                            <div class="form-group">
                                <label for="dateOfBirth">Date of Birth</label>
                                <input type="date" id="dateOfBirth" name="dateOfBirth" value="${profile.dateOfBirth}">
                            </div>
                            <div class="form-group">
                                <label for="gender">Gender</label>
                                <select id="gender" name="gender">
                                    <option value="1" ${profile.gender == '1' ? 'selected' : ''}>Male</option>
                                    <option value="0" ${profile.gender == '0' ? 'selected' : ''}>Female</option>
                                    <option value="2" ${profile.gender == '2' ? 'selected' : ''}>Other</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="bio">Bio</label>
                            <textarea id="bio" name="bio" rows="4">${profile.bio}</textarea>
                        </div>

                        <button type="submit" class="save-btn">Save Changes</button>
                    </form>
                </div>
            </div>
        </main>

        <script>
            function previewAvatar(input) {
                if (input.files && input.files[0]) {
                    const file = input.files[0];

                    if (file.size > 5 * 1024 * 1024) {
                        alert('Image is too large! Please select an image smaller than 5MB.');
                        input.value = '';
                        return;
                    }
                    if (!file.type.startsWith('image/')) {
                        alert('Please select an image file!');
                        input.value = '';
                        return;
                    }

                    const reader = new FileReader();
                    reader.onload = function (e) {
                        document.getElementById('avatarPreview').src = e.target.result;
                    };
                    reader.readAsDataURL(file);
                }
            }
        </script>
    </body>
</html>