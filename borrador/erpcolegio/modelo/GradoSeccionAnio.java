/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.erpcolegio.modelo;


public class GradoSeccionAnio {
    private int idGradoSeccionAnio;
    private int fkGrado;
    private int fkSeccion;
    private int fkAnio;
    private int vacantes;
    private String turno;
    
    // Atributos adicionales para la vw
    private String anioLectivoStr;
    private String nivelStr;
    private int gradoInt;
    private String seccionStr;
    private int vacantesOcupadas;

    public int getIdGradoSeccionAnio() { return idGradoSeccionAnio; }
    public void setIdGradoSeccionAnio(int idGradoSeccionAnio) { this.idGradoSeccionAnio = idGradoSeccionAnio; }

    public int getFkGrado() { return fkGrado; }
    public void setFkGrado(int fkGrado) { this.fkGrado = fkGrado; }

    public int getFkSeccion() { return fkSeccion; }
    public void setFkSeccion(int fkSeccion) { this.fkSeccion = fkSeccion; }

    public int getFkAnio() { return fkAnio; }
    public void setFkAnio(int fkAnio) { this.fkAnio = fkAnio; }

    public int getVacantes() { return vacantes; }
    public void setVacantes(int vacantes) { this.vacantes = vacantes; }

    public String getTurno() { return turno; }
    public void setTurno(String turno) { this.turno = turno; }

    public String getAnioLectivoStr() { return anioLectivoStr; }
    public void setAnioLectivoStr(String anioLectivoStr) { this.anioLectivoStr = anioLectivoStr; }

    public String getNivelStr() { return nivelStr; }
    public void setNivelStr(String nivelStr) { this.nivelStr = nivelStr; }

    public int getGradoInt() { return gradoInt; }
    public void setGradoInt(int gradoInt) { this.gradoInt = gradoInt; }

    public String getSeccionStr() { return seccionStr; }
    public void setSeccionStr(String seccionStr) { this.seccionStr = seccionStr; }

    public int getVacantesOcupadas() { return vacantesOcupadas; }
    public void setVacantesOcupadas(int vacantesOcupadas) { this.vacantesOcupadas = vacantesOcupadas; }
}
