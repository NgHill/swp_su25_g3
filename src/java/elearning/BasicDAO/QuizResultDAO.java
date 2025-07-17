/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.QuizResult;
import java.sql.*;
import java.time.LocalDateTime;

public class QuizResultDAO {
    
    // Lưu kết quả quiz
    public boolean saveQuizResult(QuizResult result) {
        String sql = "INSERT INTO QuizResults (UserId, QuizId, Score, SubmittedAt) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, result.getUserId());
            ps.setInt(2, result.getQuizId());
            ps.setDouble(3, result.getScore());
            ps.setTimestamp(4, Timestamp.valueOf(result.getSubmittedAt()));
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Lấy kết quả quiz của user
    public QuizResult getQuizResult(int userId, int quizId) {
        QuizResult result = null;
        String sql = "SELECT * FROM QuizResults WHERE UserId = ? AND QuizId = ? ORDER BY SubmittedAt DESC LIMIT 1";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, quizId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                result = new QuizResult();
                result.setId(rs.getInt("Id"));
                result.setUserId(rs.getInt("UserId"));
                result.setQuizId(rs.getInt("QuizId"));
                result.setScore(rs.getDouble("Score"));
                result.setSubmittedAt(rs.getTimestamp("SubmittedAt").toLocalDateTime());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    // Kiểm tra user đã làm quiz chưa
    public boolean hasUserTakenQuiz(int userId, int quizId) {
        String sql = "SELECT COUNT(*) FROM QuizResults WHERE UserId = ? AND QuizId = ?";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, quizId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}