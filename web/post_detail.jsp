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
            /* Các quy tắc CSS để định dạng giao diện của form Post Detail */
            body {
                padding: 25px;
                font-family: Arial, sans-serif;
                font-size: 16px;
            }

            h2 {
                font-weight: bold;
                font-size: 28px;
            }

            label {
                font-weight: 600;
                margin-bottom: 5px;
            }

            .form-section {
                margin-bottom: 20px;
            }

            .thumbnail-box {
                width: 140px;
                height: 140px;
                border: 1px solid #ccc;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 13px;
                margin-bottom: 10px;
            }

            .form-footer {
                display: flex;
                justify-content: space-between;
                align-items: end;
                flex-wrap: wrap;
                gap: 15px;
            }

            .form-footer .right .btn {
                width: 100px;
            }
        </style>
    </head>

    <body>

        <!-- Nút quay lại trang trước -->
        <button class="btn btn-outline-dark mb-3" onclick="history.back()">← Back</button>

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
                    <input type="file" name="thumbnail" class="form-control mb-1" accept=".jpg,.jpeg,.png,.svg">
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

                        <!-- Link bài viết -->
                        <div class="col-md-6">
                            <label>Link</label>
                            <input type="url" name="link" class="form-control">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Mô tả ngắn gọn -->
            <div class="form-section">
                <label>Brief Information</label>
                <textarea name="briefInfo" class="form-control" rows="2"></textarea>
            </div>

            <!-- Mô tả chi tiết -->
            <div class="form-section">
                <label>Description</label>
                <textarea id="editor" name="content"></textarea>
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
