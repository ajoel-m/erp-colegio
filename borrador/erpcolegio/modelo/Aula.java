/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.erpcolegio.modelo;


public class Aula {
    private int idAula;
    private int fkAnioLectivo;
    private String nivel;    
    private String grado;  
    private String seccion;
    private String turno;  
    private int vacantesTotales;
    private int vacantesOcupadas;
    
    public Aula() {}

    public int getIdAula() { return idAula; }
    public void setIdAula(int idAula) { this.idAula = idAula; }

    public int getFkAnioLectivo() { return fkAnioLectivo; }
    public void setFkAnioLectivo(int fkAnioLectivo) { this.fkAnioLectivo = fkAnioLectivo; }

    public String getNivel() { return nivel; }
    public void setNivel(String nivel) { this.nivel = nivel; }

    public String getGrado() { return grado; }
    public void setGrado(String grado) { this.grado = grado; }

    public String getSeccion() { return seccion; }
    public void setSeccion(String seccion) { this.seccion = seccion; }

    public String getTurno() { return turno; }
    public void setTurno(String turno) { this.turno = turno; }

    public int getVacantesTotales() { return vacantesTotales; }
    public void setVacantesTotales(int vacantesTotales) { this.vacantesTotales = vacantesTotales; }

    public int getVacantesOcupadas() { return vacantesOcupadas; }
    public void setVacantesOcupadas(int vacantesOcupadas) { this.vacantesOcupadas = vacantesOcupadas; }
}
