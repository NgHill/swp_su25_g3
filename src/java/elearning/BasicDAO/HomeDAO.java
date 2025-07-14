/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elearning.BasicDAO;
import elearning.constant.ServerConnectionInfo;
import elearning.entities.HomeFeatureSubject;
import elearning.entities.HomePost;
import elearning.entities.HomeSlider;
import java.util.ArrayList;
import java.util.List;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


/**
 *
 * @author Lenovo
 */
public class HomeDAO {
        public List<HomePost> getHotPosts() {
            List<HomePost> list = new ArrayList<>();
            String sql = "SELECT * FROM posts WHERE Status = 'published' ORDER BY ViewCount DESC LIMIT 3";

            try (Connection conn = ServerConnectionInfo.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    HomePost p = new HomePost(
                        rs.getInt("Id"),
                        rs.getString("Title"),
                        rs.getString("Content"),
                        rs.getString("Thumbnail"),
                        rs.getString("Category"),
                        rs.getInt("AuthorId"),
                        rs.getString("Status"),
                        rs.getTimestamp("CreatedAt")
                    );
                    list.add(p);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

            return list;
        }

            public List<HomePost> getLatestPosts() {
            List<HomePost> list = new ArrayList<>();
            String sql = "SELECT * FROM posts WHERE Status = 'published' ORDER BY CreatedAt DESC LIMIT 3";

            try (Connection conn = ServerConnectionInfo.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    HomePost p = new HomePost(
                        rs.getInt("Id"),
                        rs.getString("Title"),
                        rs.getString("Content"),
                        rs.getString("Thumbnail"),
                        rs.getString("Category"),
                        rs.getInt("AuthorId"),
                        rs.getString("Status"),
                        rs.getTimestamp("CreatedAt")
                    );
                    list.add(p);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

            return list;
        }
        
            public List<HomeSlider> getHomepageSliders() {
                List<HomeSlider> list = new ArrayList<>();
                String sql = "SELECT * FROM sliders WHERE Type = 'promotion' ORDER BY OrderNumber LIMIT 5";

                try (Connection conn = ServerConnectionInfo.getConnection();
                     PreparedStatement stmt = conn.prepareStatement(sql);
                     ResultSet rs = stmt.executeQuery()) {

                    while (rs.next()) {
                        HomeSlider s = new HomeSlider(
                            rs.getInt("Id"),
                            rs.getString("Image"),
                            rs.getString("Title"),
                            rs.getString("Description"),
                            rs.getString("Type"),
                            rs.getInt("OrderNumber")
                        );
                        list.add(s);
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                }

                return list;
            }
            
            public List<HomeFeatureSubject> getFeaturedSubjects() {
            List<HomeFeatureSubject> list = new ArrayList<>();
            String sql = "SELECT Id, Title, Description, Thumbnail FROM subjectpackages WHERE Status = 'published' ORDER BY Id LIMIT 3";

            try (Connection conn = ServerConnectionInfo.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    HomeFeatureSubject s = new HomeFeatureSubject(
                        rs.getInt("Id"),
                        rs.getString("Title"),
                        rs.getString("Description"),
                        rs.getString("Thumbnail")
                    );
                    list.add(s);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

            return list;
        }

        }
    

