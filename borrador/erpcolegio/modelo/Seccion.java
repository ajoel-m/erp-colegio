/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.erpcolegio.modelo;


public class Seccion {
    private int idSeccion;
    private String nombreSeccion;

    public int getIdSeccion() { return idSeccion; }
    public void setIdSeccion(int idSeccion) { this.idSeccion = idSeccion; }

    public String getNombreSeccion() { return nombreSeccion; }
    public void setNombreSeccion(String nombreSeccion) { this.nombreSeccion = nombreSeccion; }
    
    @Override
    public String toString() {
        return nombreSeccion;
    }
}
