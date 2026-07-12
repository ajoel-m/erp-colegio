--   PARTE 1. pnlAsignacionAcademica


-- Vista para cargar la tabla de horarios del docente seleccionado
CREATE OR REPLACE VIEW vw_horarios_docentes AS
SELECT aa.idAsignacionAcademica, ha.idHorarioAsignatura, aa.fk_docente AS idDocente, al.idAnioLectivo, al.anio,
       gsa.idGradoSeccionAnio, g.nivel_grado, g.grado, s.nombre_seccion, gsa.turno,
       ag.idAsignaturaGrado, a.nombre_asignatura, ha.dia_semana, ha.hora_inicio, ha.hora_fin
FROM asignaciones_academicas aa
INNER JOIN horarios_asignaturas ha ON aa.idAsignacionAcademica = ha.fk_asignacion_academica
INNER JOIN grado_seccion_anio gsa ON aa.fk_grado_seccion_anio = gsa.idGradoSeccionAnio
INNER JOIN anios_lectivos al ON gsa.fk_anio = al.idAnioLectivo
INNER JOIN grados g ON gsa.fk_grado = g.idGrado
INNER JOIN secciones s ON gsa.fk_seccion = s.idSeccion
INNER JOIN asignaturas_grados ag ON aa.fk_asignatura_grado = ag.idAsignaturaGrado
INNER JOIN asignaturas a ON ag.fk_asignatura = a.idAsignatura;

DELIMITER //

-- Registra la asignación académica y el bloque horario, validando cruces del docente y del aula
DROP PROCEDURE IF EXISTS sp_registrar_horario_docente//
CREATE PROCEDURE sp_registrar_horario_docente(IN p_idDocente INT, IN p_idAsignaturaGrado INT, IN p_idGradoSeccionAnio INT,
    IN p_dia VARCHAR(15), IN p_horaInicio TIME, IN p_horaFin TIME, OUT p_resultado INT)
BEGIN
    DECLARE v_idAsignacion INT DEFAULT NULL;
    DECLARE v_idAnio INT;
    DECLARE v_crucesDocente INT DEFAULT 0;
    DECLARE v_crucesAula INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_resultado = 0;
    END;

    START TRANSACTION;

    SELECT fk_anio INTO v_idAnio
    FROM grado_seccion_anio
    WHERE idGradoSeccionAnio = p_idGradoSeccionAnio;

    SELECT COUNT(*) INTO v_crucesDocente
    FROM asignaciones_academicas aa
    INNER JOIN horarios_asignaturas ha ON aa.idAsignacionAcademica = ha.fk_asignacion_academica
    INNER JOIN grado_seccion_anio gsa ON aa.fk_grado_seccion_anio = gsa.idGradoSeccionAnio
    WHERE aa.fk_docente = p_idDocente AND gsa.fk_anio = v_idAnio AND ha.dia_semana = p_dia
      AND p_horaInicio < ha.hora_fin AND p_horaFin > ha.hora_inicio;

    SELECT COUNT(*) INTO v_crucesAula
    FROM asignaciones_academicas aa
    INNER JOIN horarios_asignaturas ha ON aa.idAsignacionAcademica = ha.fk_asignacion_academica
    WHERE aa.fk_grado_seccion_anio = p_idGradoSeccionAnio AND ha.dia_semana = p_dia
      AND p_horaInicio < ha.hora_fin AND p_horaFin > ha.hora_inicio;

    IF v_crucesDocente > 0 OR v_crucesAula > 0 THEN
        ROLLBACK;
        SET p_resultado = 0;
    ELSE
        SELECT MAX(idAsignacionAcademica) INTO v_idAsignacion
        FROM asignaciones_academicas
        WHERE fk_docente = p_idDocente AND fk_asignatura_grado = p_idAsignaturaGrado
          AND fk_grado_seccion_anio = p_idGradoSeccionAnio;

        IF v_idAsignacion IS NULL THEN
            INSERT INTO asignaciones_academicas(fk_docente, fk_asignatura_grado, fk_grado_seccion_anio)
            VALUES(p_idDocente, p_idAsignaturaGrado, p_idGradoSeccionAnio);

            SET v_idAsignacion = LAST_INSERT_ID();
        END IF;

        INSERT INTO horarios_asignaturas(hora_inicio, hora_fin, dia_semana, fk_asignacion_academica)
        VALUES(p_horaInicio, p_horaFin, p_dia, v_idAsignacion);

        COMMIT;
        SET p_resultado = 1;
    END IF;
