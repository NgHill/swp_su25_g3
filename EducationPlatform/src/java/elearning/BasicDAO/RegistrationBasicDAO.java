// RegistrationBasicDAO.java
package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.Registration;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RegistrationBasicDAO {
    private final Connection connection;

    public RegistrationBasicDAO() {
        this.connection = ServerConnectionInfo.CONNECTION;
    }

    public boolean insert(Registration registration) throws SQLException {
        String sql = "INSERT INTO `Registrations` (`UserId`, `SubjectId`, `Status`, `TotalCost`, `ValidFrom`, `ValidTo`, `CreatedAt`) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, registration.getUserId());
            stmt.setInt(2, registration.getSubjectId());
            stmt.setString(3, registration.getStatus());
            stmt.setDouble(4, registration.getTotalCost());
            stmt.setTimestamp(5, registration.getValidFrom() != null ? new Timestamp(registration.getValidFrom().getTime()) : null);
            stmt.setTimestamp(6, registration.getValidTo() != null ? new Timestamp(registration.getValidTo().getTime()) : null);
            stmt.setTimestamp(7, registration.getCreatedAt() != null ? new Timestamp(registration.getCreatedAt().getTime()) : null);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Registration> getAll() throws SQLException {
        String sql = "SELECT * FROM `Registrations`";
        List<Registration> registrations = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                registrations.add(mapRow(rs));
            }
        }
        return registrations;
    }

    public Registration getById(Integer id) throws SQLException {
        String sql = "SELECT * FROM `Registrations` WHERE `Id` = ?";
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

    public boolean update(Registration registration) throws SQLException {
        String sql = "UPDATE `Registrations` SET `UserId` = ?, `SubjectId` = ?, `Status` = ?, `TotalCost` = ?, `ValidFrom` = ?, `ValidTo` = ?, `CreatedAt` = ? WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, registration.getUserId());
            stmt.setInt(2, registration.getSubjectId());
            stmt.setString(3, registration.getStatus());
            stmt.setDouble(4, registration.getTotalCost());
            stmt.setTimestamp(5, registration.getValidFrom() != null ? new Timestamp(registration.getValidFrom().getTime()) : null);
            stmt.setTimestamp(6, registration.getValidTo() != null ? new Timestamp(registration.getValidTo().getTime()) : null);
            stmt.setTimestamp(7, registration.getCreatedAt() != null ? new Timestamp(registration.getCreatedAt().getTime()) : null);
            stmt.setInt(8, registration.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM `Registrations` WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Registration> findByUserId(Integer userId) throws SQLException {
        String sql = "SELECT * FROM `Registrations` WHERE `UserId` = ?";
        List<Registration> registrations = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    registrations.add(mapRow(rs));
                }
            }
        }
        return registrations;
    }

    private Registration mapRow(ResultSet rs) throws SQLException {
        return Registration.builder()
                .id(rs.getInt("Id"))
                .userId(rs.getInt("UserId"))
                .subjectId(rs.getInt("SubjectId"))
                .status(rs.getString("Status"))
                .totalCost(rs.getDouble("TotalCost"))
                .validFrom(rs.getTimestamp("ValidFrom"))
                .validTo(rs.getTimestamp("ValidTo"))
                .createdAt(rs.getTimestamp("CreatedAt"))
                .build();
    }
}