package elearning.BasicDAO;

import elearning.JDBC.BaseDAO;
import elearning.constant.ServerConnectionInfo;
import elearning.entities.PracticeDetail;
import elearning.entities.PracticeList;
import elearning.entities.Quiz;
import elearning.entities.SubjectPackage;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PracticeListDAO {

    public List<PracticeList> getPracticeListByUserId(int userId) {
        List<PracticeList> list = new ArrayList<>();

        String sql = """
                SELECT qr.Id AS QuizResultId, qr.UserId, qr.QuizId, qr.Score, qr.SubmittedAt, q.Title
                FROM QuizResults qr
                JOIN Quizzes q ON qr.QuizId = q.Id 
                WHERE qr.UserId = ?
                """;

        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PracticeList p = new PracticeList(
                        rs.getInt("QuizResultId"),
                        rs.getInt("UserId"),
                        rs.getInt("QuizId"),
                        rs.getDouble("Score"),
                        rs.getTimestamp("SubmittedAt"),
                        rs.getString("Title")
                    );
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<PracticeList> getPracticeListFiltered(int userId, String scoreFilter) {
        List<PracticeList> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT qr.Id AS QuizResultId, qr.UserId, qr.QuizId, qr.Score, qr.SubmittedAt, q.Title
            FROM QuizResults qr
            JOIN Quizzes q ON qr.QuizId = q.Id 
            WHERE qr.UserId = ?
            """);

        if ("L".equals(scoreFilter)) {
            sql.append(" AND qr.Score < 5");
        } else if ("G".equals(scoreFilter)) {
            sql.append(" AND qr.Score >= 5");
        }

        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            stmt.setInt(1, userId);


            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PracticeList p = new PracticeList(
                        rs.getInt("QuizResultId"),
                        rs.getInt("UserId"),
                        rs.getInt("QuizId"),
                        rs.getDouble("Score"),
                        rs.getTimestamp("SubmittedAt"),
                        rs.getString("Title")
                    );
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
}

    public List<PracticeDetail> getPracticeDetails(int quizResultId) {
        List<PracticeDetail> list = new ArrayList<>();

        String sql = """
            SELECT 
                u.Id As UserId,     
                qr.Id AS QuizResultId,
                q.Title AS QuizTitle, 
                sp.Description AS SubjectDescription, 
                q.Duration, 
                qr.SubmittedAt, 
                qr.Score
            FROM QuizResults qr
            JOIN Quizzes q ON qr.QuizId = q.Id
            JOIN SubjectPackages sp ON q.SubjectId = sp.Id
            JOIN Users u ON qr.UserId = u.Id
            WHERE qr.Id = ?
        """;

        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quizResultId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PracticeDetail detail = new PracticeDetail(
                            rs.getInt("UserId"), 
                            rs.getInt("QuizResultId"), 
                            rs.getString("QuizTitle"),
                            rs.getString("SubjectDescription"), 
                            rs.getInt("Duration"), 
                            rs.getTimestamp("SubmittedAt"),
                            rs.getDouble("Score")
                    );
                    list.add(detail);
                }
            }                                                                                                                                     
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public List<PracticeList> getPracticeListBySearch(int userId, String search) {
        List<PracticeList> list = new ArrayList<>();

        String sql = """
                    SELECT qr.Id AS QuizResultId, qr.UserId, qr.QuizId, qr.Score, qr.SubmittedAt, q.Title
                    FROM QuizResults qr
                    JOIN Quizzes q ON qr.QuizId = q.Id 
                    WHERE qr.UserId = ? AND q.Title LIKE ?
                    """;

        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setString(2, "%" + search + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PracticeList p = new PracticeList(
                            rs.getInt("QuizResultId"),
                            rs.getInt("UserId"),
                            rs.getInt("QuizId"),
                            rs.getDouble("Score"),
                            rs.getTimestamp("SubmittedAt"),
                            rs.getString("Title")
                    );
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public List<SubjectPackage> getRegisteredSubjectsByUserId(int userId) {
        List<SubjectPackage> list = new ArrayList<>();

        String sql = """
            SELECT DISTINCT sp.Id, sp.Title 
            FROM Registrations r 
            JOIN SubjectPackages sp ON r.SubjectId = sp.Id 
            WHERE r.UserId = ? AND r.Status = 'submitted'
            """;

        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SubjectPackage subject = new SubjectPackage();
                    subject.setId(rs.getInt("Id"));
                    subject.setTitle(rs.getString("Title"));
                    list.add(subject);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Quiz> getQuizzesBySubjectId(int subjectId) {
        List<Quiz> list = new ArrayList<>();

        String sql = """
            SELECT Id, Title 
            FROM Quizzes 
            WHERE SubjectId = ? AND Status = 'active'
            """;

        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, subjectId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Quiz quiz = new Quiz();
                    quiz.setId(rs.getInt("Id"));
                    quiz.setTitle(rs.getString("Title"));
                    list.add(quiz);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
