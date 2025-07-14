package elearning.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

public class TogetherAIServlet extends HttpServlet {

    private static final String API_KEY = "184e918a08df60dffa16327a2ec540dd7a987056e227b7f3de3663123f4ad5c9";
    private static final String API_URL = "https://api.together.xyz/v1/chat/completions";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userMessage = request.getParameter("message");

        // Gửi yêu cầu đến Together.ai
        String aiResponse = getAIResponse(userMessage);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(aiResponse);
    }

    private String getAIResponse(String userMessage) throws IOException {
        URL url = new URL(API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        // Cấu hình request
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Bearer " + API_KEY);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        // Nội dung JSON gửi đi
        String requestBody = """
        {
          "model": "meta-llama/Llama-Vision-Free",
          "messages": [
            {"role": "system", "content": "Bạn là trợ lý tư vấn khóa học.Hãy chắc chắn luôn sử dụng tiếng Việt để trả lời, nội dung ngắn gọn dễ hiểu. Không cần phải có bản tiếng Anh. Làm ngắn gọn nội dung lại"},
            {"role": "user", "content": "%s"}
          ],
          "temperature": 0.7
        }
        """.formatted(escapeJson(userMessage));

        // Gửi request
        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = requestBody.getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        // Nhận phản hồi
        int status = conn.getResponseCode();
        InputStream is = (status >= 200 && status < 300) ? conn.getInputStream() : conn.getErrorStream();

        BufferedReader reader = new BufferedReader(new InputStreamReader(is, "utf-8"));
        StringBuilder responseStr = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            responseStr.append(line);
        }

        return responseStr.toString();
    }

    private String escapeJson(String text) {
        if (text == null) {
            return "";
        }
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
