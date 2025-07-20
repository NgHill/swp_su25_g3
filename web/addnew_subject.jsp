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
            /* ==== Layout tổng thể ==== */
            body {
                font-family: Arial, sans-serif;
                padding: 30px;
                background-color: #f8f9fa;
            }

            h1 {
                margin-bottom: 20px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            label {
                font-weight: bold;
                display: block;
                margin-bottom: 5px;
            }

            input[type="text"],
            input[type="number"],
            select,
            textarea {
                width: 100%;
                padding: 8px;
                box-sizing: border-box;
            }

            /* ==== Chia 2 cột trái/phải ==== */
            .row {
                display: flex;
                gap: 20px;
            }

            .left-col {
                width: 30%;
            }

            .right-col {
                width: 70%;
            }

            /* ==== Hộp upload ảnh ==== */
            .image-box {
                border: 1px dashed #aaa;
                text-align: center;
                padding: 20px;
            }

            .image-box img {
                max-width: 100%;
                height: auto;
            }

            .note {
                color: red;
                font-size: 12px;
                margin-top: 5px;
            }

            /* ==== Công tắc bật tắt Featured ==== */
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
                transition: .4s;
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
                transition: .4s;
                border-radius: 50%;
            }

            input:checked + .slider {
                background-color: #007bff;
            }

            input:checked + .slider:before {
                transform: translateX(24px);
            }

            /* ==== Nút điều khiển cuối form ==== */
            .buttons {
                text-align: right;
                margin-top: 30px;
            }

            .buttons button {
                padding: 10px 20px;
                margin-left: 10px;
                border: 1px solid #ccc;
                background-color: white;
                cursor: pointer;
            }

            .buttons button[type="submit"] {
                background-color: #007bff;
                color: white;
            }
        </style>
    </head>
    <body>

        <!-- Form gửi dữ liệu bằng POST, hỗ trợ upload ảnh -->
        <form method="post" action="add-subject" enctype="multipart/form-data">

            <!-- Nút quay lại danh sách -->
            <button type="button" onclick="window.location.href = 'subject-list.jsp'">Back</button>

            <h1>Add New Subject</h1>

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
                <button type="button" onclick="window.location.href = 'subject-list.jsp'">Cancel</button>
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
