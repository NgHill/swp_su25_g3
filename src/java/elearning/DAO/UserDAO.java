/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elearning.DAO;

import elearning.JDBC.GenericDAO;
import elearning.anotation.FindBy;
import elearning.anotation.Query;
import elearning.entities.User;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author admin
 */
public class UserDAO extends GenericDAO<User, Integer>{
    
    public UserDAO() {
        super(User.class);
    }
    
    @FindBy(columns = {"Email","Password"})
    public User findByEmailAndPassword(String email, String password) throws SQLException{
        List<User> users = findByAnd(email, password);
        if(users.isEmpty()){
            return null;
        }
        return users.get(0);
    }
    
    @Query(sql = """
                 select * from Users where Mobile = ? and Password = ?
                 """)
    public User findByMobileAndPassword(String mobile, String password) throws SQLException{
        List<User> users = executeQueryFind(mobile, password);
        
        if(users.isEmpty()){
            return null;
        }
        return users.get(0);
    }
    
    @Query(sql = """
                 delete from Users where Mobile = ?
                 """)
    public boolean deleteByMobile(String mobile) throws SQLException{
        return executeQueryUpdateOrCheck(mobile);
    }
    
}
