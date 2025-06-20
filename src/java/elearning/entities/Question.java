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
@Table(name = "Questions")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Question {

    @Id
    @Column(name = "Id")
    Integer id;
    @Column(name = "SubjectId")
    Integer subjectId;
    @Column(name = "LessonId")
    Integer lessonId;
    @Column(name = "DimensionId")
    Integer dimensionId;
    @Column(name = "Level")
    String level;
    @Column(name = "Content")
    String content;
    @Column(name = "Media")
    String media;
    @Column(name = "Status")
    String status;
    @Column(name = "CreatedAt")
    Date createdAt;
}
