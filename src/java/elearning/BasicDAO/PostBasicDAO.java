// PostBasicDAO.java
package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.Post;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostBasicDAO {

    private final Connection connection;

    public PostBasicDAO() {
        this.connection = ServerConnectionInfo.CONNECTION;
    }

    /**
     * Thêm một bài viết mới vào cơ sở dữ liệu.
     *
     * @param post Bài viết cần thêm
     * @return true nếu thêm thành công, false nếu thất bại
     * @throws SQLException nếu có lỗi truy vấn
     */
    public boolean insert(Post post) {
        String sql = "INSERT INTO Posts (Title, Image, Content, Thumbnail, Description, Category, AuthorId, Status, CreatedAt) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURDATE())";
        try (
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, post.getTitle());
            ps.setString(2, post.getImage());  // Optional field, currently can be null
            ps.setString(3, post.getContent());
            ps.setString(4, post.getThumbnail());
            ps.setString(5, post.getDescription());
            ps.setString(6, post.getCategory());
            ps.setInt(7, post.getAuthorId());
            ps.setString(8, post.getStatus());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public static void main(String[] args) throws SQLException {
        System.out.println(new PostBasicDAO().getAll().get(0).getAuthor().getFullName());
    }
    

    /**
     * Lấy toàn bộ danh sách bài viết từ bảng Posts.
     *
     * @return Danh sách các bài viết
     * @throws SQLException nếu có lỗi truy vấn
     */
    public List<Post> getAll() throws SQLException {
        String sql = "SELECT * FROM `Posts`";
        List<Post> posts = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            // Duyệt qua từng dòng kết quả và chuyển sang đối tượng Post
            while (rs.next()) {
                posts.add(mapRow(rs));
            }
        }
        return posts;
    }

    /**
     * Lấy danh sách tất cả các danh mục (Category) không trùng lặp từ bảng
     * Posts.
     *
     * @return Danh sách danh mục
     * @throws SQLException nếu có lỗi truy vấn
     */
    public List<String> getAllCategory() throws SQLException {
        String sql = "SELECT distinct Category FROM `Posts` ";
        List<String> cates = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                cates.add(rs.getString(1)); // Lấy giá trị cột Category
            }
        }
        return cates;
    }

    /**
     * Tìm bài viết theo ID.
     *
     * @param id ID của bài viết
     * @return Đối tượng Post nếu tìm thấy, null nếu không
     * @throws SQLException nếu có lỗi truy vấn
     */
    public Post getById(Integer id) throws SQLException {
        String sql = "SELECT * FROM `Posts` WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id); // Gán ID vào câu truy vấn
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs); // Chuyển dòng kết quả thành Post
                }
            }
        }
        return null;
    }

    /**
     * Cập nhật thông tin bài viết trong cơ sở dữ liệu.
     *
     * @param post Bài viết cần cập nhật
     * @return true nếu cập nhật thành công
     * @throws SQLException nếu có lỗi truy vấn
     */
    public boolean update(Post post) throws SQLException {
        String sql = "UPDATE `Posts` SET `Title` = ?, `Image` = ?, `Content` = ?, `Thumbnail` = ?, `Category` = ?, `AuthorId` = ?, `Status` = ?, `CreatedAt` = ? WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, post.getTitle());
            stmt.setString(2, post.getImage());
            stmt.setString(3, post.getContent());
            stmt.setString(4, post.getThumbnail());
            stmt.setString(5, post.getCategory());
            stmt.setInt(6, post.getAuthorId());
            stmt.setString(7, post.getStatus());
            stmt.setTimestamp(8, post.getCreatedAt() != null ? new Timestamp(post.getCreatedAt().getTime()) : null);
            stmt.setInt(9, post.getId()); // Gán ID của bài viết cần cập nhật

            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Xóa bài viết khỏi cơ sở dữ liệu theo ID.
     *
     * @param id ID của bài viết cần xóa
     * @return true nếu xóa thành công
     * @throws SQLException nếu có lỗi truy vấn
     */
    public boolean deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM `Posts` WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id); // Gán ID vào câu truy vấn
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Chuyển đổi một dòng từ ResultSet thành đối tượng Post.
     *
     * @param rs Kết quả truy vấn
     * @return Đối tượng Post tương ứng với dòng dữ liệu
     * @throws SQLException nếu có lỗi truy cập dữ liệu
     */
    private Post mapRow(ResultSet rs) throws SQLException {
        return Post.builder()
                .id(rs.getInt("Id"))
                .title(rs.getString("Title"))
                .image(rs.getString("Image"))
                .content(rs.getString("Content"))
                .thumbnail(rs.getString("Thumbnail"))
                .category(rs.getString("Category"))
                .authorId(rs.getInt("AuthorId"))
                .status(rs.getString("Status"))
                .createdAt(rs.getTimestamp("CreatedAt"))
                .build();
    }

}
