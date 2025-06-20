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
@Table(name = "SubjectDimensions")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class SubjectDimension {

    @Id
    @Column(name = "Id")
    Integer id;
    @Column(name = "SubjectId")
    Integer subjectId;
    @Column(name = "Name")
    String name;
    @Column(name = "Type")
    String type;
    @Column(name = "Description")
    String description;
}
