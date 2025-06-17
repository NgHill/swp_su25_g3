<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">    
    <title>Profile</title>
    <style>
        /* RESET & BODY LAYOUT */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, sans-serif;
    background-color: #f0f0f0;
    display: flex;
    min-height: 100vh;
}

/* SIDEBAR */
.sidebar {
    width: 200px;
    background-color: #34495e;
    color: white;
    padding: 20px;
    min-height: 100vh;
    position: fixed;
    left: 0;
    top: 0;
    transition: transform 0.3s ease-in-out;
}

.sidebar.hidden {
    transform: translateX(-100%);
}

.sidebar ul {
    list-style: none;
}

.sidebar ul li {
    margin: 20px 0;
}

.sidebar ul li a {
    color: white;
    text-decoration: none;
    font-size: 16px;
    display: block;
    padding: 10px 0;
}

.sidebar ul li a:hover {
    color: #bdc3c7;
}

/* MAIN CONTENT */
main {
    flex: 1;
    margin-left: 200px;
    transition: margin-left 0.3s ease-in-out;
    display: flex;
    flex-direction: column;
}

.sidebar.hidden + main {
    margin-left: 0;
}

/* HEADER */
header {
    position: relative;
    background-color: #277AB0;
    color: white;
    padding: 15px 20px;
    height: 60px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

#toggleSidebar {
    position: absolute;
    left: 20px;
    top: 50%;
    transform: translateY(-50%);
    background-color: #34495e;
    color: white;
    padding: 8px 12px;
    border-radius: 4px;
    text-decoration: none;
    font-weight: 500;
}

#toggleSidebar:hover {
    background-color: #2c3e50;
    transform: translateY(-50%) scale(1.05);
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.header-title {
    text-align: center;
    font-size: 24px;
    font-weight: bold;
    line-height: 60px;
}

/* PROFILE CONTENT */
.profile-content {
    flex: 1;
    background-color: #e8e8e8;
    padding: 40px;
    display: flex;
    justify-content: center;
    align-items: flex-start;
    min-height: calc(100vh - 70px);
}

