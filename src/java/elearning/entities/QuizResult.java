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
@Table(name = "QuizResults")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class QuizResult {

    @Id
    @Column(name = "Id")
    Integer id;
    @Column(name = "UserId")
    Integer userId;
    @Column(name = "QuizId")
    Integer quizId;
    @Column(name = "Score")
    Double score;
    @Column(name = "SubmittedAt")
    Date submittedAt;
}
