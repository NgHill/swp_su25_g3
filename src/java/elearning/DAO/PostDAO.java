// PostDAO.java
package elearning.DAO;

import elearning.JDBC.GenericDAO;
import elearning.entities.Post;

public class PostDAO extends GenericDAO<Post, Integer> {
    public PostDAO() {
        super(Post.class);
    }
}
