// QuizDAO.java
package elearning.DAO;

import elearning.JDBC.GenericDAO;
import elearning.entities.Quiz;

public class QuizDAO extends GenericDAO<Quiz, Integer> {
    public QuizDAO() {
        super(Quiz.class);
    }
}
