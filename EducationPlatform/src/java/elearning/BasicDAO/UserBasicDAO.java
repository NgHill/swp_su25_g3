// UserDAO.java
package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserBasicDAO {
    private final Connection connection;
    
    public UserBasicDAO() {
        this.connection = ServerConnectionInfo.CONNECTION;
    }
    
    public boolean insert(User user) throws SQLException {
        String sql = "INSERT INTO `Users` (`FullName`, `Email`, `Mobile`, `Password`, `Gender`, `Avatar`, `Role`, `Status`, `ActiveCode`, `CreatedAt`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getMobile());
            stmt.setString(4, user.getPassword());
            stmt.setBoolean(5, user.isGender());
            stmt.setString(6, user.getAvatar());
            stmt.setString(7, user.getRole());
            stmt.setString(8, user.getStatus());
            stmt.setString(9, user.getActiveCode());
            stmt.setTimestamp(10, new Timestamp(user.getCreatedAt().getTime()));
            return stmt.executeUpdate() > 0;
        }
    }
    
    public List<User> getAll() throws SQLException {
        String sql = "SELECT * FROM `Users`";
        List<User> users = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                users.add(mapRow(rs));
            }
        }
        return users;
    }
    
    public User getById(Integer id) throws SQLException {
        String sql = "SELECT * FROM `Users` WHERE `Id` = ?";
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
    
    public boolean update(User user) throws SQLException {
        String sql = "UPDATE `Users` SET `FullName` = ?, `Email` = ?, `Mobile` = ?, `Password` = ?, `Gender` = ?, `Avatar` = ?, `Role` = ?, `Status` = ?, `ActiveCode` = ?, `CreatedAt` = ? WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getMobile());
            stmt.setString(4, user.getPassword());
            stmt.setBoolean(5, user.isGender());
            stmt.setString(6, user.getAvatar());
            stmt.setString(7, user.getRole());
            stmt.setString(8, user.getStatus());
            stmt.setString(9, user.getActiveCode());
            stmt.setTimestamp(10, new Timestamp(user.getCreatedAt().getTime()));
            stmt.setInt(11, user.getId());
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM `Users` WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
    
    // Custom methods
    public User findByEmailOrPhone(String email, String mobile) throws SQLException {
        String sql = "SELECT * FROM `Users` WHERE `Email` = ? OR `Mobile` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, mobile);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }
    
    public User login(String username, String password) throws SQLException {
        String sql = "SELECT * FROM `Users` WHERE (`Mobile` = ? OR `Email` = ?) AND `Password` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, username);
            stmt.setString(3, password);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }
    
    public boolean deleteByMobile(String mobile) throws SQLException {
        String sql = "DELETE FROM `Users` WHERE `Mobile` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, mobile);
            return stmt.executeUpdate() > 0;
        }
    }
    
    private User mapRow(ResultSet rs) throws SQLException {
        return User.builder()
                .id(rs.getInt("Id"))
                .fullName(rs.getString("FullName"))
                .email(rs.getString("Email"))
                .mobile(rs.getString("Mobile"))
                .password(rs.getString("Password"))
                .gender(rs.getBoolean("Gender"))
                .avatar(rs.getString("Avatar"))
                .role(rs.getString("Role"))
                .status(rs.getString("Status"))
                .activeCode(rs.getString("ActiveCode"))
                .createdAt(rs.getTimestamp("CreatedAt"))
                .build();
    }
}