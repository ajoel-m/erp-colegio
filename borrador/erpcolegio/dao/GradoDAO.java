/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.erpcolegio.dao;

import com.erpcolegio.modelo.Grado;
import com.erpcolegio.util.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class GradoDAO {
    public List<Grado> listarPorNivel(String nivel) {
        List<Grado> lista = new ArrayList<>();
        String sql = "SELECT idGrado, nivel_grado, grado FROM grados WHERE nivel_grado = ? ORDER BY grado ASC";
        ConexionDB db = new ConexionDB();
        
        try (Connection con = db.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, nivel);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Grado g = new Grado();
                    g.setIdGrado(rs.getInt("idGrado"));
                    g.setNivelGrado(rs.getString("nivel_grado"));
                    g.setGrado(rs.getInt("grado"));
                    lista.add(g);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al listar grados: " + e.getMessage());
        }
        return lista;
    }
}
