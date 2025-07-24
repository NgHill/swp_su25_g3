package elearning.BasicDAO;

import elearning.constant.ServerConnectionInfo;
import elearning.entities.Post;
import elearning.entities.Slider;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class mtk_dashboardDAO {
    private Connection conn;

    public mtk_dashboardDAO() {
        conn = ServerConnectionInfo.getConnection();
    }

    public List<Post> getPagedPosts(int page, int pageSize) {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM Posts ORDER BY CreatedAt DESC LIMIT ? OFFSET ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Post p = Post.builder()
                        .id(rs.getInt("Id"))
                        .title(rs.getString("Title"))
                        .description(rs.getString("Description"))
                        .createdAt(rs.getTimestamp("CreatedAt"))
                        .build();
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countPosts() {
        String sql = "SELECT COUNT(*) FROM Posts";
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Slider> getPagedSliders(int page, int pageSize) {
        List<Slider> list = new ArrayList<>();
        String sql = "SELECT * FROM Sliders ORDER BY Id LIMIT ? OFFSET ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Slider s = Slider.builder()
                        .id(rs.getInt("Id"))
                        .title(rs.getString("Title"))
                        .image(rs.getString("Image"))
                        .description(rs.getString("Description")) // Backlink
                        .type(rs.getString("Type"))               // Status
                        .build();
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countSliders() {
        String sql = "SELECT COUNT(*) FROM Sliders";
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}