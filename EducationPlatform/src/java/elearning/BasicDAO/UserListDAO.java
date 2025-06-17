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
                            rs.getString("Gender"), 
                            rs.getString("Email"), 
                            rs.getString("Mobile"), 
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

    public List<UserList> searchAndFilterUsers(String fullName, String gender, String role, String status) {
        List<UserList> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Users WHERE 1=1");
        List<String> params = new ArrayList<>();

        if (fullName != null && !fullName.trim().isEmpty()) {
            sql.append(" AND LOWER(FullName) LIKE ?");
            params.add("%" + fullName.toLowerCase() + "%");
        }

        if (gender != null && !gender.trim().isEmpty()) {
            sql.append(" AND Gender = ?");
            params.add(gender);
        }

        if (role != null && !role.trim().isEmpty()) {
            sql.append(" AND Role = ?");
            params.add(role);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ?");
            params.add(status);
        }

        try (Connection conn = ServerConnectionInfo.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setString(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    UserList ul = new UserList(
                            rs.getInt("Id"),
                            rs.getString("FullName"),
                            rs.getString("Gender"),
                            rs.getString("Email"),
                            rs.getString("Mobile"),
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
    
    
}

