/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.erpcolegio.dao;
import com.erpcolegio.modelo.Seccion;
import com.erpcolegio.util.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SeccionDAO {
    public List<Seccion> listarTodas() {
        List<Seccion> lista = new ArrayList<>();
        String sql = "SELECT idSeccion, nombre_seccion FROM secciones ORDER BY nombre_seccion ASC";
        ConexionDB db = new ConexionDB();
        
        try (Connection con = db.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                Seccion s = new Seccion();
                s.setIdSeccion(rs.getInt("idSeccion"));
                s.setNombreSeccion(rs.getString("nombre_seccion"));
                lista.add(s);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar secciones: " + e.getMessage());
        }
        return lista;
    }
}
