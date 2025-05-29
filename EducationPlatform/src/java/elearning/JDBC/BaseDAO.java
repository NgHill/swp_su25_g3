/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package elearning.JDBC;

/**
 *
 * @author admin
 */
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author admin
 */
public interface BaseDAO<T, K> {

    T mapRow(ResultSet rs) throws SQLException, ClassNotFoundException;

    boolean insert(T t) throws SQLException, ClassNotFoundException;

    List<T> getAll() throws SQLException, ClassNotFoundException;

    T getById(K id) throws SQLException, ClassNotFoundException;

    boolean update(T t) throws SQLException, ClassNotFoundException;
    
    boolean deleteById(K id) throws SQLException, ClassNotFoundException;
}
