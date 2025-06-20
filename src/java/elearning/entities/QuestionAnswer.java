/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elearning.entities;

import elearning.anotation.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

/**
 *
 * @author admin
 */
@Table(name = "QuestionAnswers")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class QuestionAnswer {

    @Id
    @Column(name = "Id")
    Integer id;
    @Column(name = "QuestionId")
    Integer questionId;
    @Column(name = "Content")
    String content;
    @Column(name = "IsCorrect")
    Boolean isCorrect;
    @Column(name = "Explanation")
    String explanation;
}