END//

-- Modifica la carga y el bloque seleccionado cuando no existen registros académicos dependientes
DROP PROCEDURE IF EXISTS sp_modificar_horario_docente//
CREATE PROCEDURE sp_modificar_horario_docente(IN p_idAsignacion INT, IN p_idHorario INT, IN p_idDocente INT,
    IN p_idAsignaturaGrado INT, IN p_idGradoSeccionAnio INT, IN p_dia VARCHAR(15),
    IN p_horaInicio TIME, IN p_horaFin TIME, OUT p_resultado INT)
BEGIN
    DECLARE v_idAnio INT;
    DECLARE v_dependencias INT DEFAULT 0;
    DECLARE v_crucesDocente INT DEFAULT 0;
    DECLARE v_crucesAula INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_resultado = 0;
    END;

    START TRANSACTION;

    SELECT
        (SELECT COUNT(*) FROM ponderaciones_evaluacion WHERE fk_asignacion_academica = p_idAsignacion) +
        (SELECT COUNT(*) FROM evaluaciones WHERE fk_asignacion_academica = p_idAsignacion) +
        (SELECT COUNT(*) FROM asistencias_estudiantes WHERE fk_asignacion_academica = p_idAsignacion) +
        (SELECT COUNT(*) FROM calificaciones_finales_periodo WHERE fk_asignacion_academica = p_idAsignacion) +
        (SELECT COUNT(*) FROM detalle_acta WHERE fk_asignacion_academica = p_idAsignacion)
    INTO v_dependencias;

    SELECT fk_anio INTO v_idAnio FROM grado_seccion_anio
    WHERE idGradoSeccionAnio = p_idGradoSeccionAnio;

    SELECT COUNT(*) INTO v_crucesDocente
    FROM asignaciones_academicas aa
    INNER JOIN horarios_asignaturas ha ON aa.idAsignacionAcademica = ha.fk_asignacion_academica
    INNER JOIN grado_seccion_anio gsa ON aa.fk_grado_seccion_anio = gsa.idGradoSeccionAnio
    WHERE aa.fk_docente = p_idDocente AND gsa.fk_anio = v_idAnio AND ha.dia_semana = p_dia
      AND ha.idHorarioAsignatura <> p_idHorario
      AND p_horaInicio < ha.hora_fin AND p_horaFin > ha.hora_inicio;

    SELECT COUNT(*) INTO v_crucesAula
    FROM asignaciones_academicas aa
    INNER JOIN horarios_asignaturas ha ON aa.idAsignacionAcademica = ha.fk_asignacion_academica
    WHERE aa.fk_grado_seccion_anio = p_idGradoSeccionAnio AND ha.dia_semana = p_dia
      AND ha.idHorarioAsignatura <> p_idHorario
      AND p_horaInicio < ha.hora_fin AND p_horaFin > ha.hora_inicio;

    IF v_dependencias > 0 OR v_crucesDocente > 0 OR v_crucesAula > 0 THEN
        ROLLBACK;
        SET p_resultado = 0;
    ELSE
        UPDATE asignaciones_academicas
        SET fk_docente = p_idDocente, fk_asignatura_grado = p_idAsignaturaGrado,
            fk_grado_seccion_anio = p_idGradoSeccionAnio
        WHERE idAsignacionAcademica = p_idAsignacion;

        UPDATE horarios_asignaturas
        SET dia_semana = p_dia, hora_inicio = p_horaInicio, hora_fin = p_horaFin
        WHERE idHorarioAsignatura = p_idHorario AND fk_asignacion_academica = p_idAsignacion;

        COMMIT;
        SET p_resultado = 1;
    END IF;
