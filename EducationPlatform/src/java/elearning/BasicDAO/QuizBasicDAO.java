// QuizBasicDAO.java
package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.Quiz;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizBasicDAO {
    private final Connection connection;

    public QuizBasicDAO() {
        this.connection = ServerConnectionInfo.CONNECTION;
    }

    public boolean insert(Quiz quiz) throws SQLException {
        String sql = "INSERT INTO `Quizzes` (`Title`, `SubjectId`, `Duration`, `Status`, `CreatedAt`) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, quiz.getTitle());
            stmt.setInt(2, quiz.getSubjectId());
            stmt.setInt(3, quiz.getDuration());
            stmt.setString(4, quiz.getStatus());
            stmt.setTimestamp(5, quiz.getCreatedAt() != null ? new Timestamp(quiz.getCreatedAt().getTime()) : null);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Quiz> getAll() throws SQLException {
        String sql = "SELECT * FROM `Quizzes`";
        List<Quiz> quizzes = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                quizzes.add(mapRow(rs));
            }
        }
        return quizzes;
    }

    public Quiz getById(Integer id) throws SQLException {
        String sql = "SELECT * FROM `Quizzes` WHERE `Id` = ?";
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

    public boolean update(Quiz quiz) throws SQLException {
        String sql = "UPDATE `Quizzes` SET `Title` = ?, `SubjectId` = ?, `Duration` = ?, `Status` = ?, `CreatedAt` = ? WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, quiz.getTitle());
            stmt.setInt(2, quiz.getSubjectId());
            stmt.setInt(3, quiz.getDuration());
            stmt.setString(4, quiz.getStatus());
            stmt.setTimestamp(5, quiz.getCreatedAt() != null ? new Timestamp(quiz.getCreatedAt().getTime()) : null);
            stmt.setInt(6, quiz.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM `Quizzes` WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    private Quiz mapRow(ResultSet rs) throws SQLException {
        return Quiz.builder()
                .id(rs.getInt("Id"))
                .title(rs.getString("Title"))
                .subjectId(rs.getInt("SubjectId"))
                .duration(rs.getInt("Duration"))
                .status(rs.getString("Status"))
                .createdAt(rs.getTimestamp("CreatedAt"))
                .build();
    }
}
