-- Sprint 6 - Evaluaciones, resultados y promedios por periodo

-- Catálogo mínimo. No modifica los tipos que ya existan.
INSERT INTO tipos_evaluacion(nombre, descripcion, es_recuperable, tipo_area)
VALUES ('Práctica', 'Evaluación práctica', 0, 'ACADEMICA'),
       ('Tarea', 'Trabajo asignado al estudiante', 0, 'ACADEMICA'),
       ('Examen', 'Evaluación escrita u oral', 1, 'ACADEMICA'),
       ('Participación', 'Participación durante la clase', 0, 'ACADEMICA')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);

-- Las ponderaciones no se insertan automáticamente porque dependen de cada
-- asignación académica y deben ser configuradas de modo que sumen 1.00.

CREATE OR REPLACE VIEW vw_carga_evaluaciones AS
SELECT aa.idAsignacionAcademica, aa.fk_docente AS idDocente,
       al.idAnioLectivo, al.anio, al.estado AS estadoAnio,
       gsa.idGradoSeccionAnio,
       CONCAT(asi.nombre_asignatura, ' - ', g.grado, '° ', s.nombre_seccion,
              ' - ', gsa.turno) AS carga
FROM asignaciones_academicas aa
INNER JOIN asignaturas_grados ag ON aa.fk_asignatura_grado = ag.idAsignaturaGrado
INNER JOIN asignaturas asi ON ag.fk_asignatura = asi.idAsignatura
INNER JOIN grado_seccion_anio gsa ON aa.fk_grado_seccion_anio = gsa.idGradoSeccionAnio
INNER JOIN grados g ON gsa.fk_grado = g.idGrado
INNER JOIN secciones s ON gsa.fk_seccion = s.idSeccion
INNER JOIN anios_lectivos al ON gsa.fk_anio = al.idAnioLectivo;

CREATE OR REPLACE VIEW vw_resultados_evaluaciones AS
SELECT ev.idEvaluacion, ev.fk_asignacion_academica AS idAsignacionAcademica,
       ev.fk_periodo_lectivo AS idPeriodoLectivo, m.fk_estudiante AS idEstudiante,
       p.dni_ce, CONCAT(p.apellido1, ' ', p.apellido2, ', ', p.nombre1,
       IFNULL(CONCAT(' ', p.nombre2), '')) AS estudiante,
       re.puntaje, re.observaciones
FROM evaluaciones ev
INNER JOIN asignaciones_academicas aa ON ev.fk_asignacion_academica = aa.idAsignacionAcademica
INNER JOIN matriculas m ON aa.fk_grado_seccion_anio = m.fk_grado_seccion_anio
INNER JOIN estudiantes e ON m.fk_estudiante = e.idEstudiante
INNER JOIN personas p ON e.fk_persona = p.idPersona
LEFT JOIN resultados_estudiantes re ON re.fk_evaluaciones = ev.idEvaluacion
                                      AND re.fk_estudiante = m.fk_estudiante
WHERE m.estado_matricula IN ('activa', 'condicional', 'regularizada');

DELIMITER //

DROP PROCEDURE IF EXISTS sp_listar_carga_evaluacion//
CREATE PROCEDURE sp_listar_carga_evaluacion(IN p_idColaborador INT, IN p_rol VARCHAR(50))
BEGIN
    SELECT idAsignacionAcademica, idDocente, idAnioLectivo, anio, estadoAnio,
           idGradoSeccionAnio, carga
    FROM vw_carga_evaluaciones
    WHERE (LOWER(p_rol) = 'docente' AND idDocente = p_idColaborador)
       OR LOWER(p_rol) = 'director'
    ORDER BY anio DESC, carga;
END//

