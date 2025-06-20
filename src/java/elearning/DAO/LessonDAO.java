// LessonDAO.java
package elearning.DAO;

import elearning.JDBC.GenericDAO;
import elearning.entities.Lesson;

public class LessonDAO extends GenericDAO<Lesson, Integer> {
    public LessonDAO() {
        super(Lesson.class);
    }
}