.profile-container {
    width: 100%;
    max-width: 500px;
    padding: 20px;
    background-color: #e8e8e8;
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

.form-group input:disabled {
    background-color: #ecf0f1;
    color: #7f8c8d;
}

.form-group textarea {
    resize: vertical;
    min-height: 80px;
}

/* BUTTON */
.save-btn {
    align-self: center;
    padding: 12px 30px;
    background-color: #95a5a6;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 16px;
    margin-top: 20px;
}

.save-btn:hover {
    background-color: #7f8c8d;
}

/* AVATAR SECTION */
.avatar-section {
    text-align: center;
    margin-bottom: 30px;
}

.avatar-container {
    position: relative;
    display: inline-block;
    margin-bottom: 15px;
}

.avatar {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    object-fit: cover;
    border: 3px solid #3498db;
    cursor: pointer;
    transition: all 0.3s ease;
}

.avatar:hover {
    transform: scale(1.05);
    border-color: #2980b9;
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

.avatar-wrapper {
    width: 60px;
    height: 60px;
    background-color: #95a5a6;
    border-radius: 50%;
    margin: 0 auto 30px;
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: pointer;
}

.avatar-img {
    width: 30px;
    height: 30px;
    border-radius: 50%;
    object-fit: cover;
}

/* MESSAGE NOTIFICATION */
.message.success {
    background-color: #d4edda;
    color: #155724;
    border-left: 5px solid #28a745;
    padding: 10px;
    margin-top: 15px;
    border-radius: 4px;
}

.message.error {
    background-color: #f8d7da;
    color: #721c24;
    border-left: 5px solid #dc3545;
    padding: 10px;
    margin-top: 15px;
    border-radius: 4px;
}

/* RESPONSIVE */
@media (max-width: 768px) {
    .sidebar {
        width: 100%;
        transform: translateX(-100%);
    }

    main {
        margin-left: 0;
    }

    .row {
        flex-direction: column;
        gap: 15px;
    }
}
   </style>
</head>
<body>
    <!-- Sidebar -->
    <nav class="sidebar" id="sidebar">
        <a href="<%= request.getContextPath() %>/profile">
            <div class="avatar-wrapper">
                <div class="avatar-img">👤</div>
            </div>
        </a>
        <ul>
            <li><a href="<%= request.getContextPath() %>/home">Home</a></li>
            <li><a href="<%= request.getContextPath() %>/subject">Subject</a></li>
            <li><a href="<%= request.getContextPath() %>/myRegistration">My Registrations</a></li>
            <li><a href="<%= request.getContextPath() %>/settings">Setting</a></li>
        </ul>
    </nav>

    <main>
        <!-- Header -->
        <header>
            <a href="#" id="toggleSidebar">☰ Toggle Sidebar</a>
            <h1 class="header-title">Profile</h1>
        </header>

        <!-- Profile Content -->
        <div class="profile-content">
            <div class="profile-container">
                <!-- File ảnh được đặt ngoài form -->
                <input type="file" id="avatarInput" class="avatar-input" accept="image/*" onchange="previewAvatar(this)">
                
                <form class="profile-form" method="post" action="<%= request.getContextPath() %>/profile">
                    <div class="avatar-section">
                        <div class="avatar-container">
                            <img src="https://images.unsplash.com/photo-1494790108755-2616c96d5b1e?w=150&h=150&fit=crop&crop=face" 
                                 alt="Profile Avatar" class="avatar" id="avatarPreview">
                            <div class="avatar-overlay" onclick="document.getElementById('avatarInput').click()">
                                <span>Change<br>Photo</span>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="form-group">
                            <label for="fullName">Full Name</label>
                            <input type="text" id="fullName" name="fullName" value="${profile.fullName}" required>
                            <c:if test="${not empty errors.fullNameError}">
                                <div style="color: red;">${errors.fullNameError}</div>
                            </c:if>
                        </div>           
                    </div>

                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" value="${profile.email}" readonly>
                    </div>

                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" value="${profile.username}" required>
                        <c:if test="${not empty errors && not empty errors.usernameError}">
                            <div style="color: red;">${errors.usernameError}</div>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="mobile">Phone Number</label>
                        <input type="text" id="mobile" name="mobile" value="${profile.mobile}"required>
                        <c:if test="${not empty errors.mobileError}">
                            <div style="color: red;">${errors.mobileError}</div>
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

                    <c:if test="${not empty message}">
                        <div style="color: green;">
                            ${message}
                            <button type="button" class="close-btn" onclick="this.parentElement.style.display='none';">×</button>
                        </div>
                    </c:if>
                    
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
                    alert('Ảnh quá lớn! Vui lòng chọn ảnh nhỏ hơn 5MB.');
                    input.value = '';
                    return;
                }

                if (!file.type.startsWith('image/')) {
                    alert('Vui lòng chọn file ảnh!');
                    input.value = '';
                    return;
                }

                const reader = new FileReader();
                reader.onload = function(e) {
                    const img = new Image();
                    img.onload = function() {
                        const canvas = document.createElement('canvas');
                        const ctx = canvas.getContext('2d');
                        const maxSize = 300;
                        let { width, height } = img;

                        if (width > height) {
                            if (width > maxSize) {
                                height = (height * maxSize) / width;
                                width = maxSize;
                            }
                        } else {
                            if (height > maxSize) {
                                width = (width * maxSize) / height;
                                height = maxSize;
                            }
                        }

                        canvas.width = width;
                        canvas.height = height;
                        ctx.drawImage(img, 0, 0, width, height);
                        const resizedDataUrl = canvas.toDataURL('image/jpeg', 0.8);
                        document.getElementById('avatarPreview').src = resizedDataUrl;
                    };
                    img.src = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        }

        document.getElementById("toggleSidebar").addEventListener("click", function (e) {
            e.preventDefault();
            document.querySelector(".sidebar").classList.toggle("hidden");
        });
    </script>
</body>
</html>
