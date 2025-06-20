// RegistrationDAO.java
package elearning.DAO;

import elearning.JDBC.GenericDAO;
import elearning.anotation.FindBy;
import elearning.entities.Registration;
import java.sql.SQLException;
import java.util.List;

public class RegistrationDAO extends GenericDAO<Registration, Integer> {

    public RegistrationDAO() {
        super(Registration.class);
    }

    @FindBy(columns = {"UserId"})
    public List<Registration> findByUserId(Integer userId) throws SQLException {
        return findByAnd(userId);
    }
}
