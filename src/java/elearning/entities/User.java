/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elearning.entities;

import elearning.anotation.*;
import elearning.anotation.Table;
import java.util.Date;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.FieldDefaults;

/**
 *
 * @author admin
 */
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Getter
@Setter
@Table(name = "Users")
public class User {

    @Id
    @Column(name = "Id")
    Integer id;
    @Column(name = "FullName")
    String fullName;
    @Column(name = "Email")
    String email;
    @Column(name = "Mobile")
    String mobile;
    @Column(name = "Password")
    String password;
    @Column(name = "Gender")
    boolean gender;
    @Column(name = "Avatar")
    String avatar;
    @Column(name = "Role")
    String role;
    @Column(name = "Status")
    String status;
    @Column(name = "ActiveCode")
    String activeCode;
    @Column(name = "CreatedAt")
    Date createdAt;
}
