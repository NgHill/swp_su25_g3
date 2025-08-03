package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.Registration;
import elearning.entities.SubjectPackage;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class RegistrationBasicDAO {

    private final Connection connection;

    public RegistrationBasicDAO() {
        this.connection = ServerConnectionInfo.CONNECTION;
    }

    public boolean insert(Registration registration) throws SQLException {
        String sql = "INSERT INTO `Registrations` (`UserId`, `SubjectId`, `PackageMonths`, `Status`, `TotalCost`, `ValidFrom`, `ValidTo`, `CreatedAt`, "
                + "`RegisteredFullName`, `RegisteredEmail`, `RegisteredMobile`, `RegisteredGender`) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            if (registration.getUserId() != null) {
                stmt.setInt(1, registration.getUserId());
            } else {
                stmt.setNull(1, Types.INTEGER);
            }
            stmt.setInt(2, registration.getSubjectId());
            stmt.setInt(3, registration.getPackageMonths());
            stmt.setString(4, registration.getStatus());
            stmt.setDouble(5, registration.getTotalCost());
            stmt.setTimestamp(6, registration.getValidFrom() != null ? new Timestamp(registration.getValidFrom().getTime()) : null);
            stmt.setTimestamp(7, registration.getValidTo() != null ? new Timestamp(registration.getValidTo().getTime()) : null);
            stmt.setTimestamp(8, registration.getCreatedAt() != null ? new Timestamp(registration.getCreatedAt().getTime()) : null);
            stmt.setString(9, registration.getRegisteredFullName());
            stmt.setString(10, registration.getRegisteredEmail());
            stmt.setString(11, registration.getRegisteredMobile());
            stmt.setObject(12, registration.getRegisteredGender(), Types.BOOLEAN);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Registration> getAll() throws SQLException {
        String sql = "SELECT * FROM `Registrations`";
        List<Registration> registrations = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
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
        String sql = "UPDATE `Registrations` SET `UserId` = ?, `SubjectId` = ?, `Status` = ?, `TotalCost` = ?, "
                + "`ValidFrom` = ?, `ValidTo` = ?, `CreatedAt` = ?, "
                + "`RegisteredFullName` = ?, `RegisteredEmail` = ?, `RegisteredMobile` = ?, `RegisteredGender` = ? "
                + "WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            if (registration.getUserId() != null) {
                stmt.setInt(1, registration.getUserId());
            } else {
                stmt.setNull(1, Types.INTEGER);
            }
            stmt.setInt(2, registration.getSubjectId());
            stmt.setString(3, registration.getStatus());
            stmt.setDouble(4, registration.getTotalCost());
            stmt.setTimestamp(5, registration.getValidFrom() != null ? new Timestamp(registration.getValidFrom().getTime()) : null);
            stmt.setTimestamp(6, registration.getValidTo() != null ? new Timestamp(registration.getValidTo().getTime()) : null);
            stmt.setTimestamp(7, registration.getCreatedAt() != null ? new Timestamp(registration.getCreatedAt().getTime()) : null);
            stmt.setString(8, registration.getRegisteredFullName());
            stmt.setString(9, registration.getRegisteredEmail());
            stmt.setString(10, registration.getRegisteredMobile());
            stmt.setObject(11, registration.getRegisteredGender(), Types.BOOLEAN);
            stmt.setInt(12, registration.getId());
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
        String sql = "SELECT r.*, "
                + "sp.Id AS spId, sp.Title AS spTitle, sp.Category, sp.OriginalPrice, sp.SalePrice "
                + "FROM Registrations r "
                + "JOIN SubjectPackages sp ON r.SubjectId = sp.Id "
                + "WHERE r.UserId = ?";
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

    public List<Registration> searchByKeywordAndCategories(int userId, String keyword, String[] categories) throws SQLException {
        List<Registration> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT r.*, "
                + "sp.Id AS spId, sp.Title AS spTitle, sp.Category, sp.OriginalPrice, sp.SalePrice "
                + "FROM Registrations r "
                + "JOIN SubjectPackages sp ON r.SubjectId = sp.Id "
                + "WHERE r.UserId = ? ");

        List<Object> params = new ArrayList<>();
        params.add(userId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND sp.Title LIKE ? ");
            params.add("%" + keyword.trim() + "%");
        }

        if (categories != null && categories.length > 0) {
            sql.append("AND sp.Category IN (");
            sql.append(String.join(",", Collections.nCopies(categories.length, "?")));
            sql.append(") ");
            Collections.addAll(params, categories);
        }

        try (PreparedStatement stmt = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }

        return list;
    }

    private Registration mapRow(ResultSet rs) throws SQLException {
        SubjectPackage sp = new SubjectPackage();
        sp.setId(rs.getInt("spId"));
        sp.setTitle(rs.getString("spTitle"));
        sp.setCategory(rs.getString("Category"));
        sp.setOriginalPrice(rs.getDouble("OriginalPrice"));
        sp.setSalePrice(rs.getDouble("SalePrice"));

        return Registration.builder()
                .id(rs.getInt("Id"))
                .userId(rs.getInt("UserId"))
                .subjectId(rs.getInt("SubjectId"))
                .status(rs.getString("Status"))
                .totalCost(rs.getDouble("TotalCost"))
                .packageMonths(rs.getInt("PackageMonths"))
                .validFrom(rs.getTimestamp("ValidFrom"))
                .validTo(rs.getTimestamp("ValidTo"))
                .createdAt(rs.getTimestamp("CreatedAt"))
                .registeredFullName(rs.getString("RegisteredFullName"))
                .registeredEmail(rs.getString("RegisteredEmail"))
                .registeredMobile(rs.getString("RegisteredMobile"))
                .registeredGender((Boolean) rs.getObject("RegisteredGender"))
                .subjectPackage(sp)
                .build();
    }

    public List<String> getAllCategories() throws SQLException {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT Category FROM SubjectPackages WHERE Category IS NOT NULL ORDER BY Category";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String category = rs.getString("Category");
                if (category != null && !category.trim().isEmpty()) {
                    categories.add(category);
                }
            }
        }

        return categories;
    }

    public boolean checkUserRegistration(int userId, int subjectId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM `Registrations` WHERE `UserId` = ? AND `SubjectId` = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, subjectId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; // Trả về true nếu có ít nhất 1 bản ghi
                }
            }
        }
        return false;
    }

    public boolean checkEmailRegistration(String email, int subjectId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Registrations WHERE registeredEmail = ? AND subjectId = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setInt(2, subjectId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; // Trả về true nếu có ít nhất 1 bản ghi
                }
            }
        }
        return false;
    }
}
