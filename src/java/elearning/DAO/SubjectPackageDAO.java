// SubjectPackageDAO.java
package elearning.DAO;

import elearning.JDBC.GenericDAO;
import elearning.entities.SubjectPackage;

public class SubjectPackageDAO extends GenericDAO<SubjectPackage, Integer> {
    public SubjectPackageDAO() {
        super(SubjectPackage.class);
    }
}
