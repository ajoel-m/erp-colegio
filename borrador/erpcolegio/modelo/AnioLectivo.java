/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.erpcolegio.modelo;

import java.sql.Date;

public class AnioLectivo {
    private int idAnioLectivo;
    private String anio;
    private Date fechaInicio;
    private Date fechaFin;
    private String estado; // vigente o finalizado

    public AnioLectivo() {}

    public int getIdAnioLectivo() { return idAnioLectivo; }
    public void setIdAnioLectivo(int idAnioLectivo) { this.idAnioLectivo = idAnioLectivo; }

    public String getAnio() { return anio; }
    public void setAnio(String anio) { this.anio = anio; }

    public Date getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(Date fechaInicio) { this.fechaInicio = fechaInicio; }

    public Date getFechaFin() { return fechaFin; }
    public void setFechaFin(Date fechaFin) { this.fechaFin = fechaFin; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }   
    
    @Override
    public String toString() {
        return anio;
    }
}
