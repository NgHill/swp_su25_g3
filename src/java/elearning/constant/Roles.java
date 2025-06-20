/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package elearning.constant;

import java.util.Arrays;

/**
 *
 * @author admin
 */
public enum Roles {
    ADMIN, 
    CHAIRMAN, 
    VICE_CHAIRMAN, 
    TEAM_LEADER, 
    MEMBER;
    public static String[] getNames() {
        return Arrays.stream(Roles.values())
                     .map(Roles::name)
                     .toArray(String[]::new);
    }
}
