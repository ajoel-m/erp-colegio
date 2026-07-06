/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.erpcolegio.dao;

import com.erpcolegio.modelo.Usuario;
import com.erpcolegio.util.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAO {
    public Usuario autenticar(String username, String passwordHash) {
        Usuario usuario = null;
        String sql = "SELECT u.idUsuario, u.username, u.fk_rol, u.fk_colaborador, r.nombre_rol "
                   + "FROM usuarios u "
                   + "INNER JOIN roles r ON u.fk_rol = r.idRol "
                   + "WHERE u.username = ? AND u.password_hash = ? AND u.estado = 1";
                   
        ConexionDB db = new ConexionDB();
        
        try (Connection con = db.conectar(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, username);
            ps.setString(2, passwordHash);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setIdUsuario(rs.getInt("idUsuario"));
                    usuario.setUsername(rs.getString("username"));
                    usuario.setFkRol(rs.getInt("fk_rol"));
                    
                    int idColaborador = rs.getInt("fk_colaborador");
                    usuario.setFkColaborador(rs.wasNull() ? null : idColaborador);
                    
                    usuario.setNombreRol(rs.getString("nombre_rol"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error en autenticación: " + e.getMessage());
        }
        return usuario;
    }
}
