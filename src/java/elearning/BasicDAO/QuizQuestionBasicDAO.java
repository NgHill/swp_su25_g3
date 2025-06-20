// QuizQuestionBasicDAO.java
package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.QuizQuestion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizQuestionBasicDAO {
    private final Connection connection;

    public QuizQuestionBasicDAO() {
        this.connection = ServerConnectionInfo.CONNECTION;
    }

    public boolean insert(QuizQuestion quizQuestion) throws SQLException {
        String sql = "INSERT INTO `QuizQuestions` (`QuizId`, `QuestionId`) VALUES (?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, quizQuestion.getQuizId());
            stmt.setInt(2, quizQuestion.getQuestionId());
            return stmt.executeUpdate() > 0;
        }
    }

    public List<QuizQuestion> getAll() throws SQLException {
        String sql = "SELECT * FROM `QuizQuestions`";
        List<QuizQuestion> quizQuestions = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                quizQuestions.add(mapRow(rs));
            }
        }
        return quizQuestions;
    }

    public QuizQuestion getById(Integer id) throws SQLException {
        String sql = "SELECT * FROM `QuizQuestions` WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public boolean update(QuizQuestion quizQuestion) throws SQLException {
        String sql = "UPDATE `QuizQuestions` SET `QuizId` = ?, `QuestionId` = ? WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, quizQuestion.getQuizId());
            stmt.setInt(2, quizQuestion.getQuestionId());
            stmt.setInt(3, quizQuestion.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM `QuizQuestions` WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    private QuizQuestion mapRow(ResultSet rs) throws SQLException {
        return QuizQuestion.builder()
                .id(rs.getInt("Id"))
                .quizId(rs.getInt("QuizId"))
                .questionId(rs.getInt("QuestionId"))
                .build();
    }
}
