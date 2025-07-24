// DAO (Data Access Object) xử lý dữ liệu liên quan đến bảng `Sliders`
package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.Slider;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SliderBasicDAO {

    // Biến kết nối cơ sở dữ liệu, sử dụng kết nối chung từ ServerConnectionInfo
    private final Connection connection;

    // Constructor khởi tạo kết nối khi tạo đối tượng DAO
    public SliderBasicDAO() {
        this.connection = ServerConnectionInfo.CONNECTION;
    }

    // Thêm mới một slider vào database
    public boolean insert(Slider slider) throws SQLException {
        String sql = "INSERT INTO `Sliders` (`Image`, `Title`, `Description`, `Type`, `OrderNumber`) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, slider.getImage());
            stmt.setString(2, slider.getTitle());
            stmt.setString(3, slider.getDescription());
            stmt.setString(4, slider.getType());
            stmt.setInt(5, slider.getOrderNumber());
            return stmt.executeUpdate() > 0; // Trả về true nếu thêm thành công
        }
    }

    // Lấy toàn bộ danh sách slider từ bảng `Sliders`
    public List<Slider> getAll() throws SQLException {
        String sql = "SELECT * FROM `Sliders`";
        List<Slider> sliders = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                sliders.add(mapRow(rs)); // Ánh xạ từng dòng dữ liệu thành đối tượng Slider
            }
        }
        return sliders;
    }

    // Lấy một slider theo ID
    public Slider getById(Integer id) throws SQLException {
        String sql = "SELECT * FROM `Sliders` WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs); // Trả về đối tượng slider nếu tìm thấy
                }
            }
        }
        return null; // Trả về null nếu không tìm thấy
    }

    // Cập nhật slider theo ID
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

    // Xóa slider theo ID
    public boolean deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM `Sliders` WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    // Phương thức ánh xạ từ ResultSet sang đối tượng Slider
    private Slider mapRow(ResultSet rs) throws SQLException {
        return Slider.builder()
                .id(rs.getInt("Id"))
                .image(rs.getString("Image"))
                .title(rs.getString("Title"))
                .description(rs.getString("Description"))
                .type(rs.getString("Type"))
                .orderNumber(rs.getInt("OrderNumber"))
                .backlink(rs.getString("backlink")) // URL khi click vào slider
                .build();
    }

    // Lấy danh sách slider có lọc theo title và status
    public List<Slider> getFiltered(String search, String status) throws SQLException {
        List<Slider> list = new ArrayList<>();
        String sql = "SELECT * FROM Sliders WHERE 1=1"; // Bắt đầu với câu lệnh không điều kiện

        // Nếu có từ khóa tìm kiếm -> thêm điều kiện LIKE
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND title LIKE ?";
        }

        // Nếu status khác "All" -> thêm điều kiện lọc theo type
        if (status != null && !status.equalsIgnoreCase("All")) {
            sql += " AND type = ?";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int i = 1;
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(i++, "%" + search + "%");
            }
            if (status != null && !status.equalsIgnoreCase("All")) {
                ps.setString(i++, status);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Slider s = new Slider();
                s.setId(rs.getInt("id"));
                s.setTitle(rs.getString("title"));
                s.setImage(rs.getString("image"));
                s.setDescription(rs.getString("description"));
                s.setType(rs.getString("type"));
                list.add(s); // Thêm slider vào danh sách kết quả
            }
        }
        return list;
    }

    // Phương thức test nhanh DAO bằng hàm main
    public static void main(String[] args) throws SQLException {
        System.out.println(new SliderBasicDAO().getFiltered("", "Hiển thị").size());
    }
}
