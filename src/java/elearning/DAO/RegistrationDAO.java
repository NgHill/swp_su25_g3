// RegistrationDAO.java
package elearning.DAO;

import elearning.JDBC.GenericDAO;
import elearning.entities.Registration;

public class RegistrationDAO extends GenericDAO<Registration, Integer> {
    public RegistrationDAO() {
        super(Registration.class);
    }
}
