// QuizQuestionDAO.java
package elearning.DAO;

import elearning.JDBC.GenericDAO;
import elearning.entities.QuizQuestion;

public class QuizQuestionDAO extends GenericDAO<QuizQuestion, Integer> {
    public QuizQuestionDAO() {
        super(QuizQuestion.class);
    }
}
