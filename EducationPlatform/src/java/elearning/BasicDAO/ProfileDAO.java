package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.Profile;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProfileDAO {

    public List<Profile> getProfileById(int userId) {
        List<Profile> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE Id = ?";

        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Profile pr = new Profile(
                            rs.getInt("Id"),
                            rs.getString("FullName"),
                            rs.getString("Email"),
                            rs.getString("Username"),
                            rs.getString("Mobile"),
                            rs.getDate("DateOfBirth"),
                            rs.getString("Gender"),
                            rs.getString("Bio")
                    );
                    list.add(pr);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateProfile(Profile profile) {
        String sql = """
                UPDATE Users 
                SET FullName = ?, Email = ?, Username = ?, Mobile = ?, DateOfBirth = ?, Gender = ?, Bio = ?
                WHERE Id = ?
                """;

        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {                                 
               stmt.setString(1, profile.getFullName());
                stmt.setString(2, profile.getEmail()); // thêm dòng này
                stmt.setString(3, profile.getUsername());
                stmt.setString(4, profile.getMobile());
                stmt.setDate(5, profile.getDateOfBirth());
                stmt.setString(6, profile.getGender());
                stmt.setString(7, profile.getBio());
                stmt.setInt(8, profile.getId());

            int rowsAffected = stmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        return false;
    } catch (Exception e) {
            System.err.println("General Error: " + e.getMessage());
            e.printStackTrace();
        return false;
    }
}
}
