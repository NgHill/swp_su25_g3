// QuizResultBasicDAO.java
package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.QuizResult;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizResultBasicDAO {
    private final Connection connection;

    public QuizResultBasicDAO() {
        this.connection = ServerConnectionInfo.CONNECTION;
    }

    public boolean insert(QuizResult quizResult) throws SQLException {
        String sql = "INSERT INTO `QuizResults` (`UserId`, `QuizId`, `Score`, `SubmittedAt`) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, quizResult.getUserId());
            stmt.setInt(2, quizResult.getQuizId());
            stmt.setDouble(3, quizResult.getScore());
            stmt.setTimestamp(4, quizResult.getSubmittedAt() != null ? new Timestamp(quizResult.getSubmittedAt().getTime()) : null);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<QuizResult> getAll() throws SQLException {
        String sql = "SELECT * FROM `QuizResults`";
        List<QuizResult> quizResults = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                quizResults.add(mapRow(rs));
            }
        }
        return quizResults;
    }

    public QuizResult getById(Integer id) throws SQLException {
        String sql = "SELECT * FROM `QuizResults` WHERE `Id` = ?";
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

    public boolean update(QuizResult quizResult) throws SQLException {
        String sql = "UPDATE `QuizResults` SET `UserId` = ?, `QuizId` = ?, `Score` = ?, `SubmittedAt` = ? WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, quizResult.getUserId());
            stmt.setInt(2, quizResult.getQuizId());
            stmt.setDouble(3, quizResult.getScore());
            stmt.setTimestamp(4, quizResult.getSubmittedAt() != null ? new Timestamp(quizResult.getSubmittedAt().getTime()) : null);
            stmt.setInt(5, quizResult.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM `QuizResults` WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    private QuizResult mapRow(ResultSet rs) throws SQLException {
        return QuizResult.builder()
                .id(rs.getInt("Id"))
                .userId(rs.getInt("UserId"))
                .quizId(rs.getInt("QuizId"))
                .score(rs.getDouble("Score"))
                .submittedAt(rs.getTimestamp("SubmittedAt"))
                .build();
    }
}