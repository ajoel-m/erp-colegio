/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.erpcolegio.controlador;

import com.erpcolegio.dao.AnioLectivoDAO;
import com.erpcolegio.dao.GradoDAO;
import com.erpcolegio.dao.GradoSeccionAnioDAO;
import com.erpcolegio.dao.SeccionDAO;
import com.erpcolegio.modelo.AnioLectivo;
import com.erpcolegio.modelo.Grado;
import com.erpcolegio.modelo.GradoSeccionAnio;
import com.erpcolegio.modelo.Seccion;
import com.erpcolegio.util.validadores.InputValidator;
import java.util.List;

public class ConfigAcademicaController {
    private AnioLectivoDAO dao;
    public boolean aperturarAnio(String anio, java.util.Date inicio, java.util.Date fin) {
        if (inicio == null || fin == null) return false;
        if (!InputValidator.esNumeroEntero(anio) || anio.length() != 4) return false;
        
        if (fin.before(inicio) || fin.equals(inicio)) return false;

        AnioLectivo anioLectivo = new AnioLectivo();
        anioLectivo.setAnio(anio);
        anioLectivo.setFechaInicio(new java.sql.Date(inicio.getTime()));
        anioLectivo.setFechaFin(new java.sql.Date(fin.getTime()));

        AnioLectivoDAO dao = new AnioLectivoDAO();
        return dao.registrar(anioLectivo);
    }

    public boolean agregarAula(AnioLectivo anioObj, Grado gradoObj, Seccion seccionObj, String turno, String vacantesTexto) {
        if (anioObj == null || gradoObj == null || seccionObj == null || turno == null) return false;
        if (!InputValidator.esNumeroEntero(vacantesTexto)) return false;
        
        int vacantes = Integer.parseInt(vacantesTexto);
        if (vacantes <= 0) return false;

        GradoSeccionAnio gsa = new GradoSeccionAnio();
        gsa.setFkAnio(anioObj.getIdAnioLectivo());
        gsa.setFkGrado(gradoObj.getIdGrado());
        gsa.setFkSeccion(seccionObj.getIdSeccion());
        gsa.setTurno(turno);
        gsa.setVacantes(vacantes);

        GradoSeccionAnioDAO dao = new GradoSeccionAnioDAO();
        return dao.registrar(gsa);
    }

    public List<Grado> obtenerGradosPorNivel(String nivel) {
        return new GradoDAO().listarPorNivel(nivel.toLowerCase());
    }

    public List<Seccion> obtenerSecciones() {
        return new SeccionDAO().listarTodas();
    }

    public List<AnioLectivo> obtenerAnios() {
        return new AnioLectivoDAO().listarTodos();
    }

    public List<GradoSeccionAnio> obtenerAulasConfiguradas() {
        return new GradoSeccionAnioDAO().listarAulasConfiguradas();
    }
}
