
-- APLICADO PARA EL PANEL DE CONFIGURACIÓN ACADÉMICA
-- ==========================================================================================================
-- Vista para cargar la tabla de aulas configuradas y calcular las vacantes ocupadas en tiempo real
CREATE VIEW vw_aulas_configuradas AS
SELECT 
    gsa.idGradoSeccionAnio,
    al.anio,
    g.nivel_grado,
    g.grado,
    s.nombre_seccion,
    gsa.turno,
    gsa.vacantes,
    (SELECT COUNT(*) 
     FROM matriculas m 
     WHERE m.fk_grado_seccion_anio = gsa.idGradoSeccionAnio 
       AND m.estado_matricula IN ('condicional', 'regularizada', 'activa')) AS vacantes_ocupadas
FROM grado_seccion_anio gsa
INNER JOIN anios_lectivos al ON gsa.fk_anio = al.idAnioLectivo
INNER JOIN grados g ON gsa.fk_grado = g.idGrado
INNER JOIN secciones s ON gsa.fk_seccion = s.idSeccion
ORDER BY al.anio DESC, g.nivel_grado, g.grado, s.nombre_seccion;

-- ==========================================================================================================
-- ==========================================================================================================


-- APLICADO PARA EL PANEL DE GESTIÓN DE COLABORADORES
-- ==========================================================================================================
DELIMITER //

-- SP para Registro Transaccional
CREATE PROCEDURE sp_registrar_colaborador(
    IN p_dni VARCHAR(12),
    IN p_nombre1 VARCHAR(30),
    IN p_nombre2 VARCHAR(30),
    IN p_apellido1 VARCHAR(40),
    IN p_apellido2 VARCHAR(40),
    IN p_fecha_nacimiento DATE,
    IN p_telefono CHAR(9),
    IN p_correo VARCHAR(100),
    IN p_idRegimen INT,
    IN p_idCategoria INT,
    IN p_condicion VARCHAR(30),
    IN p_inicio_contrato DATE,
    IN p_generar_usuario BIT,
    IN p_username VARCHAR(50),
    IN p_password_hash VARCHAR(255),
    IN p_idRol INT
)
BEGIN
    DECLARE v_idPersona INT;
    DECLARE v_idColaborador INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- 1. Insertar o Actualizar Persona
    SELECT idPersona INTO v_idPersona FROM personas WHERE dni_ce = p_dni;
    
    IF v_idPersona IS NULL THEN
        INSERT INTO personas (dni_ce, nombre1, nombre2, apellido1, apellido2, fecha_nacimiento, telefono, correo)
        VALUES (p_dni, p_nombre1, p_nombre2, p_apellido1, p_apellido2, p_fecha_nacimiento, p_telefono, p_correo);
        SET v_idPersona = LAST_INSERT_ID();
    ELSE
        UPDATE personas 
        SET nombre1 = p_nombre1, nombre2 = p_nombre2, apellido1 = p_apellido1, apellido2 = p_apellido2, 
            telefono = p_telefono, correo = p_correo, fecha_nacimiento = p_fecha_nacimiento 
        WHERE idPersona = v_idPersona;
    END IF;

    -- 2. Insertar Colaborador
    INSERT INTO colaboradores (fk_regimen, inicio_contrato, condicion_laboral, fk_persona, fk_categoria)
    VALUES (p_idRegimen, p_inicio_contrato, p_condicion, v_idPersona, p_idCategoria);
    SET v_idColaborador = LAST_INSERT_ID();

    -- 3. Insertar Usuario (Si corresponde)
    IF p_generar_usuario = 1 THEN
        INSERT INTO usuarios (username, password_hash, estado, fk_rol, fk_colaborador)
        VALUES (p_username, p_password_hash, 1, p_idRol, v_idColaborador);
    END IF;

    COMMIT;
END//

-- SP para Cese Lógico de labores de un colaborador
CREATE PROCEDURE sp_cese_colaborador(
    IN p_idColaborador INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    
    -- Terminar contrato con fecha actual
    UPDATE colaboradores SET fin_contrato = CURRENT_DATE WHERE idColaborador = p_idColaborador;
    
    -- Inactivar cuenta de usuario si existe
    UPDATE usuarios SET estado = 0 WHERE fk_colaborador = p_idColaborador;
    
    COMMIT;
END//

-- ==========================================================================================================
-- ==========================================================================================================DELIMITER ;

