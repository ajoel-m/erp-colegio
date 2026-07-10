-- 1. Vista para llenar la tabla principal de búsqueda rápida
CREATE VIEW vw_grilla_estudiantes AS
SELECT 
    pe.dni_ce AS dni_estudiante,
    CONCAT(pe.apellido1, ' ', pe.apellido2, ', ', pe.nombre1) AS alumno,
    CONCAT(pa.apellido1, ' ', pa.apellido2, ', ', pa.nombre1) AS apoderado,
    cp.parentesco,
    ee.nombre_estado AS estado
FROM estudiantes e
INNER JOIN personas pe ON e.fk_persona = pe.idPersona
INNER JOIN estados_estudiantes ee ON e.fk_estado_estudiante = ee.idEstadoEstudiante
LEFT JOIN apoderados_estudiantes ae ON e.idEstudiante = ae.fk_estudiante
LEFT JOIN apoderados a ON ae.fk_apoderado = a.idApoderado
LEFT JOIN personas pa ON a.fk_persona = pa.idPersona;

-- 2. Vista para cargar todos los detalles en el formulario al presionar F2
CREATE VIEW vw_detalle_estudiante AS
SELECT 
    e.idEstudiante, pe.idPersona AS idPersEstudiante, pe.dni_ce AS dniEst, 
    pe.nombre1 AS nom1Est, pe.nombre2 AS nom2Est, pe.apellido1 AS ape1Est, pe.apellido2 AS ape2Est, 
    pe.fecha_nacimiento AS fecNacEst, pe.direccion, ee.idEstadoEstudiante, ee.nombre_estado,
    a.idApoderado, pa.idPersona AS idPersApoderado, pa.dni_ce AS dniApo, 
    pa.nombre1 AS nom1Apo, pa.nombre2 AS nom2Apo, pa.apellido1 AS ape1Apo, pa.apellido2 AS ape2Apo, 
    pa.telefono, pa.correo, cp.idParentesco
FROM estudiantes e
INNER JOIN personas pe ON e.fk_persona = pe.idPersona
INNER JOIN estados_estudiantes ee ON e.fk_estado_estudiante = ee.idEstadoEstudiante
LEFT JOIN apoderados_estudiantes ae ON e.idEstudiante = ae.fk_estudiante
LEFT JOIN apoderados a ON ae.fk_apoderado = a.idApoderado
LEFT JOIN personas pa ON a.fk_persona = pa.idPersona
LEFT JOIN cat_parentescos cp ON ae.fk_parentesco = cp.idParentesco;

DELIMITER //