DROP PROCEDURE IF EXISTS sp_listar_periodos_evaluacion//
CREATE PROCEDURE sp_listar_periodos_evaluacion(IN p_idAnioLectivo INT)
BEGIN
    SELECT pl.idPeriodoLectivo, pl.fk_anio_lectivo AS idAnioLectivo,
           CONCAT(tp.tipo, ' ', pl.numero) AS periodo,
           pl.fecha_inicio AS fechaInicio, pl.fecha_fin AS fechaFin,
           CASE WHEN CURRENT_DATE < pl.fecha_inicio THEN 'PENDIENTE'
                WHEN CURRENT_DATE > pl.fecha_fin THEN 'CERRADO'
                ELSE 'ACTIVO' END AS estadoPeriodo
    FROM periodos_lectivos pl
    INNER JOIN tipos_periodizacion tp ON pl.fk_tipo_periodizacion = tp.idTipoPeriodizacion
    WHERE pl.fk_anio_lectivo = p_idAnioLectivo
    ORDER BY pl.numero;
END//

DROP PROCEDURE IF EXISTS sp_listar_tipos_evaluacion//
CREATE PROCEDURE sp_listar_tipos_evaluacion(IN p_idAsignacionAcademica INT)
BEGIN
    SELECT te.idTipoEvaluacion, te.nombre, pe.peso
    FROM ponderaciones_evaluacion pe
    INNER JOIN tipos_evaluacion te ON pe.fk_tipo_evaluacion = te.idTipoEvaluacion
    WHERE pe.fk_asignacion_academica = p_idAsignacionAcademica
    ORDER BY te.nombre;
END//

DROP PROCEDURE IF EXISTS sp_listar_evaluaciones//
CREATE PROCEDURE sp_listar_evaluaciones(IN p_idAsignacionAcademica INT, IN p_idPeriodoLectivo INT)
BEGIN
    SELECT ev.idEvaluacion, ev.fecha, ev.fk_tipo_evaluacion AS idTipoEvaluacion,
           ev.fk_asignacion_academica AS idAsignacionAcademica,
           ev.fk_periodo_lectivo AS idPeriodoLectivo, te.nombre AS tipoEvaluacion,
           pe.peso, EXISTS(SELECT 1 FROM resultados_estudiantes re
                          WHERE re.fk_evaluaciones = ev.idEvaluacion) AS tieneResultados
    FROM evaluaciones ev
    INNER JOIN tipos_evaluacion te ON ev.fk_tipo_evaluacion = te.idTipoEvaluacion
    INNER JOIN ponderaciones_evaluacion pe
            ON pe.fk_tipo_evaluacion = ev.fk_tipo_evaluacion
           AND pe.fk_asignacion_academica = ev.fk_asignacion_academica
    WHERE ev.fk_asignacion_academica = p_idAsignacionAcademica
      AND ev.fk_periodo_lectivo = p_idPeriodoLectivo
    ORDER BY ev.fecha, ev.idEvaluacion;
END//

DROP PROCEDURE IF EXISTS sp_guardar_evaluacion//
CREATE PROCEDURE sp_guardar_evaluacion(
    IN p_idEvaluacion INT, IN p_fecha DATE, IN p_idTipoEvaluacion INT,
    IN p_idAsignacionAcademica INT, IN p_idPeriodoLectivo INT,
    IN p_idDocenteSesion INT)
