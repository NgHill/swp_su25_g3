package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.QuizResult;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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
    
    public int saveQuizResultWithId(QuizResult result) {
        String sql = "INSERT INTO QuizResults (UserId, QuizId, Score, SubmittedAt) VALUES (?, ?, ?, ?)";

        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, result.getUserId());
            ps.setInt(2, result.getQuizId());
            ps.setDouble(3, result.getScore());
            ps.setTimestamp(4, Timestamp.valueOf(result.getSubmittedAt()));

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    // Lấy kết quả quiz theo ID
    public QuizResult getQuizResultById(int resultId) {
        QuizResult result = null;
        String sql = "SELECT * FROM QuizResults WHERE Id = ?";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, resultId);
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
    
    // Lấy tất cả kết quả quiz của user
    public List<QuizResult> getAllQuizResults(int userId) {
        List<QuizResult> results = new ArrayList<>();
        String sql = "SELECT qr.*, q.Title as QuizTitle FROM QuizResults qr " +
                    "JOIN Quizzes q ON qr.QuizId = q.Id " +
                    "WHERE qr.UserId = ? ORDER BY qr.SubmittedAt DESC";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                QuizResult result = new QuizResult();
                result.setId(rs.getInt("Id"));
                result.setUserId(rs.getInt("UserId"));
                result.setQuizId(rs.getInt("QuizId"));
                result.setScore(rs.getDouble("Score"));
                result.setSubmittedAt(rs.getTimestamp("SubmittedAt").toLocalDateTime());
                // Có thể thêm quiz title nếu cần
                results.add(result);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }
    
    // Lấy tất cả kết quả quiz của một quiz cụ thể
    public List<QuizResult> getQuizResultsByQuizId(int quizId) {
        List<QuizResult> results = new ArrayList<>();
        String sql = "SELECT * FROM QuizResults WHERE QuizId = ? ORDER BY SubmittedAt DESC";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                QuizResult result = new QuizResult();
                result.setId(rs.getInt("Id"));
                result.setUserId(rs.getInt("UserId"));
                result.setQuizId(rs.getInt("QuizId"));
                result.setScore(rs.getDouble("Score"));
                result.setSubmittedAt(rs.getTimestamp("SubmittedAt").toLocalDateTime());
                results.add(result);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
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
    
    // Thêm method để lấy ID vừa insert
    public int getLastInsertId() {
        String sql = "SELECT LAST_INSERT_ID()";

        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    // Xóa kết quả quiz
    public boolean deleteQuizResult(int resultId) {
        String sql = "DELETE FROM QuizResults WHERE Id = ?";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, resultId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Lấy điểm cao nhất của user trong một quiz
    public double getHighestScore(int userId, int quizId) {
        String sql = "SELECT MAX(Score) FROM QuizResults WHERE UserId = ? AND QuizId = ?";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, quizId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}