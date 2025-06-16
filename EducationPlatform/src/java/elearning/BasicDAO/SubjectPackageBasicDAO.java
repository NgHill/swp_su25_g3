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
        "SELECT * FROM `SubjectPackages` WHERE `Title` LIKE ? OR `Description` LIKE ? ORDER BY `CreatedAt` DESC LIMIT ? OFFSET ?";
    private static final String COUNT_SQL =
        "SELECT COUNT(*) FROM `SubjectPackages` WHERE `Title` LIKE ? OR `Description` LIKE ?";
    private static final String LIST_ALL_SQL =
        "SELECT * FROM `SubjectPackages` ORDER BY `CreatedAt` DESC LIMIT ?";
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

    public List<SubjectPackage> getAll() throws SQLException {
        List<SubjectPackage> packages = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(LIST_ALL_SQL)) {
            stmt.setInt(1, Integer.MAX_VALUE); // fetch all
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    packages.add(mapRow(rs));
                }
            }
        }
        return packages;
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
     * Search by keyword in title or description with pagination.
     */
    public List<SubjectPackage> findByKeyword(String keyword, int page, int pageSize) throws SQLException {
        List<SubjectPackage> packages = new ArrayList<>();
        String pattern = "%" + keyword.trim() + "%";
        int offset = (page - 1) * pageSize;
        try (PreparedStatement stmt = connection.prepareStatement(LIST_SQL)) {
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            stmt.setInt(3, pageSize);
            stmt.setInt(4, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    packages.add(mapRow(rs));
                }
            }
        }
        return packages;
    }

    /**
     * Count total packages matching keyword.
     */
    public int countByKeyword(String keyword) throws SQLException {
        String pattern = "%" + keyword.trim() + "%";
        try (PreparedStatement stmt = connection.prepareStatement(COUNT_SQL)) {
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    /**
     * Get latest packages with limit.
     */
    public List<SubjectPackage> getLimit(int limit) throws SQLException {
        List<SubjectPackage> packages = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(LIST_ALL_SQL)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    packages.add(mapRow(rs));
                }
            }
        }
        return packages;
    }

    /**
     * Count all packages in database.
     */
    public int countAll() throws SQLException {
        try (PreparedStatement stmt = connection.prepareStatement(COUNT_ALL_SQL);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
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
    
    public List<SubjectPackage> getByCategory(String category) throws SQLException {
    List<SubjectPackage> packages = new ArrayList<>();
    String sql = "SELECT * FROM SubjectPackages WHERE Category = ? ORDER BY CreatedAt DESC";
    try (PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setString(1, category);
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                packages.add(mapRow(rs));
            }
        }
    }
    return packages;
}
}
