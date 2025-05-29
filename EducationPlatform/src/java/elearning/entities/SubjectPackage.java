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
@Table(name = "SubjectPackages")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class SubjectPackage {

    @Id
    @Column(name = "Id")
    Integer id;
    @Column(name = "Title")
    String title;
    @Column(name = "Description")
    String description;
    @Column(name = "Thumbnail")
    String thumbnail;
    @Column(name = "LowestPrice")
    Double lowestPrice;
    @Column(name = "OriginalPrice")
    Double originalPrice;
    @Column(name = "SalePrice")
    Double salePrice;
    @Column(name = "OwnerId")
    Integer ownerId;
    @Column(name = "Category")
    String category;
    @Column(name = "Status")
    String status;
    @Column(name = "CreatedAt")
    Date createdAt;
}
