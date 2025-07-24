<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="elearning.entities.SubjectList" %>
<%
    SubjectList subject = (SubjectList) request.getAttribute("subject");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Subject</title>
    <script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
    <style>
        /* copy CSS từ form bạn đưa ở trên */
        body {
            font-family: Arial, sans-serif;
            padding: 30px;
            background-color: #fff;
        }
        h1 { font-size: 36px; margin-bottom: 30px; }
        .form-section { display: flex; gap: 40px; margin-bottom: 20px; }
        .thumbnail-box { width: 120px; }
        .thumbnail-preview {
            width: 100px;
            height: 100px;
            border: 2px dashed #aaa;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 12px;
            margin-bottom: 10px;
            overflow: hidden;
        }
        .upload-note { color: red; font-size: 12px; }
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 10px;
        }
        .form-group { display: flex; flex-direction: column; }
        label { font-weight: bold; margin-bottom: 5px; }
        input[type="text"], input[type="number"], select {
            padding: 6px;
            font-size: 14px;
            border: 1px solid #ccc;
            width: 100%;
        }
        select {
            appearance: none;
            background-image: url("data:image/svg+xml;utf8,<svg fill='black' height='18' viewBox='0 0 24 24' width='18' xmlns='http://www.w3.org/2000/svg'><path d='M7 10l5 5 5-5z'/></svg>");
            background-repeat: no-repeat;
            background-position: right 10px center;
            background-size: 14px;
        }
        .switch-wrapper { display: flex; align-items: center; gap: 10px; }
        .switch {
            position: relative;
            display: inline-block;
            width: 46px;
            height: 24px;
        }
        .switch input { opacity: 0; width: 0; height: 0; }
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: 0.4s;
            border-radius: 24px;
        }
        .slider:before {
            position: absolute;
            content: "";
            height: 18px;
            width: 18px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: 0.4s;
            border-radius: 50%;
        }
        .switch input:checked + .slider { background-color: #007bff; }
        .switch input:checked + .slider:before { transform: translateX(22px); }
        .description-label { font-weight: bold; margin: 20px 0 5px; }
        .form-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }
        .form-footer button {
            padding: 10px 20px;
            font-weight: bold;
            border: 1px solid #888;
            background-color: #eee;
            cursor: pointer;
        }
        .form-footer .save-btn { background-color: #ccc; }
    </style>
</head>
<body>
<form method="post" action="edit-subject" enctype="multipart/form-data">
    <input type="hidden" name="id" value="<%= subject.getId() %>">
    <input type="hidden" name="existingThumbnail" value="<%= subject.getThumbnailUrl() %>">

    <button type="button" onclick="window.location.href = 'subject-list2'">Back</button>
    <h1>Edit Subject</h1>

    <div class="form-section">
        <!-- Thumbnail -->
        <div class="thumbnail-box">
            <label>Thumbnail</label>
            <div class="thumbnail-preview" id="thumbnailPreview">
                <% if (subject.getThumbnailUrl() != null && !subject.getThumbnailUrl().isEmpty()) { %>
                    <img src="<%= subject.getThumbnailUrl() %>" style="width: 100px; height: 100px; object-fit: cover;" />
                <% } else { %>
                    Upload Image
                <% } %>
            </div>
            <input type="file" name="thumbnail" accept=".jpg,.jpeg,.png,.svg" onchange="previewImage(event)">
            <div class="upload-note">Images must be in JPEG (JPG), PNG, or SVG format.</div>
        </div>

        <!-- Form inputs -->
        <div style="flex: 1;">
            <div class="form-grid">
                <div class="form-group">
                    <label>Name</label>
                    <input type="text" name="name" value="<%= subject.getName() %>" required>
                </div>
                <div class="form-group">
                    <label>Category</label>
                    <select name="category" required>
                        <option value="">--Select--</option>
                        <option value="IT" <%= "IT".equals(subject.getCategory()) ? "selected" : "" %>>IT</option>
                        <option value="Business" <%= "Business".equals(subject.getCategory()) ? "selected" : "" %>>Business</option>
                        <option value="Design" <%= "Design".equals(subject.getCategory()) ? "selected" : "" %>>Design</option>
                        <option value="Language" <%= "Language".equals(subject.getCategory()) ? "selected" : "" %>>Language</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Number Of Lesson</label>
                    <input type="number" name="numberOfLesson" min="1" value="<%= subject.getLessons() %>" required>
                </div>
                <div class="form-group">
                    <label>Owner</label>
                    <input type="text" name="owner" value="<%= subject.getOwner() %>" required>
                </div>
                <div class="form-group">
                    <label>Display</label>
                    <select name="display">
                        <option value="Show" <%= "Show".equals(subject.getStatus()) ? "selected" : "" %>>Show</option>
                        <option value="Hide" <%= "Hide".equals(subject.getStatus()) ? "selected" : "" %>>Hide</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Featured Articles</label>
                    <div class="switch-wrapper">
                        <label class="switch">
                            <input type="checkbox" name="featured" <%= subject.isFeatured() ? "checked" : "" %>>
                            <span class="slider"></span>
                        </label>
                        <span style="font-weight: bold;">ON</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Description -->
    <div>
        <label class="description-label">Description</label>
        <textarea name="description" id="description"><%= subject.getDescription() %></textarea>
        <script>CKEDITOR.replace('description');</script>
    </div>

    <!-- Footer -->
    <div class="form-footer">
        <button type="button" ><a href="subject-list2">Cancel</a></button>
        <button type="submit" class="save-btn">Save</button>
    </div>
</form>

<script>
    function previewImage(event) {
        const reader = new FileReader();
        reader.onload = function () {
            document.getElementById('thumbnailPreview').innerHTML =
                `<img src="${reader.result}" style="width: 100px; height: 100px; object-fit: cover;" />`;
        };
        reader.readAsDataURL(event.target.files[0]);
    }
</script>
</body>
</html>