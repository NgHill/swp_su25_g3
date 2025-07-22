package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.StimulationExam;
import elearning.entities.SubjectPackage;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StimulationDAO {

    public StimulationExam getStimulationById(int id) {
        String sql = "SELECT * FROM Stimulations WHERE Id = ?";
        try (Connection conn = ServerConnectionInfo.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                StimulationExam s = new StimulationExam();
                s.setId(rs.getInt("Id"));
                s.setSubjectId(rs.getInt("SubjectId"));
                s.setStimulationExam(rs.getString("StimulationExam"));
                s.setLevel(rs.getString("Level"));
                s.setNumberOfQuestions(rs.getInt("NumberOfQuestions"));
                s.setDuration(rs.getInt("Duration"));
                s.setPassRate(rs.getDouble("PassRate"));
                s.setCreatedAt(rs.getTimestamp("CreatedAt"));
                return s;
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy stimulation theo ID: " + e.getMessage());
        }
        return null;
    }

    public List<StimulationExam> getAllStimulationExams() {
        List<StimulationExam> list = new ArrayList<>();
        String sql = "SELECT * FROM Stimulations";
        try (Connection conn = ServerConnectionInfo.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                StimulationExam exam = new StimulationExam(
                        rs.getInt("Id"),
                        rs.getInt("SubjectId"),
                        rs.getString("StimulationExam"),
                        rs.getString("Level"),
                        rs.getInt("NumberOfQuestions"),
                        rs.getInt("Duration"),
                        rs.getDouble("PassRate"),
                        rs.getTimestamp("CreatedAt")
                );
                list.add(exam);
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy tất cả stimulation exams: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

   
    // Tìm kiếm và lọc theo category
    public List<StimulationExam> searchByKeywordAndCategories(String keyword, String[] categories) throws SQLException {
        List<StimulationExam> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT s.* FROM Stimulations s "
                + "INNER JOIN SubjectPackages sp ON s.SubjectId = sp.Id WHERE 1=1");

        List<String> params = new ArrayList<>();

        // Thêm điều kiện keyword nếu có
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND s.StimulationExam LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }

        // Thêm điều kiện category nếu có
        if (categories != null && categories.length > 0) {
            sql.append(" AND sp.Category IN (");
            for (int i = 0; i < categories.length; i++) {
                sql.append("?");
                params.add(categories[i]);
                if (i < categories.length - 1) {
                    sql.append(",");
                }
            }
            sql.append(")");
        }

        try (Connection conn = ServerConnectionInfo.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setString(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StimulationExam s = new StimulationExam();
                    s.setId(rs.getInt("Id"));
                    s.setSubjectId(rs.getInt("SubjectId"));
                    s.setStimulationExam(rs.getString("StimulationExam"));
                    s.setLevel(rs.getString("Level"));
                    s.setNumberOfQuestions(rs.getInt("NumberOfQuestions"));
                    s.setDuration(rs.getInt("Duration"));
                    s.setPassRate(rs.getDouble("PassRate"));
                    s.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    list.add(s);
                }
            }
        }

        return list;
    }

    // Method mới: Lấy tất cả categories có sẵn từ SubjectPackages
    public List<String> getAllCategories() throws SQLException {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT Category FROM SubjectPackages WHERE Category IS NOT NULL ORDER BY Category";

        try (Connection conn = ServerConnectionInfo.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String category = rs.getString("Category");
                if (category != null && !category.trim().isEmpty()) {
                    categories.add(category);
                }
            }
        }

        return categories;
    }

    public List<SubjectPackage> findByCategory(String category, int page, int pageSize) throws SQLException {
        List<SubjectPackage> packages = new ArrayList<>();
        String sql = "SELECT * FROM SubjectPackage WHERE category = ? LIMIT ? OFFSET ?";
        int offset = (page - 1) * pageSize;

        try (Connection conn = ServerConnectionInfo.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, category);
            stmt.setInt(2, pageSize);
            stmt.setInt(3, offset);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                SubjectPackage sp = new SubjectPackage(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getString("category")
                // thêm các field khác nếu có
                );
                packages.add(sp);
            }
        }
        return packages;
    }
}