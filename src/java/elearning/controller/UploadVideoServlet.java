// Khai báo package của servlet
package elearning.controller;

// Import các thư viện cần thiết
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

/**
 * Servlet dùng để xử lý upload video từ Froala Editor.
 */
@MultipartConfig // Cho phép servlet xử lý multipart/form-data (upload file)
public class UploadVideoServlet extends HttpServlet {

    /**
     * Mặc định nếu truy cập bằng phương thức GET, servlet sẽ trả về trang test
     * HTML đơn giản.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thiết lập kiểu nội dung trả về là HTML
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            // Trả về trang HTML mẫu
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UploadVideoServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UploadVideoServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    /**
     * Xử lý yêu cầu GET (ví dụ người dùng truy cập trực tiếp qua URL).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response); // Gọi method trả về HTML test
    }

    // Thư mục con nơi lưu video trong thư mục gốc của project
    private static final String UPLOAD_DIR = "uploads/videos";

    /**
     * Xử lý yêu cầu POST – nhận video từ client (Froala Editor), lưu và trả lại
     * đường dẫn JSON.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy phần video từ form với name="video"
        Part videoPart = request.getPart("video");

        // Lấy tên file gốc (ví dụ: video.mp4)
        String fileName = Paths.get(videoPart.getSubmittedFileName()).getFileName().toString();

        // Lấy đường dẫn gốc thực tế của webapp trên server
        String appPath = request.getServletContext().getRealPath("");

        // Gộp đường dẫn thư mục lưu video
        String savePath = appPath + File.separator + UPLOAD_DIR;

        // Tạo thư mục nếu chưa tồn tại
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Tạo tên file lưu mới để tránh trùng tên (thêm thời gian hiện tại)
        String savedFileName = System.currentTimeMillis() + "_" + fileName;

        // Tạo đường dẫn đến file đích sẽ lưu
        File file = new File(savePath + File.separator + savedFileName);

        // Đọc dữ liệu từ videoPart và ghi ra file
        try (InputStream input = videoPart.getInputStream()) {
            Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING); // Ghi đè nếu file đã tồn tại
        }

        // Tạo đường dẫn truy cập video (dùng cho Froala nhúng vào nội dung)
        String videoUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + savedFileName;

        // Thiết lập kiểu trả về là JSON
        response.setContentType("application/json");

        // Trả về chuỗi JSON chứa link video
        response.getWriter().write("{\"link\": \"" + videoUrl + "\"}");
    }

    /**
     * Mô tả ngắn về servlet này (không bắt buộc dùng).
     */
    @Override
    public String getServletInfo() {
        return "Servlet dùng để upload video từ Froala Editor và trả về link JSON.";
    }
}
