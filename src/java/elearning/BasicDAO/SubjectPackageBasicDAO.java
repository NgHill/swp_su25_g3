// SubjectPackageDAO.java
package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.SubjectPackage;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubjectPackageBasicDAO {
    private final Connection connection;
    
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
        String sql = "SELECT * FROM `SubjectPackages`";
        List<SubjectPackage> packages = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                packages.add(mapRow(rs));
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
