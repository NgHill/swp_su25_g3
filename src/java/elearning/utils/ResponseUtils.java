/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elearning.utils;

import com.google.gson.JsonObject;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

/**
 *
 * @author admin
 */
public class ResponseUtils {
    
    public static void sendJsonResponse(HttpServletResponse response, JsonObject jsonObject) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        
        PrintWriter out = response.getWriter();
        out.print(jsonObject.toString());
        out.flush();
    }
    
    public static void sendErrorResponse(HttpServletResponse response, int statusCode, String message) throws IOException {
        response.setStatus(statusCode);
        JsonObject errorResponse = new JsonObject();
        errorResponse.addProperty("success", false);
        errorResponse.addProperty("message", message);
        sendJsonResponse(response, errorResponse);
    }
    
    public static void sendSuccessResponse(HttpServletResponse response, String message) throws IOException {
        JsonObject successResponse = new JsonObject();
        successResponse.addProperty("success", true);
        successResponse.addProperty("message", message);
        sendJsonResponse(response, successResponse);
    }
    
    public static void sendSuccessResponse(HttpServletResponse response, String message, Object data) throws IOException {
        JsonObject successResponse = new JsonObject();
        successResponse.addProperty("success", true);
        successResponse.addProperty("message", message);
        // Note: You'll need to convert data to JsonElement using Gson
        sendJsonResponse(response, successResponse);
    }
    
    public static String getRequestBody(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        return sb.toString();
    }
}
