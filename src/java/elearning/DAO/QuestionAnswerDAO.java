// QuestionAnswerDAO.java
package elearning.DAO;

import elearning.JDBC.GenericDAO;
import elearning.entities.QuestionAnswer;

public class QuestionAnswerDAO extends GenericDAO<QuestionAnswer, Integer> {
    public QuestionAnswerDAO() {
        super(QuestionAnswer.class);
    }
}
