/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.erpcolegio.dao;

import com.erpcolegio.modelo.GradoSeccionAnio;
import com.erpcolegio.util.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class GradoSeccionAnioDAO {
    // insertar
    public boolean registrar(GradoSeccionAnio gsa) {
        String sql = "INSERT INTO grado_seccion_anio (fk_grado, fk_seccion, fk_anio, vacantes, turno) VALUES (?, ?, ?, ?, ?)";
        ConexionDB db = new ConexionDB();
        
        try (Connection con = db.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, gsa.getFkGrado());
            ps.setInt(2, gsa.getFkSeccion());
            ps.setInt(3, gsa.getFkAnio());
            ps.setInt(4, gsa.getVacantes());
            ps.setString(5, gsa.getTurno());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al registrar aula: " + e.getMessage());
            return false;
        }
    }
    
    //leer 
    public List<GradoSeccionAnio> listarAulasConfiguradas() {
        List<GradoSeccionAnio> lista = new ArrayList<>();
        String sql = "SELECT * FROM vw_aulas_configuradas";
        ConexionDB db = new ConexionDB();
        
        try (Connection con = db.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                GradoSeccionAnio gsa = new GradoSeccionAnio();
                gsa.setIdGradoSeccionAnio(rs.getInt("idGradoSeccionAnio"));
                gsa.setAnioLectivoStr(rs.getString("anio"));
                gsa.setNivelStr(rs.getString("nivel_grado"));
                gsa.setGradoInt(rs.getInt("grado"));
                gsa.setSeccionStr(rs.getString("nombre_seccion"));
                gsa.setTurno(rs.getString("turno"));
                gsa.setVacantes(rs.getInt("vacantes"));
                gsa.setVacantesOcupadas(rs.getInt("vacantes_ocupadas"));
                lista.add(gsa);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar aulas configuradas: " + e.getMessage());
        }
        return lista;
    }
}