BEGIN
    DECLARE v_idDocente INT DEFAULT NULL;
    DECLARE v_estadoAnio VARCHAR(20);
    DECLARE v_inicioPeriodo DATE;
    DECLARE v_finPeriodo DATE;

    SELECT aa.fk_docente, al.estado INTO v_idDocente, v_estadoAnio
    FROM asignaciones_academicas aa
    INNER JOIN grado_seccion_anio gsa ON aa.fk_grado_seccion_anio = gsa.idGradoSeccionAnio
    INNER JOIN anios_lectivos al ON gsa.fk_anio = al.idAnioLectivo
    WHERE aa.idAsignacionAcademica = p_idAsignacionAcademica;

    SELECT fecha_inicio, fecha_fin INTO v_inicioPeriodo, v_finPeriodo
    FROM periodos_lectivos
    WHERE idPeriodoLectivo = p_idPeriodoLectivo;

    IF v_idDocente IS NULL OR v_inicioPeriodo IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La asignación o el periodo no existe';
    END IF;
    IF v_idDocente <> p_idDocenteSesion THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo el docente asignado puede guardar evaluaciones';
    END IF;
    IF v_estadoAnio = 'FINALIZADO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El año lectivo está finalizado';
    END IF;
    IF CURRENT_DATE < v_inicioPeriodo OR CURRENT_DATE > v_finPeriodo THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El periodo no está activo';
    END IF;
    IF p_fecha < v_inicioPeriodo OR p_fecha > v_finPeriodo THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha no pertenece al periodo seleccionado';
    END IF;
    IF NOT EXISTS(SELECT 1 FROM ponderaciones_evaluacion
                  WHERE fk_asignacion_academica = p_idAsignacionAcademica
                    AND fk_tipo_evaluacion = p_idTipoEvaluacion) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El tipo no tiene ponderación para esta asignación';
    END IF;

    IF IFNULL(p_idEvaluacion, 0) = 0 THEN
        INSERT INTO evaluaciones(fecha, fk_tipo_evaluacion, fk_asignacion_academica, fk_periodo_lectivo)
        VALUES(p_fecha, p_idTipoEvaluacion, p_idAsignacionAcademica, p_idPeriodoLectivo);
    ELSE
        IF EXISTS(SELECT 1 FROM resultados_estudiantes WHERE fk_evaluaciones = p_idEvaluacion) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La evaluación ya tiene resultados y no puede modificarse';
        END IF;
        UPDATE evaluaciones
        SET fecha = p_fecha, fk_tipo_evaluacion = p_idTipoEvaluacion,
            fk_asignacion_academica = p_idAsignacionAcademica,
            fk_periodo_lectivo = p_idPeriodoLectivo
        WHERE idEvaluacion = p_idEvaluacion
          AND fk_asignacion_academica = p_idAsignacionAcademica;
        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se encontró la evaluación para modificar';
        END IF;
    END IF;
END//

DROP PROCEDURE IF EXISTS sp_cargar_resultados_evaluacion//
CREATE PROCEDURE sp_cargar_resultados_evaluacion(IN p_idEvaluacion INT)
BEGIN
    SELECT idEstudiante, dni_ce, estudiante, puntaje, observaciones
    FROM vw_resultados_evaluaciones
    WHERE idEvaluacion = p_idEvaluacion
    ORDER BY estudiante;
END//

DROP PROCEDURE IF EXISTS sp_guardar_resultados_evaluacion//
CREATE PROCEDURE sp_guardar_resultados_evaluacion(
    IN p_idEvaluacion INT, IN p_idEstudiante INT, IN p_puntaje DECIMAL(5,2),
    IN p_observaciones VARCHAR(256), IN p_idDocenteSesion INT)
