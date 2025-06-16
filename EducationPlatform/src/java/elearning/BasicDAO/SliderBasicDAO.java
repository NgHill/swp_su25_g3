// SliderDAO.java
package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.Slider;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SliderBasicDAO {
    private final Connection connection;
    
    public SliderBasicDAO() {
        this.connection = ServerConnectionInfo.CONNECTION;
    }
    
    public boolean insert(Slider slider) throws SQLException {
        String sql = "INSERT INTO `Sliders` (`Image`, `Title`, `Description`, `Type`, `OrderNumber`) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, slider.getImage());
            stmt.setString(2, slider.getTitle());
            stmt.setString(3, slider.getDescription());
            stmt.setString(4, slider.getType());
            stmt.setInt(5, slider.getOrderNumber());
            return stmt.executeUpdate() > 0;
        }
    }
    
    public List<Slider> getAll() throws SQLException {
        String sql = "SELECT * FROM `Sliders`";
        List<Slider> sliders = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                sliders.add(mapRow(rs));
            }
        }
        return sliders;
    }
    
    public Slider getById(Integer id) throws SQLException {
        String sql = "SELECT * FROM `Sliders` WHERE `Id` = ?";
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
    
    public boolean update(Slider slider) throws SQLException {
        String sql = "UPDATE `Sliders` SET `Image` = ?, `Title` = ?, `Description` = ?, `Type` = ?, `OrderNumber` = ? WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, slider.getImage());
            stmt.setString(2, slider.getTitle());
            stmt.setString(3, slider.getDescription());
            stmt.setString(4, slider.getType());
            stmt.setInt(5, slider.getOrderNumber());
            stmt.setInt(6, slider.getId());
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM `Sliders` WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
    
    private Slider mapRow(ResultSet rs) throws SQLException {
        return Slider.builder()
                .id(rs.getInt("Id"))
                .image(rs.getString("Image"))
                .title(rs.getString("Title"))
                .description(rs.getString("Description"))
                .type(rs.getString("Type"))
                .orderNumber(rs.getInt("OrderNumber"))
                .build();
    }
}
