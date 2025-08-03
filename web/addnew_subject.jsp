<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Add New Subject</title>
        <script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>

        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                padding: 40px;
                background-color: #f3e8ff;
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

            .price-error {
                color: red;
                font-size: 13px;
                margin-top: 5px;
            }

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

            .buttons a {
                color: inherit;
                text-decoration: none;
            }

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

        <form method="post" action="add-subject" enctype="multipart/form-data">

            <!-- Nút quay lại danh sách -->
            <button type="button" onclick="window.location.href = 'subject-list2'">Back</button>

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
                    <div class="form-group">
                        <label>Title</label>
                        <input type="text" name="title" required />
                    </div>

                    <div class="form-group">
                        <label>Category</label>
                        <select name="category">
                            <option value="" selected></option>
                            <c:forEach var="cat" items="${categoryList}">
                                <option value="${cat}">${cat}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Brief Info</label>
                        <input type="text" name="briefInfo" />
                    </div>

                    <div class="form-group">
                        <label>Owner</label>
                        <input type="text" name="owner" value="${sessionScope.userAuth.fullName}" readonly />
                    </div>

                    <div class="form-group">
                        <label>Tagline</label>
                        <input type="text" name="tagline" />
                    </div>
                </div>
            </div>

            <!-- Description -->
            <div class="form-group">
                <label>Description</label>
                <textarea name="description" id="description" rows="8"></textarea>
                <script>CKEDITOR.replace('description');</script>
            </div>

            <!-- Giá và Status -->
            <div class="row">
                <div class="form-group" style="flex:1;">
                    <label>Lowest Price</label>
                    <input type="text" name="lowestPrice" class="price-input" oninput="handlePriceInput(this, false)" />
                    <div class="price-error"></div>
                </div>
                <div class="form-group" style="flex:1;">
                    <label>Original Price <span style="color:red">*</span></label>
                    <input type="text" name="originalPrice" class="price-input" oninput="handlePriceInput(this, true)" />
                    <div class="price-error"></div>
                </div>
                <div class="form-group" style="flex:1;">
                    <label>Sale Price</label>
                    <input type="text" name="salePrice" class="price-input" oninput="handlePriceInput(this, false)" />
                    <div class="price-error"></div>
                </div>
                <div class="form-group" style="flex:1;">
                    <label>Status</label>
                    <select name="status">
                        <option value="published">Published</option>
                        <option value="un-published">Unpublished</option>
                    </select>
                </div>
            </div>

            <!-- Nút điều khiển -->
            <div class="buttons">
                <button type="button"><a href="subject-list2">Cancel</a></button>
                <button type="submit">Add</button>
            </div>
        </form>

        <script>
            function previewImage(event) {
                const reader = new FileReader();
                reader.onload = function () {
                    const output = document.getElementById('preview');
                    output.src = reader.result;
                };
                reader.readAsDataURL(event.target.files[0]);
            }

            function handlePriceInput(input, required) {
                const errorDiv = input.nextElementSibling;
                const raw = input.value.replace(/\./g, '').trim();

                if (required && raw === '') {
                    errorDiv.textContent = 'Không được để trống.';
                    return;
                }

                if (raw === '') {
                    errorDiv.textContent = '';
                    return;
                }

                if (!/^\d+$/.test(raw)) {
                    errorDiv.textContent = 'Chỉ được nhập số nguyên dương, không chứa chữ cái hoặc ký tự.';
                    return;
                }

                if (parseInt(raw) <= 0) {
                    errorDiv.textContent = 'Giá phải lớn hơn 0.';
                    return;
                }

                input.value = parseInt(raw, 10).toLocaleString('vi-VN');
                errorDiv.textContent = '';
            }

            function validateAndFormatPrices(event) {
                let valid = true;
                const inputs = document.querySelectorAll('.price-input');

                inputs.forEach(input => {
                    const required = input.name === "originalPrice";
                    const errorDiv = input.nextElementSibling;
                    const raw = input.value.replace(/\./g, '').trim();

                    if (required && raw === '') {
                        errorDiv.textContent = 'Không được để trống.';
                        input.focus();
                        valid = false;
                    } else if (raw !== '' && (!/^\d+$/.test(raw) || parseInt(raw) <= 0)) {
                        errorDiv.textContent = 'Giá không hợp lệ.';
                        input.focus();
                        valid = false;
                    } else {
                        errorDiv.textContent = '';
                        if (raw !== '') {
                            input.value = parseInt(raw, 10).toLocaleString('vi-VN');
                        }
                    }
                });

                if (!valid) {
                    event.preventDefault();
                }
            }

            document.querySelector("form").addEventListener("submit", validateAndFormatPrices);
        </script>
         <script>
        // Embed Java value into JavaScript
            const username = '<%= request.getAttribute("categoryList") %>';
        console.log("Username from Servlet:", username);
    </script>

    </body>
</html>
