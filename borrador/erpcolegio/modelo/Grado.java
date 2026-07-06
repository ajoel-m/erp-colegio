/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.erpcolegio.modelo;


public class Grado {
    private int idGrado;
    private String nivelGrado;
    private int grado;

    public int getIdGrado() { return idGrado; }
    public void setIdGrado(int idGrado) { this.idGrado = idGrado; }

    public String getNivelGrado() { return nivelGrado; }
    public void setNivelGrado(String nivelGrado) { this.nivelGrado = nivelGrado; }

    public int getGrado() { return grado; }
    public void setGrado(int grado) { this.grado = grado; }
    
    @Override
    public String toString() {
        return grado + "° Grado";
    }
}
