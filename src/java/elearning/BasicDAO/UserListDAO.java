/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.PracticeList;
import elearning.entities.Profile;
import elearning.entities.UserList;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;

/**
 *
 * @author Lenovo
 */
public class UserListDAO {
    
    
    
    public List<UserList> getAllUsers() {
        List<UserList> list = new ArrayList<>();
        String sql = "SELECT * FROM Users ";

        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {          

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    UserList ul = new UserList(
                            rs.getInt("Id"),
                            rs.getString("FullName"), 
                            rs.getInt("Gender"), 
                            rs.getString("Email"), 
                            rs.getString("Mobile"), 
                            rs.getString("Password"),  // Thêm Password
                            rs.getString("Role"), 
                            rs.getString("Status")
                    );
                    list.add(ul);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<UserList> searchAndFilterUsers(String search, String genderFilter, String roleFilter, String statusFilter, String sortBy, String sortOrder, int rowsPerPage) {
        List<UserList> list = new ArrayList<>();

        // Validate sortBy parameter để tránh SQL injection
        // Danh sách các cột được phép sắp xếp
        String[] allowedColumns = {"Id", "FullName", "Gender", "Email", "Mobile", "Role", "Status"};
        boolean isValidColumn = false;
        for (String col : allowedColumns) {
            if (col.equals(sortBy)) {
                isValidColumn = true;
                break;
            }
        }
        if (!isValidColumn) {
            sortBy = "Id"; // Fallback nếu cột không hợp lệ
        }
        
        // Validate sortOrder parameter
        if (sortOrder != null && !sortOrder.equalsIgnoreCase("asc") && !sortOrder.equalsIgnoreCase("desc")) {
            sortOrder = "asc"; // Default fallback
        }
        
        
        // Xây dựng câu lệnh SQL động với các tham số tìm kiếm và lọc
        String sql = """
                     SELECT * FROM Users WHERE (FullName LIKE ? OR Email LIKE ? OR Mobile LIKE ?) 
                     AND (? = '' OR Gender = ?) 
                     AND (? = '' OR Role LIKE ?) 
                     AND (? = '' OR Status LIKE ?) 
                     """;

        // Thêm phần ORDER BY nếu có tham số sắp xếp
        if (sortBy != null && !sortBy.isEmpty() && sortOrder != null && !sortOrder.isEmpty()) {
            sql += "ORDER BY " + sortBy + " " + sortOrder;
        }
        
        if (rowsPerPage > 0) {
            sql += " LIMIT ?";
        }
        
        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Thiết lập các tham số vào PreparedStatement
            stmt.setString(1, "%" + search + "%");  // Tìm kiếm theo FullName
            stmt.setString(2, "%" + search + "%");  // Tìm kiếm theo Email
            stmt.setString(3, "%" + search + "%");  // Tìm kiếm theo Mobile
            
            // Fix logic filter cho Gender
            // Fix logic filter cho Gender
            stmt.setString(4, genderFilter);        
            stmt.setInt(5, genderFilter.isEmpty() || genderFilter.equals("A") ? 0 : Integer.parseInt(genderFilter));

            stmt.setString(6, roleFilter);          // Kiểm tra roleFilter có rỗng không
            stmt.setString(7, "%" + roleFilter + "%");    // Role filter
            
            stmt.setString(8, statusFilter);        // Kiểm tra statusFilter có rỗng không
            stmt.setString(9, "%" + statusFilter + "%");  // Status filter

            if (rowsPerPage > 0) {
                stmt.setInt(10, rowsPerPage);
            }
            
            // Thực thi câu lệnh SQL và lấy dữ liệu từ cơ sở dữ liệu
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    UserList ul = new UserList(
                        rs.getInt("Id"),
                        rs.getString("FullName"),
                        rs.getInt("Gender"),
                        rs.getString("Email"),
                        rs.getString("Mobile"),
                        rs.getString("Password"),  // Thêm Password
                        rs.getString("Role"),
                        rs.getString("Status")
                    );
                    list.add(ul);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public boolean addUser(UserList user) {
        String sql = "INSERT INTO Users (FullName, Gender, Email, Mobile, Password, Role, Status) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getFullName());
            stmt.setInt(2, user.getGender());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getMobile());
            stmt.setString(5, user.getPassword());
            stmt.setString(6, user.getRole());
            stmt.setString(7, user.getStatus());

            int result = stmt.executeUpdate();
            return result > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 1. Phương thức lấy thông tin user theo ID
    public UserList getUserById(int id) {
        String sql = "SELECT * FROM Users WHERE Id = ?";

        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new UserList(
                        rs.getInt("Id"),
                        rs.getString("FullName"),
                        rs.getInt("Gender"), 
                        rs.getString("Email"),
                        rs.getString("Mobile"),
                        rs.getString("Password"),  // Thêm Password
                        rs.getString("Role"),
                        rs.getString("Status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 2. Phương thức update Role và Status của user
    public boolean updateUserRoleStatus(int id, String role, String status) {
        String sql = "UPDATE Users SET Role = ?, Status = ? WHERE Id = ?";

        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, role);
            stmt.setString(2, status);
            stmt.setInt(3, id);

            int result = stmt.executeUpdate();
            return result > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}