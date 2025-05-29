// QuizResultDAO.java
package elearning.DAO;

import elearning.JDBC.GenericDAO;
import elearning.entities.QuizResult;

public class QuizResultDAO extends GenericDAO<QuizResult, Integer> {
    public QuizResultDAO() {
        super(QuizResult.class);
    }
}
