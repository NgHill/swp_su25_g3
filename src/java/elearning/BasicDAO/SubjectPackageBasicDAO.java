package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.SubjectPackage;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubjectPackageBasicDAO {
    private final Connection connection;

    // SQL templates
    private static final String LIST_SQL =
        "SELECT * FROM `SubjectPackages` WHERE (`Title` LIKE ? OR `Description` LIKE ?) AND (`Category` = ? OR ? = '') ORDER BY `CreatedAt` DESC LIMIT ? OFFSET ?";
    private static final String COUNT_SQL =
        "SELECT COUNT(*) FROM `SubjectPackages` WHERE (`Title` LIKE ? OR `Description` LIKE ?) AND (`Category` = ? OR ? = '')";
    private static final String LIST_ALL_SQL =
        "SELECT * FROM `SubjectPackages` ORDER BY `CreatedAt` DESC LIMIT ? OFFSET ?";
    private static final String COUNT_ALL_SQL =
        "SELECT COUNT(*) FROM `SubjectPackages`";

    public SubjectPackageBasicDAO() {
        this.connection = ServerConnectionInfo.CONNECTION;
    }

    public boolean insert(SubjectPackage subjectPackage) throws SQLException {
        String sql = "INSERT INTO `SubjectPackages` (`Title`, `Description`, `Thumbnail`, `LowestPrice`, `OriginalPrice`, `SalePrice`, `OwnerId`, `Category`, `Status`, `CreatedAt`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, subjectPackage.getTitle());
            stmt.setString(2, subjectPackage.getDescription());
            stmt.setString(3, subjectPackage.getThumbnail());
            stmt.setDouble(4, subjectPackage.getLowestPrice());
            stmt.setDouble(5, subjectPackage.getOriginalPrice());
            stmt.setDouble(6, subjectPackage.getSalePrice());
            stmt.setInt(7, subjectPackage.getOwnerId());
            stmt.setString(8, subjectPackage.getCategory());
            stmt.setString(9, subjectPackage.getStatus());
            stmt.setTimestamp(10, new Timestamp(subjectPackage.getCreatedAt().getTime()));
            return stmt.executeUpdate() > 0;
        }
    }

    public List<SubjectPackage> getAll(int page, int pageSize) throws SQLException {
        List<SubjectPackage> packages = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        try (PreparedStatement stmt = connection.prepareStatement(LIST_ALL_SQL)) {
            stmt.setInt(1, pageSize);
            stmt.setInt(2, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    packages.add(mapRow(rs));
                }
            }
        }
        return packages;
    }

    public int countAll() throws SQLException {
        try (PreparedStatement stmt = connection.prepareStatement(COUNT_ALL_SQL);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public SubjectPackage getById(Integer id) throws SQLException {
        String sql = "SELECT * FROM `SubjectPackages` WHERE `Id` = ?";
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

    public boolean update(SubjectPackage subjectPackage) throws SQLException {
        String sql = "UPDATE `SubjectPackages` SET `Title` = ?, `Description` = ?, `Thumbnail` = ?, `LowestPrice` = ?, `OriginalPrice` = ?, `SalePrice` = ?, `OwnerId` = ?, `Category` = ?, `Status` = ?, `CreatedAt` = ? WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, subjectPackage.getTitle());
            stmt.setString(2, subjectPackage.getDescription());
            stmt.setString(3, subjectPackage.getThumbnail());
            stmt.setDouble(4, subjectPackage.getLowestPrice());
            stmt.setDouble(5, subjectPackage.getOriginalPrice());
            stmt.setDouble(6, subjectPackage.getSalePrice());
            stmt.setInt(7, subjectPackage.getOwnerId());
            stmt.setString(8, subjectPackage.getCategory());
            stmt.setString(9, subjectPackage.getStatus());
            stmt.setTimestamp(10, new Timestamp(subjectPackage.getCreatedAt().getTime()));
            stmt.setInt(11, subjectPackage.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM `SubjectPackages` WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Search and/or filter by category with pagination.
     * If category is empty string, returns all categories.
     */
    public List<SubjectPackage> findByKeywordAndCategory(String keyword,
                                                          String category,
                                                          int page,
                                                          int pageSize) throws SQLException {
        List<SubjectPackage> packages = new ArrayList<>();
        String pattern = "%" + keyword.trim() + "%";
        int offset = (page - 1) * pageSize;
        try (PreparedStatement stmt = connection.prepareStatement(LIST_SQL)) {
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            stmt.setString(3, category);
            stmt.setString(4, category);
            stmt.setInt(5, pageSize);
            stmt.setInt(6, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    packages.add(mapRow(rs));
                }
            }
        }
        return packages;
    }

    public int countByKeywordAndCategory(String keyword, String category) throws SQLException {
        String pattern = "%" + keyword.trim() + "%";
        try (PreparedStatement stmt = connection.prepareStatement(COUNT_SQL)) {
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            stmt.setString(3, category);
            stmt.setString(4, category);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    private SubjectPackage mapRow(ResultSet rs) throws SQLException {
        return SubjectPackage.builder()
                .id(rs.getInt("Id"))
                .title(rs.getString("Title"))
                .description(rs.getString("Description"))
                .thumbnail(rs.getString("Thumbnail"))
                .lowestPrice(rs.getDouble("LowestPrice"))
                .originalPrice(rs.getDouble("OriginalPrice"))
                .salePrice(rs.getDouble("SalePrice"))
                .ownerId(rs.getInt("OwnerId"))
                .category(rs.getString("Category"))
                .status(rs.getString("Status"))
                .createdAt(rs.getTimestamp("CreatedAt"))
                .build();
    }
}
