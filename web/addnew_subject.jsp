<%-- 
    Document   : addnew_subject
    Created on : Jun 29, 2025, 10:08:18 PM
    Author     : admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Add New Subject</title>

        <!-- Tích hợp Rich Text Editor -->
        <script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>

        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                padding: 40px;
                background-color: #f3e8ff; /* tím nhạt */
                color: #333;
            }

            h1 {
                font-size: 28px;
                margin-bottom: 25px;
                color: #5a189a;
            }

            form {
                background: #fff;
                padding: 30px;
                border-radius: 16px;
                box-shadow: 0 4px 20px rgba(90, 24, 154, 0.1);
            }

            /* ==== Cột trái/phải ==== */
            .row {
                display: flex;
                gap: 24px;
                flex-wrap: wrap;
            }

            .left-col {
                flex: 1;
                min-width: 260px;
            }

            .right-col {
                flex: 2;
                min-width: 300px;
            }

            /* ==== Upload ảnh ==== */
            .image-box {
                border: 2px dashed #ccc;
                border-radius: 10px;
                text-align: center;
                padding: 20px;
                background-color: #faf5ff;
            }

            .image-box img {
                max-width: 120px;
                height: auto;
                margin-bottom: 12px;
                border-radius: 8px;
            }

            .note {
                color: #c62828;
                font-size: 13px;
                margin-top: 6px;
            }

            /* ==== Trường nhập liệu ==== */
            .form-group {
                margin-bottom: 20px;
            }

            label {
                font-weight: 600;
                display: block;
                margin-bottom: 6px;
                color: #4b0082;
            }

            input[type="text"],
            input[type="number"],
            select,
            textarea {
                width: 100%;
                padding: 10px 14px;
                border-radius: 8px;
                border: 1px solid #ccc;
                font-size: 14px;
                outline: none;
            }

            input[type="file"] {
                font-size: 13px;
                margin-top: 6px;
            }

            select {
                background-color: #fff;
            }

            /* ==== Toggle switch ==== */
            .switch {
                position: relative;
                display: inline-block;
                width: 50px;
                height: 25px;
            }

            .switch input {
                opacity: 0;
                width: 0;
                height: 0;
            }

            .slider {
                position: absolute;
                cursor: pointer;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: #ccc;
                transition: 0.4s;
                border-radius: 25px;
            }

            .slider:before {
                position: absolute;
                content: "";
                height: 19px;
                width: 19px;
                left: 3px;
                bottom: 3px;
                background-color: white;
                transition: 0.4s;
                border-radius: 50%;
            }

            input:checked + .slider {
                background-color: #7b2cbf;
            }

            input:checked + .slider:before {
                transform: translateX(24px);
            }

            /* ==== Nút điều khiển ==== */
            .buttons {
                text-align: right;
                margin-top: 30px;
            }

            .buttons button {
                padding: 10px 20px;
                margin-left: 10px;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .buttons button[type="submit"] {
                background-color: #7b2cbf;
                color: white;
            }

            .buttons button[type="submit"]:hover {
                background-color: #5a189a;
            }

            .buttons button[type="button"] {
                background-color: #e0d4f7;
                color: #4b0082;
            }

            .buttons button[type="button"]:hover {
                background-color: #d1b3ff;
            }

            /* Cancel button a inside */
            .buttons a {
                color: inherit;
                text-decoration: none;
            }

            /* Back button */
            button[type="button"]:first-child {
                margin-bottom: 25px;
                padding: 10px 16px;
                background-color: #e0d4f7;
                border: none;
                border-radius: 8px;
                color: #4b0082;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.3s ease;
            }

            button[type="button"]:first-child:hover {
                background-color: #d1b3ff;
            }
        </style>

    </head>
    <body>

        <!-- Form gửi dữ liệu bằng POST, hỗ trợ upload ảnh -->
        <form method="post" action="add-subject" enctype="multipart/form-data">

            <!-- Nút quay lại danh sách -->
            <button type="button" onclick="window.location.href = 'subject-list2'">Back</button>

            <h1>Add New Subject</h1>
            k
            <div class="row">
                <!-- Cột trái: Upload thumbnail -->
                <div class="left-col">
                    <label>Thumbnail</label>
                    <div class="image-box">
                        <img id="preview" src="https://via.placeholder.com/120x120?text=Upload+Image" alt="Preview" />
                        <br><br>
                        <input type="file" name="thumbnail" accept=".jpg,.jpeg,.png,.svg" onchange="previewImage(event)">
                    </div>
                    <div class="note">Image must be in JPEG (JPG), PNG, or SVG format.</div>
                </div>

                <!-- Cột phải: Các trường input -->
                <div class="right-col">
                    <!-- Nhập tên subject -->
                    <div class="form-group">
                        <label>Name</label>
                        <input type="text" name="name" required />
                    </div>

                    <!-- Nhập category và số bài học -->
                    <div class="row">
                        <div class="form-group" style="flex: 1;">
                            <label>Category</label>
                            <select name="category" required>
                                <option value="">--Select--</option>
                                <option value="IT">IT</option>
                                <option value="Business">Business</option>
                                <option value="Design">Design</option>
                                <option value="Language">Language</option>
                            </select>
                        </div>
                        <div class="form-group" style="flex: 1;">
                            <label>Number Of Lesson</label>
                            <input type="number" name="numberOfLesson" min="1" required />
                        </div>
                    </div>

                    <!-- Công tắc bật/tắt Featured -->
                    <div class="form-group">
                        <label>Featured Articles</label>
                        <label class="switch">
                            <input type="checkbox" name="featured" checked>
                            <span class="slider"></span>
                        </label>
                    </div>

                    <!-- Nhập owner -->
                    <div class="form-group">
                        <label>Owner</label>
                        <input type="text" name="owner" required />
                    </div>
                </div>
            </div>

            <!-- Mô tả chi tiết subject -->
            <div class="form-group">
                <label>Description</label>
                <textarea name="description" id="description" rows="8"></textarea>
                <script>CKEDITOR.replace('description');</script>
            </div>

            <!-- Nút Cancel / Add -->
            <div class="buttons">
                <button type="button"><a href="subject-list2">Cancel</a></button>
                <button type="submit">Add</button>
            </div>

        </form>

        <!-- Xử lý hiển thị ảnh preview -->
        <script>
            function previewImage(event) {
                const reader = new FileReader();
                reader.onload = function () {
                    const output = document.getElementById('preview');
                    output.src = reader.result;
                };
                reader.readAsDataURL(event.target.files[0]);
            }
        </script>

    </body>
</html>
