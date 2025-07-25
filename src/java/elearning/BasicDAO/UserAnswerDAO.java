package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import java.sql.*;

public class UserAnswerDAO {
    
    public boolean saveUserAnswer(int userId, int quizId, int questionId, String answer, String imagePath, boolean isCorrect) {
        String sql = "INSERT INTO UserAnswer (UserId, QuizId, QuestionId, TextAnswer, ImagePath, IsCorrect, AnsweredAt) VALUES (?, ?, ?, ?, ?, ?, NOW())";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, quizId);
            ps.setInt(3, questionId);
            ps.setString(4, answer);
            ps.setString(5, imagePath);
            ps.setBoolean(6, isCorrect);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}