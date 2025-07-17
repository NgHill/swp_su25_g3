/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elearning.entities;

import elearning.DAO.SubjectPackageDAO;
import elearning.anotation.*;
import java.util.Date;
import lombok.*;
import lombok.experimental.FieldDefaults;

/**
 *
 * @author admin
 */
@Table(name = "Registrations")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Registration {

    @Id
    @Column(name = "Id")
    Integer id;
    @Column(name = "UserId")
    Integer userId;
    @Column(name = "SubjectId")
    Integer subjectId;
    @Column(name = "Status")
    String status;

    @Column(name = "TotalCost")
    Double totalCost;
    @Column(name = "ValidFrom")
    Date validFrom;
    @Column(name = "ValidTo")
    Date validTo;
    @Column(name = "CreatedAt")
    Date createdAt;

    @Column(name = "PackageMonths")
    int packageMonths;
    
    @Column(name = "RegisteredFullName")
    String registeredFullName;

    @Column(name = "RegisteredEmail")
    String registeredEmail;

    @Column(name = "RegisteredMobile")
    String registeredMobile;

    @Column(name = "RegisteredGender")
    Boolean registeredGender;
    SubjectPackage subjectPackage;

    public void setSubjectPackageFunc() {
        try {
            this.subjectPackage = new SubjectPackageDAO().getById(this.subjectId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
