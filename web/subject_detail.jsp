<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="elearning.entities.SubjectPackage" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    SubjectPackage subject = (SubjectPackage) request.getAttribute("subject");
    DecimalFormat df = new DecimalFormat("#,###");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Subject</title>
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

            .back-btn {
                display: inline-block;
                margin-bottom: 24px;
                padding: 10px 18px;
                background-color: #e0d4f7;
                color: #4b0082;
                font-weight: 600;
                text-decoration: none;
                border-radius: 8px;
                transition: background-color 0.3s ease;
                font-size: 14px;
            }

            .back-btn:hover {
                background-color: #d1b3ff;
            }
        </style>
    </head>
    <body>

        <form method="post" action="edit-subject" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<%= subject.getId() %>" />

            <a href="subject-list2" class="back-btn">← Back to Subject List</a>

            <h1>Edit Subject</h1>

            <div class="row">
                <div class="left-col">
                    <label>Thumbnail</label>
                    <div class="image-box">
                        <img id="preview" src="<%= subject.getThumbnail() != null ? "uploads/" + subject.getThumbnail() : "https://via.placeholder.com/120x120?text=Upload+Image" %>" alt="Preview" />
                        <br><br>
                        <input type="file" name="thumbnail" accept=".jpg,.jpeg,.png,.svg" onchange="previewImage(event)">
                    </div>
                    <div class="note">Image must be in JPEG (JPG), PNG, or SVG format.</div>
                </div>

                <div class="right-col">
                    <div class="form-group">
                        <label>Title</label>
                        <input type="text" name="title" required value="<%= subject.getTitle() %>" />
                    </div>

                    <div class="form-group">
                        <label>Category</label>
                        <select name="category">
                            <option value="" disabled>Select Category</option>
                            <c:forEach var="cat" items="${categoryList}">
                                <option value="${cat}" <c:if test="${subject.category == cat}">selected</c:if>>${cat}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Brief Info</label>
                        <input type="text" name="briefInfo" value="<%= subject.getBriefInfo() %>" />
                    </div>

                    <div class="form-group">
                        <label>Owner</label>
                        <input type="text" name="owner" value="${sessionScope.userAuth.fullName}" readonly />
                    </div>

                    <div class="form-group">
                        <label>Tagline</label>
                        <input type="text" name="tagline" value="<%= subject.getTagLine() %>" />
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label>Description</label>
                <textarea name="description" id="description" rows="8"><%= subject.getDescription() %></textarea>
                <script>CKEDITOR.replace('description');</script>
            </div>

            <div class="row">
                <div class="form-group" style="flex:1;">
                    <label>Lowest Price</label>
                    <input type="text" name="lowestPrice" class="price-input" value="<%= df.format(subject.getLowestPrice()) %>" oninput="handlePriceInput(this, false)" />
                    <div class="price-error"></div>
                </div>
                <div class="form-group" style="flex:1;">
                    <label>Original Price <span style="color:red">*</span></label>
                    <input type="text" name="originalPrice" class="price-input" value="<%= df.format(subject.getOriginalPrice()) %>" oninput="handlePriceInput(this, true)" />
                    <div class="price-error"></div>
                </div>
                <div class="form-group" style="flex:1;">
                    <label>Sale Price</label>
                    <input type="text" name="salePrice" class="price-input" value="<%= df.format(subject.getSalePrice()) %>" oninput="handlePriceInput(this, false)" />
                    <div class="price-error"></div>
                </div>
                <div class="form-group" style="flex:1;">
                    <label>Status</label>
                    <select name="status">
                        <option value="published" <%= "published".equals(subject.getStatus()) ? "selected" : "" %>>Published</option>
                        <option value="un-published" <%= "un-published".equals(subject.getStatus()) ? "selected" : "" %>>Unpublished</option>
                    </select>
                </div>
            </div>

            <div class="buttons">
                <button type="button" onclick="confirmDelete()">Delete</button>
                <button type="submit">Update</button>
            </div>
        </form>

        <!-- Modal xác nhận xóa -->
        <div id="deleteModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%;
             background-color:rgba(0,0,0,0.5); z-index:1000; justify-content:center; align-items:center;">
            <div style="background:white; padding:30px; border-radius:12px; max-width:400px; text-align:center;">
                <p style="font-size:16px; margin-bottom:24px;">Bạn có chắc muốn xóa subject này?</p>
                <button onclick="deleteConfirmed()" style="background:#c62828; color:white; padding:10px 20px; border:none; border-radius:8px; font-weight:600; margin-right:12px;">Yes</button>
                <button onclick="closeModal()" style="background:#ccc; padding:10px 20px; border:none; border-radius:8px; font-weight:600;">No</button>
            </div>
        </div>

        <script>
            function previewImage(event) {
                const reader = new FileReader();
                reader.onload = function () {
                    const output = document.getElementById('preview');
                    output.src = reader.result;
                };
                reader.readAsDataURL(event.target.files[0]);
            }

            function confirmDelete() {
                document.getElementById('deleteModal').style.display = 'flex';
            }

            function closeModal() {
                document.getElementById('deleteModal').style.display = 'none';
            }

            function deleteConfirmed() {
                const id = '<%= subject.getId() %>';
                window.location.href = 'delete-subject?id=' + id;
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
                    errorDiv.textContent = 'Chỉ được nhập số nguyên dương.';
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

    </body>
</html>
