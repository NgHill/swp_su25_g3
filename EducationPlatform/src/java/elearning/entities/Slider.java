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
@Table(name = "Sliders")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Slider {

    @Id
    @Column(name = "Id")
    Integer id;
    @Column(name = "Image")
    String image;
    @Column(name = "Title")
    String title;
    @Column(name = "Description")
    String description;
    @Column(name = "Type")
    String type;
    @Column(name = "OrderNumber")
    Integer orderNumber;
}
