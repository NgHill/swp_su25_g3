package elearning.controller;

// Import các thư viện Servlet cần thiết
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

// Lớp Servlet xử lý yêu cầu gửi đến API Together.ai
public class TogetherAIServlet extends HttpServlet {

    // Khóa API để xác thực với Together.ai (nên bảo mật, không public)
    private static final String API_KEY = "184e918a08df60dffa16327a2ec540dd7a987056e227b7f3de3663123f4ad5c9";

    // URL endpoint của API Together.ai
    private static final String API_URL = "https://api.together.xyz/v1/chat/completions";

    /**
     * Xử lý request POST từ client (trình duyệt web)
     * Nhận message từ người dùng, gửi đến AI, rồi trả phản hồi về dưới dạng JSON
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy nội dung người dùng nhập từ request (parameter "message")
        String userMessage = request.getParameter("message");

        // Gửi nội dung này đến Together.ai và nhận kết quả
        String aiResponse = getAIResponse(userMessage);

        // Trả kết quả về cho client dưới dạng JSON (hỗ trợ tiếng Việt)
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(aiResponse);
    }

    /**
     * Gửi câu hỏi đến Together.ai và nhận phản hồi
     */
    private String getAIResponse(String userMessage) throws IOException {
        // Tạo đối tượng URL từ đường dẫn API
        URL url = new URL(API_URL);

        // Mở kết nối HTTP đến API
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        // Cấu hình request:
        conn.setRequestMethod("POST"); // Gửi theo phương thức POST
        conn.setRequestProperty("Authorization", "Bearer " + API_KEY); // Gửi API Key
        conn.setRequestProperty("Content-Type", "application/json");   // Gửi dữ liệu kiểu JSON
        conn.setDoOutput(true); // Cho phép ghi dữ liệu vào body của request

        // Tạo nội dung JSON gửi đi, bao gồm:
        // - model: tên mô hình AI
        // - messages: gồm 1 role "system" (thiết lập AI) và 1 role "user" (câu hỏi)
        // - temperature: mức độ sáng tạo của phản hồi
        String requestBody = """
        {
          "model": "meta-llama/Llama-Vision-Free",
          "messages": [
            {
              "role": "system",
              "content": "Bạn là trợ lý tư vấn khóa học. Hãy chắc chắn luôn sử dụng tiếng Việt để trả lời, nội dung ngắn gọn dễ hiểu. Không cần phải có bản tiếng Anh. Làm ngắn gọn nội dung lại"
            },
            {
              "role": "user",
              "content": "%s"
            }
          ],
          "temperature": 0.9
        }
        """.formatted(escapeJson(userMessage)); // escape dữ liệu để tránh lỗi ký tự

        // Gửi nội dung JSON vào luồng output của HTTP connection
        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = requestBody.getBytes("utf-8"); // chuyển thành byte
            os.write(input, 0, input.length);             // ghi toàn bộ dữ liệu vào request
        }

        // Nhận mã phản hồi HTTP từ API (200 = OK)
        int status = conn.getResponseCode();

        // Nếu phản hồi thành công (2xx) thì đọc từ getInputStream
        // Nếu thất bại thì đọc từ getErrorStream để biết lỗi
        InputStream is = (status >= 200 && status < 300)
                ? conn.getInputStream()
                : conn.getErrorStream();

        // Đọc dữ liệu phản hồi từng dòng, ghép thành chuỗi
        BufferedReader reader = new BufferedReader(new InputStreamReader(is, "utf-8"));
        StringBuilder responseStr = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            responseStr.append(line);
        }

        // Trả chuỗi phản hồi JSON về cho servlet gọi
        return responseStr.toString();
    }
    //note: Sau khi gửi POST request,nhận lại InputStream từ phản hồi.
    //dùng InputStreamReader với UTF-8 để đảm bảo đọc đúng tiếng Việt, rồi bọc nó bằng BufferedReader để đọc từng dòng. 
    //Mỗi dòng được nối lại vào StringBuilder, cuối cùng thu được chuỗi JSON trả về từ Together.ai.
    
    /*
      Hàm hỗ trợ để xử lý các ký tự đặc biệt trong chuỗi JSON
      Tránh lỗi khi người dùng nhập dấu " hoặc xuống dòng
     */
    private String escapeJson(String text) {
        if (text == null) {
            return "";
        }
        return text.replace("\\", "\\\\")   // escape dấu \
                   .replace("\"", "\\\"")   // escape dấu "
                   .replace("\n", "\\n")    // xuống dòng
                   .replace("\r", "\\r")    // xuống dòng hệ điều hành cũ
                   .replace("\t", "\\t");   // tab
    }
}
