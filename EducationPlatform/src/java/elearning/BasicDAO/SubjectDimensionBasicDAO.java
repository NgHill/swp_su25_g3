// SubjectDimensionDAO.java
package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.SubjectDimension;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubjectDimensionBasicDAO {
    private final Connection connection;
    
    public SubjectDimensionBasicDAO() {
        this.connection = ServerConnectionInfo.CONNECTION;
    }
    
    public boolean insert(SubjectDimension dimension) throws SQLException {
        String sql = "INSERT INTO `SubjectDimensions` (`SubjectId`, `Name`, `Type`, `Description`) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, dimension.getSubjectId());
            stmt.setString(2, dimension.getName());
            stmt.setString(3, dimension.getType());
            stmt.setString(4, dimension.getDescription());
            return stmt.executeUpdate() > 0;
        }
    }
    
    public List<SubjectDimension> getAll() throws SQLException {
        String sql = "SELECT * FROM `SubjectDimensions`";
        List<SubjectDimension> dimensions = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                dimensions.add(mapRow(rs));
            }
        }
        return dimensions;
    }
    
    public SubjectDimension getById(Integer id) throws SQLException {
        String sql = "SELECT * FROM `SubjectDimensions` WHERE `Id` = ?";
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
    
    public boolean update(SubjectDimension dimension) throws SQLException {
        String sql = "UPDATE `SubjectDimensions` SET `SubjectId` = ?, `Name` = ?, `Type` = ?, `Description` = ? WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, dimension.getSubjectId());
            stmt.setString(2, dimension.getName());
            stmt.setString(3, dimension.getType());
            stmt.setString(4, dimension.getDescription());
            stmt.setInt(5, dimension.getId());
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM `SubjectDimensions` WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
    
    private SubjectDimension mapRow(ResultSet rs) throws SQLException {
        return SubjectDimension.builder()
                .id(rs.getInt("Id"))
                .subjectId(rs.getInt("SubjectId"))
                .name(rs.getString("Name"))
                .type(rs.getString("Type"))
                .description(rs.getString("Description"))
                .build();
    }
}
