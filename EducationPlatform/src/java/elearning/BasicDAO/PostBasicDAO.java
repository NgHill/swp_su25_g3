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

    public boolean insert(Post post) throws SQLException {
        String sql = "INSERT INTO `Posts` (`Title`, `Image`, `Content`, `Thumbnail`, `Category`, `AuthorId`, `Status`, `CreatedAt`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, post.getTitle());
            stmt.setString(2, post.getImage());
            stmt.setString(3, post.getContent());
            stmt.setString(4, post.getThumbnail());
            stmt.setString(5, post.getCategory());
            stmt.setInt(6, post.getAuthorId());
            stmt.setString(7, post.getStatus());
            stmt.setTimestamp(8, post.getCreatedAt() != null ? new Timestamp(post.getCreatedAt().getTime()) : null);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Post> getAll() throws SQLException {
        String sql = "SELECT * FROM `Posts`";
        List<Post> posts = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                posts.add(mapRow(rs));
            }
        }
        return posts;
    }

    public Post getById(Integer id) throws SQLException {
        String sql = "SELECT * FROM `Posts` WHERE `Id` = ?";
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
            stmt.setInt(9, post.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM `Posts` WHERE `Id` = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

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