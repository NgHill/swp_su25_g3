// QuestionDAO.java
package elearning.DAO;

import elearning.JDBC.GenericDAO;
import elearning.entities.Question;

public class QuestionDAO extends GenericDAO<Question, Integer> {
    public QuestionDAO() {
        super(Question.class);
    }
}
