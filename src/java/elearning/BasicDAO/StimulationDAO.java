package elearning.BasicDAO;
import elearning.constant.ServerConnectionInfo;
import elearning.entities.StimulationExam;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StimulationDAO {
    
    public StimulationExam getStimulationById(int id) {
        String sql = "SELECT * FROM Stimulations WHERE Id = ?";
        try (Connection conn = ServerConnectionInfo.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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
            e.printStackTrace();
        }
        return null;
    }
    
    public List<StimulationExam> getAllStimulationExams() {
        List<StimulationExam> list = new ArrayList<>();
        String sql = "SELECT * FROM Stimulations";
        try (Connection conn = ServerConnectionInfo.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
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
    
    public List<StimulationExam> searchByKeyword(String keyword) throws SQLException {
        List<StimulationExam> list = new ArrayList<>();
        // Sử dụng tên cột nhất quán với các method khác
        String sql = "SELECT * FROM Stimulations WHERE StimulationExam LIKE ?";
        
        System.out.println("Đang tìm kiếm với từ khóa: " + keyword); // Debug
        
        try (Connection conn = ServerConnectionInfo.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
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
        
        System.out.println("Tìm thấy " + list.size() + " kết quả"); // Debug
        return list;
    }
}