<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Post Detail</title>

        <!-- Thư viện Froala Editor để soạn thảo nội dung mô tả bài viết -->
        <link href="https://cdn.jsdelivr.net/npm/froala-editor@4.0.19/css/froala_editor.pkgd.min.css" rel="stylesheet" type="text/css" />

        <!-- Thư viện Bootstrap để tạo layout và giao diện đẹp -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />

        <style>
            body {
                background-color: #f3e8ff; /* tím nhạt */
                padding: 30px;
                font-family: 'Segoe UI', sans-serif;
                font-size: 16px;
                color: #333;
            }

            h2 {
                font-weight: 700;
                font-size: 32px;
                color: #5a189a; /* đậm hơn nền */
                margin-bottom: 25px;
            }

            label {
                font-weight: 600;
                margin-bottom: 6px;
                color: #4b0082;
            }

            .form-control,
            .form-select {
                border-radius: 8px;
                border: 1px solid #ccc;
                padding: 10px;
                box-shadow: none;
                transition: border 0.3s ease;
            }

            .form-control:focus,
            .form-select:focus {
                border-color: #9d4edd;
                outline: none;
                box-shadow: 0 0 0 3px rgba(157, 78, 221, 0.2);
            }

            .form-section {
                background-color: #fff;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 25px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            }

            .thumbnail-box {
                width: 140px;
                height: 140px;
                border: 2px dashed #aaa;
                border-radius: 8px;
                background-color: #fafafa;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 13px;
                margin-bottom: 10px;
                color: #777;
            }

            .btn {
                border-radius: 8px;
                padding: 8px 16px;
                font-weight: 500;
            }

            .btn-outline-dark {
                border-color: #6c757d;
                color: #6c757d;
            }

            .btn-outline-dark:hover {
                background-color: #6c757d;
                color: white;
            }

            .btn-primary {
                background-color: #7b2cbf;
                border-color: #7b2cbf;
            }

            .btn-primary:hover {
                background-color: #5a189a;
                border-color: #5a189a;
            }

            .form-footer {
                display: flex;
                justify-content: space-between;
                align-items: end;
                flex-wrap: wrap;
                gap: 20px;
                background-color: #fff;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            }

            .form-footer .right .btn {
                width: 110px;
            }

            .form-check-input:checked {
                background-color: #9d4edd;
                border-color: #9d4edd;
            }

            .form-check-label {
                color: #4b0082;
            }

            select option {
                background: #fff;
            }
            /* Nút Back */
            .btn-back {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 8px 16px;
                border: 2px solid #9d4edd;
                background-color: #f3e8ff;
                color: #6a1b9a;
                font-weight: 500;
                font-size: 15px;
                border-radius: 8px;
                transition: all 0.3s ease;
                text-decoration: none;
            }

            .btn-back:hover {
                background-color: #9d4edd;
                color: #fff;
                border-color: #7b2cbf;
                text-decoration: none;
            }

            .btn-back svg {
                width: 18px;
                height: 18px;
                stroke-width: 2;
            }

        </style>

    </head>

    <body>

        <!-- Nút quay lại trang trước -->
        <button class="btn-back mb-3" onclick="history.back()">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
            </svg>
            Back
        </button>


        <!-- Tiêu đề form -->
        <h2 class="mb-4">Post Detail</h2>

        <!-- Form gửi dữ liệu bài viết lên server -->
        <form method="post" action="post-detail" enctype="multipart/form-data">

            <!-- Phần đầu của form: thumbnail + các trường thông tin -->
            <div class="d-flex gap-4 align-items-start form-section">

                <!-- Upload ảnh thumbnail -->
                <div class="flex-shrink-0" style="width: 150px;">
                    <label>Thumbnail</label>
                    <div class="thumbnail-box">Upload Image</div>
                    <input type="file" name="image" class="form-control mb-1" accept=".jpg,.jpeg,.png,.svg">
                    <small class="text-danger">JPEG / PNG / SVG only.</small>
                </div>

                <!-- Thông tin bài viết -->
                <div class="flex-grow-1 w-100">
                    <div class="mb-3">
                        <label>Title</label>
                        <input type="text" class="form-control" name="title" required>
                    </div>

                    <div class="row g-3">
                        <!-- Chọn danh mục -->
                        <div class="mb-3">
                            <label for="category" class="form-label">Category</label>
                            <select id="category" name="category" class="form-select">
                                <!-- Duyệt qua danh sách categories và hiển thị từng option -->
                                <c:forEach var="cate" items="${categories}">
                                    <option value="${cate}">${cate}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Tác giả -->
                        <div class="col-md-6">
                            <label>Author</label>
                            <input type="text" value="${sessionScope.userAuth.fullName}" class="form-control" disabled="true">
                        </div>

                        <!-- Ngày viết -->
                        <div class="col-md-6">
                            <label>Date</label>
                            <input type="date" name="date" class="form-control" required>
                        </div>


                    </div>
                </div>
            </div>

            <!-- Mô tả ngắn gọn -->
            <div class="form-section">
                <label>Brief Information</label>
                <textarea name="content" class="form-control" rows="2"></textarea>
            </div>

            <!-- Mô tả chi tiết -->
            <div class="form-section">
                <label>Description</label>
                <textarea id="editor" name="description"></textarea>
            </div>

            <!-- Footer của form: trạng thái, nổi bật, nút lưu/hủy -->
            <div class="form-footer mt-4">
                <div class="left">
                    <!-- Trạng thái bài viết -->
                    <div>
                        <label>Status</label>
                        <select name="status" class="form-select">
                            <option value="published">Published</option>
                            <option value="archived">Archived</option>
                            <option value="draft">Draft</option>
                        </select>
                    </div>

                    <!-- Checkbox đánh dấu featured -->
                    <div class="form-check form-switch ms-4 mt-4">
                        <input class="form-check-input" type="checkbox" id="featured" name="featured" checked>
                        <label class="form-check-label" for="featured">Featured</label>
                    </div>
                </div>

                <!-- Nút Cancel và Save -->
                <div class="right">
                    <a href="mtk_dashboard" class="btn btn-outline-dark">Cancel</a>
                    <button type="submit" class="btn btn-primary">Save</button>
                </div>
            </div>
        </form>

        <!-- Script khởi tạo Froala Editor cho phần mô tả chi tiết -->
        <script src="https://cdn.jsdelivr.net/npm/froala-editor@4.0.19/js/froala_editor.pkgd.min.js"></script>
        <script>
            new FroalaEditor('#editor', {
                videoUpload: true,
                videoUploadURL: 'upload-video', // Đường dẫn xử lý upload video
                videoUploadParam: 'video',
                videoMaxSize: 50 * 1024 * 1024, // Tối đa 50MB
                videoAllowedTypes: ['webm', 'mp4', 'ogg'] // Các định dạng cho phép
            });
        </script>

    </body>
</html>