END//


-- Elimina la carga académica seleccionada junto con todos sus bloques horarios
DROP PROCEDURE IF EXISTS sp_eliminar_carga_academica//
CREATE PROCEDURE sp_eliminar_carga_academica(IN p_idAsignacionAcademica INT, OUT p_resultado INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_resultado = 0;
    END;

    START TRANSACTION;

    DELETE FROM horarios_asignaturas
    WHERE fk_asignacion_academica = p_idAsignacionAcademica;

    DELETE FROM asignaciones_academicas
    WHERE idAsignacionAcademica = p_idAsignacionAcademica;

    IF ROW_COUNT() > 0 THEN
        COMMIT;
        SET p_resultado = 1;
    ELSE
        ROLLBACK;
        SET p_resultado = 0;
    END IF;
END//

DELIMITER ;

-- -ii. pnlMatricula

-- Vista para buscar estudiantes durante la matrícula
CREATE OR REPLACE VIEW vw_estudiantes_matricula AS
SELECT e.idEstudiante, p.idPersona, p.dni_ce, p.nombre1, p.nombre2, p.apellido1, p.apellido2, p.fecha_nacimiento, ee.idEstadoEstudiante, ee.nombre_estado,
CONCAT(p.apellido1, ' ', p.apellido2, ', ', p.nombre1, IFNULL(CONCAT(' ', p.nombre2), '')) AS nombre_completo
FROM estudiantes e
INNER JOIN personas p ON e.fk_persona = p.idPersona
INNER JOIN estados_estudiantes ee ON e.fk_estado_estudiante = ee.idEstadoEstudiante;

-- Vista para consultar aulas y vacantes de matrícula
CREATE OR REPLACE VIEW vw_aulas_matricula AS
SELECT gsa.idGradoSeccionAnio, al.idAnioLectivo, al.anio, al.estado AS estado_anio, g.idGrado, g.nivel_grado, g.grado, s.idSeccion, s.nombre_seccion, gsa.turno, gsa.vacantes,
COUNT(CASE WHEN m.estado_matricula IN ('condicional', 'regularizada', 'activa') THEN 1 END) AS vacantes_ocupadas,
gsa.vacantes - COUNT(CASE WHEN m.estado_matricula IN ('condicional', 'regularizada', 'activa') THEN 1 END) AS vacantes_disponibles
FROM grado_seccion_anio gsa
INNER JOIN anios_lectivos al ON gsa.fk_anio = al.idAnioLectivo
INNER JOIN grados g ON gsa.fk_grado = g.idGrado
INNER JOIN secciones s ON gsa.fk_seccion = s.idSeccion
LEFT JOIN matriculas m ON m.fk_grado_seccion_anio = gsa.idGradoSeccionAnio
GROUP BY gsa.idGradoSeccionAnio, al.idAnioLectivo, al.anio, al.estado, g.idGrado, g.nivel_grado, g.grado, s.idSeccion, s.nombre_seccion, gsa.turno, gsa.vacantes;

-- Vista para mostrar el historial institucional
CREATE OR REPLACE VIEW vw_historial_matriculas AS
SELECT m.idMatricula, m.fk_estudiante AS idEstudiante, al.idAnioLectivo, al.anio, g.nivel_grado, g.grado, s.nombre_seccion, gsa.turno, m.estado_matricula,
(SELECT a.promedio_final FROM actas a WHERE a.fk_matricula = m.idMatricula ORDER BY a.fecha_emision DESC, a.idActa DESC LIMIT 1) AS promedio_anual
FROM matriculas m
INNER JOIN anios_lectivos al ON m.fk_anio_lectivo = al.idAnioLectivo
INNER JOIN grado_seccion_anio gsa ON m.fk_grado_seccion_anio = gsa.idGradoSeccionAnio
INNER JOIN grados g ON gsa.fk_grado = g.idGrado
INNER JOIN secciones s ON gsa.fk_seccion = s.idSeccion;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_registrar_matricula//
CREATE PROCEDURE sp_registrar_matricula(IN p_idEstudiante INT, IN p_idAnioLectivo INT, IN p_idGradoSeccionAnio INT, IN p_idColaboradorRegistrador INT, IN p_estadoMatricula VARCHAR(20), IN p_tipoMatricula VARCHAR(20), IN p_autorizacionDireccion BIT, OUT p_resultado INT)
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_estadoAnio VARCHAR(20);
    DECLARE v_nivel VARCHAR(40);
    DECLARE v_grado TINYINT;
    DECLARE v_fechaNacimiento DATE;
    DECLARE v_fechaInicioAnio DATE;
    DECLARE v_vacantes INT;
    DECLARE v_ocupadas INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_resultado = 0;
        RESIGNAL;
    END;

    SET p_resultado = 0;

    IF p_estadoMatricula NOT IN ('condicional', 'activa') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estado no permitido para una nueva matrícula';
    END IF;

    IF UPPER(p_tipoMatricula) NOT IN ('REGULAR', 'EXTEMPORÁNEA') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tipo de matrícula no válido';
    END IF;

    IF UPPER(p_tipoMatricula) = 'EXTEMPORÁNEA' AND IFNULL(p_autorizacionDireccion, 0) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La matrícula extemporánea requiere autorización de Dirección';
    END IF;

    SELECT COUNT(*) INTO v_existe FROM estudiantes WHERE idEstudiante = p_idEstudiante;
    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estudiante no existe';
    END IF;

    SELECT COUNT(*) INTO v_existe FROM colaboradores WHERE idColaborador = p_idColaboradorRegistrador;
    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario registrador no tiene colaborador asociado';
    END IF;

    SELECT COUNT(*) INTO v_existe FROM matriculas WHERE fk_estudiante = p_idEstudiante AND fk_anio_lectivo = p_idAnioLectivo;
    IF v_existe > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estudiante ya posee una matrícula en el año seleccionado';
    END IF;

    START TRANSACTION;

    SELECT al.estado, al.fecha_inicio, g.nivel_grado, g.grado, gsa.vacantes
    INTO v_estadoAnio, v_fechaInicioAnio, v_nivel, v_grado, v_vacantes
    FROM grado_seccion_anio gsa
    INNER JOIN anios_lectivos al ON gsa.fk_anio = al.idAnioLectivo
    INNER JOIN grados g ON gsa.fk_grado = g.idGrado
    WHERE gsa.idGradoSeccionAnio = p_idGradoSeccionAnio AND al.idAnioLectivo = p_idAnioLectivo
    FOR UPDATE;

    IF v_estadoAnio IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El aula no pertenece al año lectivo seleccionado';
    END IF;

    IF v_estadoAnio <> 'VIGENTE' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El año lectivo no permite registrar matrículas';
    END IF;

    SELECT fecha_nacimiento INTO v_fechaNacimiento
    FROM personas p
    INNER JOIN estudiantes e ON e.fk_persona = p.idPersona
    WHERE e.idEstudiante = p_idEstudiante;

    IF v_nivel = 'primaria' AND v_grado = 1 AND TIMESTAMPDIFF(YEAR, v_fechaNacimiento, v_fechaInicioAnio) < 6 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El estudiante no cumple la edad mínima para primer grado';
    END IF;

    SELECT COUNT(*) INTO v_ocupadas FROM matriculas
    WHERE fk_grado_seccion_anio = p_idGradoSeccionAnio AND estado_matricula IN ('condicional', 'regularizada', 'activa');

    IF v_ocupadas >= v_vacantes THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El aula seleccionada no tiene vacantes disponibles';
    END IF;

    INSERT INTO matriculas (estado_matricula, fk_anio_lectivo, fk_grado_seccion_anio, fk_estudiante, fk_colaborador_registrador)
    VALUES (p_estadoMatricula, p_idAnioLectivo, p_idGradoSeccionAnio, p_idEstudiante, p_idColaboradorRegistrador);

    COMMIT;
    SET p_resultado = 1;
END//

DELIMITER ;
