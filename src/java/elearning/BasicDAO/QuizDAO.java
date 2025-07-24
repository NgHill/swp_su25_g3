/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elearning.BasicDAO;

/**
 *
 * @author Lenovo
 */
import elearning.constant.ServerConnectionInfo;
import elearning.entities.Quiz;
import elearning.entities.Question;
import elearning.entities.QuestionAnswer;
import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class QuizDAO {
    
    // Lấy thông tin quiz theo ID
    public Quiz getQuizById(int quizId) {
        Quiz quiz = null;
        String sql = "SELECT * FROM Quizzes WHERE Id = ? AND Status = 'active'";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                quiz = new Quiz();
                quiz.setId(rs.getInt("Id"));
                quiz.setTitle(rs.getString("Title"));
                quiz.setSubjectId(rs.getInt("SubjectId"));
                quiz.setDuration(rs.getInt("Duration"));
                quiz.setStatus(rs.getString("Status"));
                quiz.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return quiz;
    }
    
    // Lấy tất cả câu hỏi của một quiz
    public List<Question> getQuestionsByQuizId(int quizId) {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT q.* FROM Questions q " +
                    "JOIN QuizQuestions qq ON q.Id = qq.QuestionId " +
                    "WHERE qq.QuizId = ? AND q.Status = 'active' " +
                    "ORDER BY qq.Id";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Question question = new Question();
                question.setId(rs.getInt("Id"));
                question.setSubjectId(rs.getInt("SubjectId"));
                question.setLessonId(rs.getInt("LessonId"));
                question.setDimensionId(rs.getInt("DimensionId"));
                question.setLevel(rs.getString("Level"));
                question.setContent(rs.getString("Content"));
                question.setMedia(rs.getString("Media"));
                question.setStatus(rs.getString("Status"));
                question.setQuestionType(rs.getString("QuestionType")); // Thêm trường mới
                question.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                
                // Lấy answers cho question này
                question.setAnswers(getAnswersByQuestionId(question.getId(), question.getQuestionType()));
                questions.add(question);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questions;
    }
    
    // Lấy tất cả đáp án của một câu hỏi (đã cải tiến để xử lý cả multiple choice và text)
    public List<QuestionAnswer> getAnswersByQuestionId(int questionId, String questionType) {
        List<QuestionAnswer> answers = new ArrayList<>();
        String sql = "SELECT * FROM QuestionAnswers WHERE QuestionId = ? ORDER BY Id";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                QuestionAnswer answer = new QuestionAnswer();
                answer.setId(rs.getInt("Id"));
                answer.setQuestionId(rs.getInt("QuestionId"));
                answer.setContent(rs.getString("Content"));
                answer.setCorrect(rs.getBoolean("IsCorrect"));
                answer.setExplanation(rs.getString("Explanation"));
                answers.add(answer);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return answers;
    }
    
    // Phương thức cũ để backward compatibility
    public List<QuestionAnswer> getAnswersByQuestionId(int questionId) {
        return getAnswersByQuestionId(questionId, "multiple_choice");
    }
    
    // Lấy tất cả đáp án đúng của một câu hỏi (cho câu hỏi text có thể có nhiều đáp án đúng)
    public List<QuestionAnswer> getCorrectAnswers(int questionId) {
        List<QuestionAnswer> correctAnswers = new ArrayList<>();
        String sql = "SELECT * FROM QuestionAnswers WHERE QuestionId = ? AND IsCorrect = true";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                QuestionAnswer answer = new QuestionAnswer();
                answer.setId(rs.getInt("Id"));
                answer.setQuestionId(rs.getInt("QuestionId"));
                answer.setContent(rs.getString("Content"));
                answer.setCorrect(rs.getBoolean("IsCorrect"));
                answer.setExplanation(rs.getString("Explanation"));
                correctAnswers.add(answer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return correctAnswers;
    }
    
    // Lấy đáp án đúng của một câu hỏi (giữ lại cho backward compatibility)
    public QuestionAnswer getCorrectAnswer(int questionId) {
        List<QuestionAnswer> correctAnswers = getCorrectAnswers(questionId);
        return correctAnswers.isEmpty() ? null : correctAnswers.get(0);
    }
    
    // Lấy quiz với tất cả questions và answers
    public Quiz getQuizWithQuestions(int quizId) {
        Quiz quiz = getQuizById(quizId);
        if (quiz != null) {
            quiz.setQuestions(getQuestionsByQuizId(quizId));
        }
        return quiz;
    }
    
    public boolean isTextAnswerCorrect(int questionId, String userAnswer) {
        if (userAnswer == null || userAnswer.trim().isEmpty()) {
            return false;
        }

        List<QuestionAnswer> correctAnswers = getCorrectAnswers(questionId);
        String normalizedUserAnswer = normalizeText(userAnswer);

        for (QuestionAnswer correctAnswer : correctAnswers) {
            String normalizedCorrectAnswer = normalizeText(correctAnswer.getContent());

            // Kiểm tra contains (nếu câu trả lời của user chứa đáp án đúng)
            if (normalizedUserAnswer.contains(normalizedCorrectAnswer) || 
                normalizedCorrectAnswer.contains(normalizedUserAnswer)) {
                return true;
            }
        }

        return false;
    }
    
    // Lấy loại câu hỏi
    public String getQuestionType(int questionId) {
        String sql = "SELECT QuestionType FROM Questions WHERE Id = ?";
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getString("QuestionType");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "multiple_choice"; // default
    }
    
    private String normalizeText(String text) {
        if (text == null) return "";

        return text.trim()                          // Loại bỏ khoảng trắng đầu cuối
                  .toLowerCase()                    // Chuyển thành chữ thường
                  .replaceAll("\\s+", " ");
    }
}