BEGIN
    DECLARE v_idDocente INT DEFAULT NULL;
    DECLARE v_estadoAnio VARCHAR(20);
    DECLARE v_finPeriodo DATE;
    DECLARE v_idAula INT;

    SELECT aa.fk_docente, al.estado, pl.fecha_fin, aa.fk_grado_seccion_anio
    INTO v_idDocente, v_estadoAnio, v_finPeriodo, v_idAula
    FROM evaluaciones ev
    INNER JOIN asignaciones_academicas aa ON ev.fk_asignacion_academica = aa.idAsignacionAcademica
    INNER JOIN grado_seccion_anio gsa ON aa.fk_grado_seccion_anio = gsa.idGradoSeccionAnio
    INNER JOIN anios_lectivos al ON gsa.fk_anio = al.idAnioLectivo
    INNER JOIN periodos_lectivos pl ON ev.fk_periodo_lectivo = pl.idPeriodoLectivo
    WHERE ev.idEvaluacion = p_idEvaluacion;

    IF v_idDocente IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La evaluación no existe'; END IF;
    IF v_idDocente <> p_idDocenteSesion THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo el docente asignado puede guardar notas'; END IF;
    IF v_estadoAnio = 'FINALIZADO' OR CURRENT_DATE > v_finPeriodo THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El periodo o año está cerrado'; END IF;
    IF p_puntaje < 0 OR p_puntaje > 20 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El puntaje debe estar entre 0 y 20'; END IF;
    IF NOT EXISTS(SELECT 1 FROM matriculas WHERE fk_estudiante = p_idEstudiante
                  AND fk_grado_seccion_anio = v_idAula
                  AND estado_matricula IN ('activa','condicional','regularizada')) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estudiante no tiene matrícula válida en el aula';
    END IF;

    INSERT INTO resultados_estudiantes(puntaje, fk_estudiante, fk_evaluaciones, observaciones)
    VALUES(p_puntaje, p_idEstudiante, p_idEvaluacion, NULLIF(TRIM(p_observaciones), ''))
    ON DUPLICATE KEY UPDATE puntaje = p_puntaje, observaciones = NULLIF(TRIM(p_observaciones), '');
END//

DROP PROCEDURE IF EXISTS sp_calcular_promedios_periodo//
CREATE PROCEDURE sp_calcular_promedios_periodo(
    IN p_idAsignacionAcademica INT, IN p_idPeriodoLectivo INT, IN p_idDocenteSesion INT)
