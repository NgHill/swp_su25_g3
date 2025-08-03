package elearning.BasicDAO;

import elearning.entities.SubjectList;
import elearning.constant.ServerConnectionInfo;
import elearning.entities.SubjectPackage;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * <h2>SubjectListDAO</h2>
 * Final, DB‑verified implementation – maps exactly to the columns visible in
 * your current <code>subjects</code> table (see screenshot):
 * <pre>
 * id | name | category | number_of_lesson | owner | status | featured | thumbnail_url | description
 * </pre>
 * <p>
 * Optional <code>created_at</code>/<code>updated_at</code> are included <i>only
 * if those columns exist</i>; otherwise comment out the two lines that touch
 * them.
 * </p>
 */
public class SubjectListDAO {

    /* ==============================================================
       INSERT
       ============================================================== */
    /**
     * Add new subject – uses the exact column list above. No NEED to set
     * <code>id</code> (auto‑increment) nor <code>created_at / updated_at</code>
     * if they don’t exist.
     */
    public boolean addSubject(SubjectPackage s) {
        final String sql = "INSERT INTO SubjectPackages "
                + "(Title, Category, OwnerId, Status, Thumbnail, Description, BriefInfo, Tagline, LowestPrice, OriginalPrice, SalePrice) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection c = ServerConnectionInfo.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, s.getTitle()); // Title
            ps.setString(2, s.getCategory());
            ps.setInt(3, s.getOwnerId());
            ps.setString(4, s.getStatus() == null ? "published" : s.getStatus());
            ps.setString(5, s.getThumbnail());
            ps.setString(6, s.getDescription());
            ps.setString(7, s.getBriefInfo());
            ps.setString(8, s.getTagLine());
            ps.setDouble(9, s.getLowestPrice());
            ps.setDouble(10, s.getOriginalPrice());
            ps.setDouble(11, s.getSalePrice());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        s.setId(rs.getInt(1));
                    }
                }
            }
            return affected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /* ==============================================================
       SELECT – paginated & filtered
       ============================================================== */
    public List<SubjectPackage> getFilteredSubjects(String category, String status, String search, int offset, int limit) {
        List<SubjectPackage> list = new ArrayList<>();
        String sql = "SELECT * FROM educationplatform.subjectpackages WHERE 1=1";

        if (category != null && !category.isEmpty()) {
            sql += " AND category = ?";
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND status = ?";
        }
        if (search != null && !search.isEmpty()) {
            sql += " AND title LIKE ?";
        }

        sql += " LIMIT ? OFFSET ?";// Giới hạn số dòng 

        try {
            PreparedStatement ps = ServerConnectionInfo.getConnection().prepareStatement(sql);
            int idx = 1;
            if (category != null && !category.isEmpty()) {
                ps.setString(idx++, category);
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, status);
            }
            if (search != null && !search.isEmpty()) {
                ps.setString(idx++, "%" + search + "%");
            }
            ps.setInt(idx++, limit);// Gán giá trị vào LIMIT
            ps.setInt(idx, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SubjectPackage s = SubjectPackage.builder()
                        .id(rs.getInt("id"))
                        .title(rs.getString("title"))
                        .category(rs.getString("category"))
                        .briefInfo(rs.getString("briefinfo"))
                        .ownerId(rs.getInt("ownerid"))
                        .status(rs.getString("status"))
                        .thumbnail(rs.getString("thumbnail"))
                        .description(rs.getString("description"))
                        .createdAt(rs.getTimestamp("createdat"))
                        .originalPrice(rs.getDouble("originalPrice"))
                        .build();
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public static void main(String[] args) {
        System.out.println(new SubjectListDAO().getFilteredSubjects("", "", "", 1, 10));
    }

    public int getTotalFilteredSubjects(String category, String status, String search) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM subjects WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (category != null && !category.isBlank()) {
            sql.append(" AND category = ?");
            params.add(category);
        }
        if (status != null && !status.isBlank()) {
            sql.append(" AND status = ?");
            params.add(status);
        }
        if (search != null && !search.isBlank()) {
            sql.append(" AND name LIKE ?");
            params.add('%' + search + '%');
        }

        try (Connection c = ServerConnectionInfo.getConnection(); PreparedStatement ps = c.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<String> getAllCategory() {
        final String sql = "SELECT DISTINCT category FROM subjectpackages ORDER BY category";
        List<String> cats = new ArrayList<>();
        try (Connection c = ServerConnectionInfo.getConnection(); PreparedStatement ps = c.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                cats.add(rs.getString(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cats;
    }

    /* ==============================================================
       UPDATE / DELETE
       ============================================================== */
    public boolean updateSubject(SubjectList s) {
        final String sql = "UPDATE subjects SET name=?, category=?, number_of_lesson=?, owner=?, status=?, "
                + "featured=?, thumbnail_url=?, description=? WHERE id=?";
        try (Connection c = ServerConnectionInfo.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, s.getName());
            ps.setString(2, s.getCategory());
            ps.setInt(3, s.getLessons());
            ps.setString(4, s.getOwner());
            ps.setString(5, s.getStatus());
            ps.setBoolean(6, s.isFeatured());
            ps.setString(7, s.getThumbnailUrl());
            ps.setString(8, s.getDescription());
            ps.setInt(9, s.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteSubject(int id) {
        try (Connection c = ServerConnectionInfo.getConnection(); PreparedStatement ps = c.prepareStatement("DELETE FROM subjectpackages WHERE id=?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /* ==============================================================
       INTERNAL – map ResultSet → Entity
       ============================================================== */
    private SubjectList mapRow(ResultSet rs) throws SQLException {
        return SubjectList.builder()
                .id(rs.getInt("id"))
                .name(rs.getString("name"))
                .category(rs.getString("category"))
                .lessons(rs.getInt("number_of_lesson"))
                .owner(rs.getString("owner"))
                .status(rs.getString("status"))
                .featured(rs.getBoolean("featured"))
                .thumbnailUrl(rs.getString("thumbnail_url"))
                .description(rs.getString("description"))
                // safely read timestamps only if they exist
                .createdAt(getTimestampIfExists(rs, "created_at"))
                .updatedAt(getTimestampIfExists(rs, "updated_at"))
                .build();
    }

    private java.sql.Timestamp getTimestampIfExists(ResultSet rs, String col) {
        try {
            rs.findColumn(col);
            return rs.getTimestamp(col);
        } catch (SQLException e) {
            return null;
        }
    }

    public SubjectPackage getSubjectById(int id) {
        String sql = "SELECT * FROM subjectpackages WHERE id = ?";
        try (PreparedStatement ps = ServerConnectionInfo.getConnection().prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return SubjectPackage.builder()
                        .id(rs.getInt("id"))
                        .title(rs.getString("title"))
                        .category(rs.getString("category"))
                        .briefInfo(rs.getString("briefinfo"))
                        .ownerId(rs.getInt("ownerid"))
                        .status(rs.getString("status"))
                        .thumbnail(rs.getString("thumbnail"))
                        .description(rs.getString("description"))
                        .createdAt(rs.getTimestamp("createdat"))
                        .originalPrice(rs.getDouble("originalPrice"))
                        .lowestPrice(rs.getDouble("lowestPrice"))
                        .salePrice(rs.getDouble("salePrice"))
                        .tagLine(rs.getString("tagline"))
                        .build();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateSubject2(SubjectPackage subject) {
        String sql = "UPDATE subjectpackages SET title = ?, category = ?, OwnerId = ?, Status = ?, Thumbnail = ?, "
                + "Description = ?, BriefInfo = ?, Tagline = ?, LowestPrice = ?, OriginalPrice= ? ,SalePrice = ?  WHERE id = ?";

        try (PreparedStatement ps = ServerConnectionInfo.getConnection().prepareStatement(sql)) {
            ps.setString(1, subject.getTitle());
            ps.setString(2, subject.getCategory());
            ps.setInt(3, subject.getOwnerId());
            ps.setString(4, subject.getStatus());
            ps.setString(5, subject.getThumbnail());
            ps.setString(6, subject.getDescription());
            ps.setString(7, subject.getBriefInfo());
            ps.setString(8, subject.getTagLine());
            ps.setDouble(9, subject.getLowestPrice());
            ps.setDouble(10, subject.getOriginalPrice());
            ps.setDouble(11, subject.getSalePrice());
            ps.setInt(12, subject.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
