// QuizResultDAO.java
package elearning.DAO;

import elearning.JDBC.GenericDAO;
import elearning.anotation.FindBy;
import elearning.anotation.Query;
import elearning.entities.QuizResult;
import elearning.entities.User;
import java.math.BigDecimal;
import java.security.Timestamp;
import java.sql.SQLException;
import java.util.List;

public class QuizResultDAO extends GenericDAO<QuizResult, Integer> {
    public QuizResultDAO() {
        super(QuizResult.class);
    }   
    }
    
