/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.erpcolegio.modelo;


public class Usuario {
    private int idUsuario;
    private String username;
    private int fkRol;
    private Integer fkColaborador; // permite null si es el superadmin
    private String nombreRol;
    
    public Usuario() {}

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public int getFkRol() { return fkRol; }
    public void setFkRol(int fkRol) { this.fkRol = fkRol; }

    public Integer getFkColaborador() { return fkColaborador; }
    public void setFkColaborador(Integer fkColaborador) { this.fkColaborador = fkColaborador; }
    
    public String getNombreRol() { return nombreRol; }
    public void setNombreRol(String nombreRol) { this.nombreRol = nombreRol; }
}
