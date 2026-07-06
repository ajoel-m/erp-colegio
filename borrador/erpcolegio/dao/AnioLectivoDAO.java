/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.erpcolegio.dao;

import com.erpcolegio.modelo.AnioLectivo;
import com.erpcolegio.util.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AnioLectivoDAO {
    // insertar nuevos anios lectivos
    public boolean registrar(AnioLectivo anioLectivo) {
        String sql = "INSERT INTO anios_lectivos (anio, fecha_inicio, fecha_fin, estado) VALUES (?, ?, ?, 'VIGENTE')";
        ConexionDB db = new ConexionDB();
        
        try (Connection con = db.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, anioLectivo.getAnio());
            ps.setDate(2, anioLectivo.getFechaInicio());
            ps.setDate(3, anioLectivo.getFechaFin());
            
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al registrar año lectivo: " + e.getMessage());
            return false;
        }
    }
    
    // listar los años lectivos
    public List<AnioLectivo> listarTodos() {
        List<AnioLectivo> lista = new ArrayList<>();
        String sql = "SELECT idAnioLectivo, anio, fecha_inicio, fecha_fin, estado FROM anios_lectivos ORDER BY anio DESC";
        ConexionDB db = new ConexionDB();
        
        try (Connection con = db.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                AnioLectivo anio = new AnioLectivo();
                anio.setIdAnioLectivo(rs.getInt("idAnioLectivo"));
                anio.setAnio(rs.getString("anio"));
                anio.setFechaInicio(rs.getDate("fecha_inicio"));
                anio.setFechaFin(rs.getDate("fecha_fin"));
                anio.setEstado(rs.getString("estado"));
                lista.add(anio);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al listar años lectivos: " + e.getMessage());
        }
        return lista;
    }
    
    // obtener el año lectivo vigente
    public AnioLectivo obtenerAnioVigente() {
        AnioLectivo anioLectivo = null;
        String sql = "SELECT idAnioLectivo, anio, fecha_inicio, fecha_fin, estado FROM anios_lectivos WHERE estado = 'VIGENTE' ORDER BY idAnioLectivo DESC LIMIT 1";
        ConexionDB db = new ConexionDB();
        
        try (Connection con = db.conectar(); 
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            if (rs.next()) {
                anioLectivo = new AnioLectivo();
                anioLectivo.setIdAnioLectivo(rs.getInt("idAnioLectivo"));
                anioLectivo.setAnio(rs.getString("anio"));
                anioLectivo.setFechaInicio(rs.getDate("fecha_inicio"));
                anioLectivo.setFechaFin(rs.getDate("fecha_fin"));
                anioLectivo.setEstado(rs.getString("estado"));
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener año lectivo vigente: " + e.getMessage());
        }
        return anioLectivo;
    }
}
