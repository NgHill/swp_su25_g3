// SliderDAO.java
package elearning.DAO;

import elearning.JDBC.GenericDAO;
import elearning.entities.Slider;

public class SliderDAO extends GenericDAO<Slider, Integer> {
    public SliderDAO() {
        super(Slider.class);
    }
}
