// QuestionBasicDAO.java
package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.Question;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionBasicDAO {
    private final Connection connection;

    public QuestionBasicDAO() {
        this.connection = ServerConnectionInfo.CONNECTION;
    }

    public boolean insert(Question question) throws SQLException {
        String sql = "INSERT INTO `Questions` (`SubjectId`, `LessonId`, `DimensionId`, `Level`, `Content`, `Media`, `Status`, `CreatedAt`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, question.getSubjectId());
            stmt.setInt(2, question.getLessonId());
            stmt.setInt(3, question.getDimensionId());
            stmt.setString(4, question.getLevel());
            stmt.setString(5, question.getContent());
            stmt.setString(6, question.getMedia());
            stmt.setString(7, question.getStatus());
            stmt.setTimestamp(8, question.getCreatedAt() != null ? new Timestamp(question.getCreatedAt().getTime()) : null);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Question> getAll() throws SQLException {
        String sql = "SELECT * FROM `Questions`";
        List<Question> questions = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                questions.add(mapRow(rs));
            }
        }
        return questions;
    }

    public Question getById(Integer id) throws SQLException {
        String sql = "SELECT * FROM `Questions` WHERE `Id` = ?";
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

    public boolean update(Question question) throws SQLException {
        String sql = "UPDATE `Questions` SET `SubjectId` = ?, `LessonId` = ?, `DimensionId` = ?, `Level` = ?, `Content` = ?, `Media` = ?, `Status` = ?, `CreatedAt` = ? WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, question.getSubjectId());
            stmt.setInt(2, question.getLessonId());
            stmt.setInt(3, question.getDimensionId());
            stmt.setString(4, question.getLevel());
            stmt.setString(5, question.getContent());
            stmt.setString(6, question.getMedia());
            stmt.setString(7, question.getStatus());
            stmt.setTimestamp(8, question.getCreatedAt() != null ? new Timestamp(question.getCreatedAt().getTime()) : null);
            stmt.setInt(9, question.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM `Questions` WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    private Question mapRow(ResultSet rs) throws SQLException {
        return Question.builder()
                .id(rs.getInt("Id"))
                .subjectId(rs.getInt("SubjectId"))
                .lessonId(rs.getInt("LessonId"))
                .dimensionId(rs.getInt("DimensionId"))
                .level(rs.getString("Level"))
                .content(rs.getString("Content"))
                .media(rs.getString("Media"))
                .status(rs.getString("Status"))
                .createdAt(rs.getTimestamp("CreatedAt"))
                .build();
    }
}