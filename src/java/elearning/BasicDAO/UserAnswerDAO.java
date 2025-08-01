package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.UserAnswerReview;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserAnswerDAO {   
    
    // Lưu câu trả lời multiple choice
    public boolean saveMultipleChoiceAnswer(int userId, int quizId, int questionId, int answerId, boolean isCorrect) {
        String sql = "INSERT INTO UserAnswer (UserId, QuizId, QuestionId, AnswerId, IsCorrect, AnsweredAt) VALUES (?, ?, ?, ?, ?, NOW())";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, quizId);
            ps.setInt(3, questionId);
            ps.setInt(4, answerId);
            ps.setBoolean(5, isCorrect);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Lưu câu trả lời text input
    public boolean saveTextAnswer(int userId, int quizId, int questionId, String textAnswer, boolean isCorrect) {
        String sql = "INSERT INTO UserAnswer (UserId, QuizId, QuestionId, TextAnswer, IsCorrect, AnsweredAt) VALUES (?, ?, ?, ?, ?, NOW())";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, quizId);
            ps.setInt(3, questionId);
            ps.setString(4, textAnswer);
            ps.setBoolean(5, isCorrect);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Lấy câu trả lời của user để review
    public List<UserAnswerReview> getUserAnswersForReviewByResultId(int quizResultId) {
        List<UserAnswerReview> userAnswers = new ArrayList<>();

        String sql = """
            SELECT 
                ua.QuestionId,
                ua.AnswerId,
                ua.TextAnswer,
                ua.IsCorrect,
                q.QuestionType,
                CASE 
                    WHEN q.QuestionType = 'multiple_choice' AND ua.AnswerId IS NOT NULL THEN qa.Content
                    WHEN q.QuestionType = 'text_input' AND ua.TextAnswer IS NOT NULL THEN ua.TextAnswer
                    ELSE NULL
                END as UserAnswerText,
                ROW_NUMBER() OVER (ORDER BY qq.Id) - 1 as QuestionIndex
            FROM QuizQuestions qq
            JOIN Questions q ON qq.QuestionId = q.Id
            LEFT JOIN UserAnswer ua ON ua.QuestionId = q.Id AND ua.QuizResultId = ?
            LEFT JOIN QuestionAnswers qa ON ua.AnswerId = qa.Id AND q.QuestionType = 'multiple_choice'
            WHERE qq.QuizId = (
                SELECT QuizId FROM QuizResults WHERE Id = ?
            )
            ORDER BY qq.Id
        """;

        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quizResultId);
            ps.setInt(2, quizResultId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserAnswerReview review = new UserAnswerReview();
                review.setQuestionIndex(rs.getInt("QuestionIndex"));
                review.setQuestionType(rs.getString("QuestionType"));

                // Xử lý trường hợp có đáp án
                String userAnswerText = rs.getString("UserAnswerText");
                if (userAnswerText != null) {
                    review.setUserAnswer(userAnswerText);
                    review.setCorrect(rs.getBoolean("IsCorrect"));

                    // Lưu thêm AnswerId cho multiple choice để so sánh
                    if ("multiple_choice".equals(rs.getString("QuestionType"))) {
                        Integer answerId = rs.getObject("AnswerId", Integer.class);
                        if (answerId != null) {
                            review.setUserAnswerId(answerId); // Cần thêm field này
                        }
                    }
                } else {
                    // Trường hợp không có đáp án
                    review.setUserAnswer(null);
                    review.setCorrect(false);
                    review.setUserAnswerId(null);
                }

                userAnswers.add(review);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return userAnswers;
    }
    
    public boolean saveUserAnswerWithResultId(int userId, int quizId, int questionId, 
                                            Integer answerId, String textAnswer, String imagePath, 
                                            boolean isCorrect, int quizResultId) {
       String sql = "INSERT INTO UserAnswer (UserId, QuizId, QuestionId, QuizResultId, AnswerId, TextAnswer, IsCorrect, AnsweredAt) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";

       try (Connection conn = ServerConnectionInfo.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

           ps.setInt(1, userId);
           ps.setInt(2, quizId);
           ps.setInt(3, questionId);
           ps.setInt(4, quizResultId);

           if (answerId != null) {
               ps.setInt(5, answerId);
           } else {
               ps.setNull(5, Types.INTEGER);
           }

           ps.setString(6, textAnswer);
           ps.setBoolean(7, isCorrect);

           return ps.executeUpdate() > 0;
       } catch (SQLException e) {
           e.printStackTrace();
           return false;
       }
    }

    // Xóa tất cả câu trả lời của user cho một quiz (dùng khi làm lại)
    public boolean deleteUserAnswersForQuiz(int userId, int quizId) {
        String sql = "DELETE FROM UserAnswer WHERE UserId = ? AND QuizId = ?";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, quizId);
            
            return ps.executeUpdate() >= 0; // Trả về true ngay cả khi không có dòng nào bị xóa
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}