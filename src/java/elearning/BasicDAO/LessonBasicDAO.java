// LessonDAO.java
package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.Lesson;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LessonBasicDAO {
    private final Connection connection;

    public LessonBasicDAO() {
        this.connection = ServerConnectionInfo.CONNECTION;
    }

    public boolean insert(Lesson lesson) throws SQLException {
        String sql = "INSERT INTO `Lessons` (`SubjectId`, `Title`, `Description`, `Status`, `CreatedAt`) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, lesson.getSubjectId());
            stmt.setString(2, lesson.getTitle());
            stmt.setString(3, lesson.getDescription());
            stmt.setString(4, lesson.getStatus());
            stmt.setTimestamp(5, lesson.getCreatedAt() != null ? new Timestamp(lesson.getCreatedAt().getTime()) : null);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Lesson> getAll() throws SQLException {
        String sql = "SELECT * FROM `Lessons`";
        List<Lesson> lessons = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                lessons.add(mapRow(rs));
            }
        }
        return lessons;
    }

    public Lesson getById(Integer id) throws SQLException {
        String sql = "SELECT * FROM `Lessons` WHERE `Id` = ?";
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

    public boolean update(Lesson lesson) throws SQLException {
        String sql = "UPDATE `Lessons` SET `SubjectId` = ?, `Title` = ?, `Description` = ?, `Status` = ?, `CreatedAt` = ? WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, lesson.getSubjectId());
            stmt.setString(2, lesson.getTitle());
            stmt.setString(3, lesson.getDescription());
            stmt.setString(4, lesson.getStatus());
            stmt.setTimestamp(5, lesson.getCreatedAt() != null ? new Timestamp(lesson.getCreatedAt().getTime()) : null);
            stmt.setInt(6, lesson.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM `Lessons` WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    private Lesson mapRow(ResultSet rs) throws SQLException {
        return Lesson.builder()
                .id(rs.getInt("Id"))
                .subjectId(rs.getInt("SubjectId"))
                .title(rs.getString("Title"))
                .description(rs.getString("Description"))
                .status(rs.getString("Status"))
                .createdAt(rs.getTimestamp("CreatedAt"))
                .build();
    }
}