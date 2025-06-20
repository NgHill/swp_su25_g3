/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elearning.entities;

import elearning.DAO.UserDAO;
import elearning.anotation.*;
import java.util.Date;
import lombok.*;
import lombok.experimental.FieldDefaults;

/**
 *
 * @author admin
 */
@Table(name = "Posts")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Post {

    @Id
    @Column(name = "Id")
    Integer id;
    @Column(name = "Title")
    String title;
    @Column(name = "Image")
    String image;
    @Column(name = "Content")
    String content;
    @Column(name = "Thumbnail")
    String thumbnail;
    @Column(name = "Description")
    String description;
    @Column(name = "Category")
    String category;
    @Column(name = "AuthorId")
    Integer authorId;
    @Column(name = "Status")
    String status;
    @Column(name = "CreatedAt")
    Date createdAt;

    User author;

    public void setAuthorFunc() {
        try {
            this.author = new UserDAO().getById(this.authorId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public User getAuthorFunc() {
        try {
            return new UserDAO().getById(this.authorId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
