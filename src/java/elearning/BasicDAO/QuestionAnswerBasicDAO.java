// QuestionAnswerBasicDAO.java
package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.QuestionAnswer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionAnswerBasicDAO {
    private final Connection connection;

    public QuestionAnswerBasicDAO() {
        this.connection = ServerConnectionInfo.CONNECTION;
    }

    public boolean insert(QuestionAnswer questionAnswer) throws SQLException {
        String sql = "INSERT INTO `QuestionAnswers` (`QuestionId`, `Content`, `IsCorrect`, `Explanation`) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, questionAnswer.getQuestionId());
            stmt.setString(2, questionAnswer.getContent());
            stmt.setBoolean(3, questionAnswer.getIsCorrect());
            stmt.setString(4, questionAnswer.getExplanation());
            return stmt.executeUpdate() > 0;
        }
    }

    public List<QuestionAnswer> getAll() throws SQLException {
        String sql = "SELECT * FROM `QuestionAnswers`";
        List<QuestionAnswer> questionAnswers = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                questionAnswers.add(mapRow(rs));
            }
        }
        return questionAnswers;
    }

    public QuestionAnswer getById(Integer id) throws SQLException {
        String sql = "SELECT * FROM `QuestionAnswers` WHERE `Id` = ?";
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

    public boolean update(QuestionAnswer questionAnswer) throws SQLException {
        String sql = "UPDATE `QuestionAnswers` SET `QuestionId` = ?, `Content` = ?, `IsCorrect` = ?, `Explanation` = ? WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, questionAnswer.getQuestionId());
            stmt.setString(2, questionAnswer.getContent());
            stmt.setBoolean(3, questionAnswer.getIsCorrect());
            stmt.setString(4, questionAnswer.getExplanation());
            stmt.setInt(5, questionAnswer.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM `QuestionAnswers` WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    private QuestionAnswer mapRow(ResultSet rs) throws SQLException {
        return QuestionAnswer.builder()
                .id(rs.getInt("Id"))
                .questionId(rs.getInt("QuestionId"))
                .content(rs.getString("Content"))
                .isCorrect(rs.getBoolean("IsCorrect"))
                .explanation(rs.getString("Explanation"))
                .build();
    }
}