BEGIN
    DECLARE v_idDocente INT DEFAULT NULL;
    DECLARE v_estadoAnio VARCHAR(20);
    DECLARE v_finPeriodo DATE;
    DECLARE v_idAula INT;
    DECLARE v_sumaPesos DECIMAL(6,2);
    DECLARE v_evaluaciones INT;
    DECLARE v_tiposSinEvaluacion INT;
    DECLARE v_faltantes INT;

    SELECT aa.fk_docente, al.estado, pl.fecha_fin, aa.fk_grado_seccion_anio
    INTO v_idDocente, v_estadoAnio, v_finPeriodo, v_idAula
    FROM asignaciones_academicas aa
    INNER JOIN grado_seccion_anio gsa ON aa.fk_grado_seccion_anio = gsa.idGradoSeccionAnio
    INNER JOIN anios_lectivos al ON gsa.fk_anio = al.idAnioLectivo
    INNER JOIN periodos_lectivos pl ON pl.idPeriodoLectivo = p_idPeriodoLectivo
                                  AND pl.fk_anio_lectivo = al.idAnioLectivo
    WHERE aa.idAsignacionAcademica = p_idAsignacionAcademica;

    IF v_idDocente IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La asignación o periodo no existe'; END IF;
    IF v_idDocente <> p_idDocenteSesion THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo el docente asignado puede calcular promedios'; END IF;
    IF v_estadoAnio = 'FINALIZADO' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El año lectivo está finalizado'; END IF;
    IF CURRENT_DATE < v_finPeriodo THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El periodo todavía no ha finalizado'; END IF;

    SELECT IFNULL(SUM(peso), 0) INTO v_sumaPesos
    FROM ponderaciones_evaluacion WHERE fk_asignacion_academica = p_idAsignacionAcademica;
    IF v_sumaPesos <> 1.00 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Las ponderaciones deben sumar exactamente 1.00'; END IF;

    SELECT COUNT(*) INTO v_evaluaciones FROM evaluaciones
    WHERE fk_asignacion_academica = p_idAsignacionAcademica AND fk_periodo_lectivo = p_idPeriodoLectivo;
    IF v_evaluaciones = 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existen evaluaciones en el periodo'; END IF;

    SELECT COUNT(*) INTO v_tiposSinEvaluacion
    FROM ponderaciones_evaluacion pe
    WHERE pe.fk_asignacion_academica = p_idAsignacionAcademica
      AND NOT EXISTS(SELECT 1 FROM evaluaciones ev
                     WHERE ev.fk_asignacion_academica = p_idAsignacionAcademica
                       AND ev.fk_periodo_lectivo = p_idPeriodoLectivo
                       AND ev.fk_tipo_evaluacion = pe.fk_tipo_evaluacion);
    IF v_tiposSinEvaluacion > 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Faltan evaluaciones para uno o más tipos ponderados'; END IF;

    SELECT COUNT(*) INTO v_faltantes
    FROM matriculas m
    CROSS JOIN evaluaciones ev
    LEFT JOIN resultados_estudiantes re ON re.fk_estudiante = m.fk_estudiante
                                        AND re.fk_evaluaciones = ev.idEvaluacion
    WHERE m.fk_grado_seccion_anio = v_idAula
      AND m.estado_matricula IN ('activa','condicional','regularizada')
      AND ev.fk_asignacion_academica = p_idAsignacionAcademica
      AND ev.fk_periodo_lectivo = p_idPeriodoLectivo
      AND re.idResultadoEstudiante IS NULL;
    IF v_faltantes > 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hay estudiantes con evaluaciones sin puntaje'; END IF;

    INSERT INTO calificaciones_finales_periodo(promedio_final, calificacion_alfabetica,
                                                fk_estudiante, fk_periodo_lectivo,
                                                fk_asignacion_academica)
    SELECT ROUND(SUM(t.promedio_tipo * t.peso), 2),
           CASE WHEN SUM(t.promedio_tipo * t.peso) < 11 THEN 'C'
                WHEN SUM(t.promedio_tipo * t.peso) < 15 THEN 'B'
                WHEN SUM(t.promedio_tipo * t.peso) < 18 THEN 'A'
                ELSE 'AD' END,
           t.idEstudiante, p_idPeriodoLectivo, p_idAsignacionAcademica
    FROM (
        SELECT re.fk_estudiante AS idEstudiante, ev.fk_tipo_evaluacion AS idTipo,
               AVG(re.puntaje) AS promedio_tipo, pe.peso
        FROM resultados_estudiantes re
        INNER JOIN evaluaciones ev ON re.fk_evaluaciones = ev.idEvaluacion
        INNER JOIN ponderaciones_evaluacion pe
                ON pe.fk_asignacion_academica = ev.fk_asignacion_academica
               AND pe.fk_tipo_evaluacion = ev.fk_tipo_evaluacion
        WHERE ev.fk_asignacion_academica = p_idAsignacionAcademica
          AND ev.fk_periodo_lectivo = p_idPeriodoLectivo
        GROUP BY re.fk_estudiante, ev.fk_tipo_evaluacion, pe.peso
    ) t
    GROUP BY t.idEstudiante
    ON DUPLICATE KEY UPDATE promedio_final = VALUES(promedio_final),
                            calificacion_alfabetica = VALUES(calificacion_alfabetica);
END//

DROP PROCEDURE IF EXISTS sp_listar_promedios_periodo//
CREATE PROCEDURE sp_listar_promedios_periodo(IN p_idAsignacionAcademica INT, IN p_idPeriodoLectivo INT)
BEGIN
    SELECT cfp.fk_estudiante AS idEstudiante, p.dni_ce,
           CONCAT(p.apellido1, ' ', p.apellido2, ', ', p.nombre1,
                  IFNULL(CONCAT(' ', p.nombre2), '')) AS estudiante,
           cfp.promedio_final AS promedioFinal,
           cfp.calificacion_alfabetica AS calificacionAlfabetica
    FROM calificaciones_finales_periodo cfp
    INNER JOIN estudiantes e ON cfp.fk_estudiante = e.idEstudiante
    INNER JOIN personas p ON e.fk_persona = p.idPersona
    WHERE cfp.fk_asignacion_academica = p_idAsignacionAcademica
      AND cfp.fk_periodo_lectivo = p_idPeriodoLectivo
    ORDER BY estudiante;
END//

DELIMITER ;
