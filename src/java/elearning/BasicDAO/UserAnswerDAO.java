package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.UserAnswer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserAnswerDAO {
    
    public boolean saveUserAnswer(int userId, int quizId, int questionId, String answer, String imagePath, boolean isCorrect) {
    String sql = "INSERT INTO UserAnswer (UserId, QuizId, QuestionId, AnswerId, TextAnswer, ImagePath, IsCorrect, AnsweredAt) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
    
    try (Connection conn = ServerConnectionInfo.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, userId);
        ps.setInt(2, quizId);
        ps.setInt(3, questionId);
        
        // Kiểm tra nếu answer là số (multiple choice) hay text
        Integer answerId = null;
        String textAnswer = null;
        
        try {
            // Thử parse thành số (multiple choice)
            answerId = Integer.parseInt(answer);
            ps.setInt(4, answerId);
            ps.setNull(5, Types.VARCHAR);
        } catch (NumberFormatException e) {
            // Nếu không phải số thì là text input
            ps.setNull(4, Types.INTEGER);
            textAnswer = answer;
            ps.setString(5, textAnswer);
        }
        
        ps.setString(6, imagePath);
        ps.setBoolean(7, isCorrect);
        
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
    
    // Lấy tất cả câu trả lời của user cho một quiz
    public List<UserAnswer> getUserAnswersByQuiz(int userId, int quizId) {
        List<UserAnswer> userAnswers = new ArrayList<>();
        String sql = "SELECT * FROM UserAnswer WHERE UserId = ? AND QuizId = ? ORDER BY QuestionId";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, quizId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                UserAnswer userAnswer = new UserAnswer();
                userAnswer.setId(rs.getInt("Id"));
                userAnswer.setUserId(rs.getInt("UserId"));
                userAnswer.setQuizId(rs.getInt("QuizId"));
                userAnswer.setQuestionId(rs.getInt("QuestionId"));
                userAnswer.setAnswerId(rs.getInt("AnswerId"));
                userAnswer.setTextAnswer(rs.getString("TextAnswer"));
                userAnswer.setCorrect(rs.getBoolean("IsCorrect"));
                userAnswer.setImagePath(rs.getString("ImagePath"));
                userAnswer.setAnsweredAt(rs.getTimestamp("AnsweredAt"));
                
                userAnswers.add(userAnswer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userAnswers;
    }
    
    // Lấy câu trả lời của user cho một câu hỏi cụ thể
    public UserAnswer getUserAnswerByQuestion(int userId, int quizId, int questionId) {
        String sql = "SELECT * FROM UserAnswer WHERE UserId = ? AND QuizId = ? AND QuestionId = ?";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, quizId);
            ps.setInt(3, questionId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                UserAnswer userAnswer = new UserAnswer();
                userAnswer.setId(rs.getInt("Id"));
                userAnswer.setUserId(rs.getInt("UserId"));
                userAnswer.setQuizId(rs.getInt("QuizId"));
                userAnswer.setQuestionId(rs.getInt("QuestionId"));
                userAnswer.setAnswerId(rs.getInt("AnswerId"));
                userAnswer.setTextAnswer(rs.getString("TextAnswer"));
                userAnswer.setCorrect(rs.getBoolean("IsCorrect"));
                userAnswer.setImagePath(rs.getString("ImagePath"));
                userAnswer.setAnsweredAt(rs.getTimestamp("AnsweredAt"));
                
                return userAnswer;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean deleteAnswersByQuiz(int userId, int quizId) {
    String sql = "DELETE FROM UserAnswer WHERE UserId = ? AND QuizId = ?";
    try (Connection conn = ServerConnectionInfo.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, userId);
        ps.setInt(2, quizId);
        int affected = ps.executeUpdate();
        return affected > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
}