-- 3. SP para Registrar Estudiante y Apoderado
CREATE PROCEDURE sp_registrar_estudiante(
    IN p_dniEst VARCHAR(12), IN p_nom1Est VARCHAR(30), IN p_nom2Est VARCHAR(30), 
    IN p_ape1Est VARCHAR(40), IN p_ape2Est VARCHAR(40), IN p_fecNacEst DATE, IN p_dir VARCHAR(200),
    IN p_idEstado INT,
    IN p_dniApo VARCHAR(12), IN p_nom1Apo VARCHAR(30), IN p_nom2Apo VARCHAR(30), 
    IN p_ape1Apo VARCHAR(40), IN p_ape2Apo VARCHAR(40), IN p_tel CHAR(9), IN p_correo VARCHAR(100),
    IN p_idParentesco INT
)
BEGIN
    DECLARE v_idPersEst INT;
    DECLARE v_idPersApo INT;
    DECLARE v_idEstudiante INT;
    DECLARE v_idApoderado INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- 1. Persona Estudiante
    SELECT idPersona INTO v_idPersEst FROM personas WHERE dni_ce = p_dniEst;
    IF v_idPersEst IS NULL THEN
        INSERT INTO personas (dni_ce, nombre1, nombre2, apellido1, apellido2, fecha_nacimiento, direccion)
        VALUES (p_dniEst, p_nom1Est, p_nom2Est, p_ape1Est, p_ape2Est, p_fecNacEst, p_dir);
        SET v_idPersEst = LAST_INSERT_ID();
    ELSE
        UPDATE personas SET nombre1=p_nom1Est, nombre2=p_nom2Est, apellido1=p_ape1Est, apellido2=p_ape2Est, fecha_nacimiento=p_fecNacEst, direccion=p_dir WHERE idPersona=v_idPersEst;
    END IF;

    -- 2. Estudiante
    INSERT INTO estudiantes (fk_persona, fk_estado_estudiante) VALUES (v_idPersEst, p_idEstado);
    SET v_idEstudiante = LAST_INSERT_ID();

    -- 3. Persona Apoderado
    SELECT idPersona INTO v_idPersApo FROM personas WHERE dni_ce = p_dniApo;
    IF v_idPersApo IS NULL THEN
        -- Asignamos fecha default si no existe, ya que tu BD exige NOT NULL en fecha_nacimiento para personas.
        INSERT INTO personas (dni_ce, nombre1, nombre2, apellido1, apellido2, fecha_nacimiento, telefono, correo)
        VALUES (p_dniApo, p_nom1Apo, p_nom2Apo, p_ape1Apo, p_ape2Apo, '1970-01-01', p_tel, p_correo);
        SET v_idPersApo = LAST_INSERT_ID();
    ELSE
        UPDATE personas SET nombre1=p_nom1Apo, nombre2=p_nom2Apo, apellido1=p_ape1Apo, apellido2=p_ape2Apo, telefono=p_tel, correo=p_correo WHERE idPersona=v_idPersApo;
    END IF;

    -- 4. Apoderado
    SELECT idApoderado INTO v_idApoderado FROM apoderados WHERE fk_persona = v_idPersApo;
    IF v_idApoderado IS NULL THEN
        INSERT INTO apoderados (fk_persona) VALUES (v_idPersApo);
        SET v_idApoderado = LAST_INSERT_ID();
    END IF;

    -- 5. Vincular
    INSERT INTO apoderados_estudiantes (fk_apoderado, fk_estudiante, fk_parentesco) VALUES (v_idApoderado, v_idEstudiante, p_idParentesco);

    COMMIT;
END//

-- 4. SP para Actualizar Estudiante y Apoderado
CREATE PROCEDURE sp_actualizar_estudiante(
    IN p_idEstudiante INT, IN p_idPersEst INT, IN p_dniEst VARCHAR(12), 
    IN p_nom1Est VARCHAR(30), IN p_nom2Est VARCHAR(30), IN p_ape1Est VARCHAR(40), 
    IN p_ape2Est VARCHAR(40), IN p_fecNacEst DATE, IN p_dir VARCHAR(200), IN p_idEstado INT,
    IN p_idApoderado INT, IN p_idPersApo INT, IN p_dniApo VARCHAR(12), 
    IN p_nom1Apo VARCHAR(30), IN p_nom2Apo VARCHAR(30), IN p_ape1Apo VARCHAR(40), 
    IN p_ape2Apo VARCHAR(40), IN p_tel CHAR(9), IN p_correo VARCHAR(100), IN p_idParentesco INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    UPDATE personas SET nombre1=p_nom1Est, nombre2=p_nom2Est, apellido1=p_ape1Est, apellido2=p_ape2Est, fecha_nacimiento=p_fecNacEst, direccion=p_dir WHERE idPersona=p_idPersEst;
    UPDATE estudiantes SET fk_estado_estudiante = p_idEstado WHERE idEstudiante = p_idEstudiante;
    UPDATE personas SET nombre1=p_nom1Apo, nombre2=p_nom2Apo, apellido1=p_ape1Apo, apellido2=p_ape2Apo, telefono=p_tel, correo=p_correo WHERE idPersona=p_idPersApo;
    UPDATE apoderados_estudiantes SET fk_parentesco = p_idParentesco WHERE fk_estudiante = p_idEstudiante AND fk_apoderado = p_idApoderado;

    COMMIT;
END//
DELIMITER ;


