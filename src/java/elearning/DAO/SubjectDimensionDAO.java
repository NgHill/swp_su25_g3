// SubjectDimensionDAO.java
package elearning.DAO;

import elearning.JDBC.GenericDAO;
import elearning.entities.SubjectDimension;

public class SubjectDimensionDAO extends GenericDAO<SubjectDimension, Integer> {
    public SubjectDimensionDAO() {
        super(SubjectDimension.class);
    }
}
