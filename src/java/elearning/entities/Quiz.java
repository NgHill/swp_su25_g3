/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elearning.entities;

import elearning.anotation.*;
import java.util.Date;
import lombok.*;
import lombok.experimental.FieldDefaults;

/**
 *
 * @author admin
 */
@Table(name = "Quizzes")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Quiz {

    @Id
    @Column(name = "Id")
    Integer id;
    @Column(name = "Title")
    String title;
    @Column(name = "SubjectId")
    Integer subjectId;
    @Column(name = "Duration")
    Integer duration;
    @Column(name = "Status")
    String status;
    @Column(name = "CreatedAt")
    Date createdAt;
}
