/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elearning.constant;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
/**
 *
 * @author admin
 */
public class ServerConnectionInfo {
    public static final String HOSTNAME = "localhost";
    public static final String PORT = "3306";
    public static final String DBNAME = "EducationPlatform";
    public static final String USERNAME = "root";
    public static final String PASSWORD = "123456789";
    public static final String CLASS_DRIVER = "com.mysql.cj.jdbc.Driver";
    public static final String CONNECTION_URL = "jdbc:mysql://" + HOSTNAME + ":" + PORT + "/" + DBNAME 
            + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    public static final Connection CONNECTION = getConnection();
    
    public static Connection getConnection() {
        try {
            Class.forName(CLASS_DRIVER);
            return DriverManager.getConnection(CONNECTION_URL, USERNAME, PASSWORD);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }
    public static void main(String[] args) {
        Connection conn = ServerConnectionInfo.getConnection();
        if (conn != null) {
            System.out.println("✅ Kết nối thành công với cơ sở dữ liệu!");
        } else {
            System.out.println("❌ Kết nối thất bại!");
        }
    }
}