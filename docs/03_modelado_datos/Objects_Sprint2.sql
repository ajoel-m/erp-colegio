
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
DELIMITER ;
-- ==========================================================================================================
-- ==========================================================================================================

-- 1. Vista para buscar y cargar datos en la interfaz
CREATE VIEW vw_detalle_colaboradores AS
SELECT 
    c.idColaborador, p.idPersona, p.dni_ce, p.nombre1, p.nombre2, p.apellido1, p.apellido2, 
    p.fecha_nacimiento, p.telefono, p.correo,
    c.fk_regimen, c.fk_categoria, c.condicion_laboral, c.inicio_contrato, c.fin_contrato,
    u.idUsuario, u.username, u.estado AS estado_usuario, u.fk_rol
FROM colaboradores c
INNER JOIN personas p ON c.fk_persona = p.idPersona
LEFT JOIN usuarios u ON u.fk_colaborador = c.idColaborador;

DELIMITER //

-- 2. SP para Actualización Transaccional
CREATE PROCEDURE sp_actualizar_colaborador(
    IN p_idColaborador INT,
    IN p_idPersona INT,
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
    DECLARE v_idUsuario INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Actualizar Persona
    UPDATE personas 
    SET nombre1 = p_nombre1, nombre2 = p_nombre2, apellido1 = p_apellido1, apellido2 = p_apellido2, 
        fecha_nacimiento = p_fecha_nacimiento, telefono = p_telefono, correo = p_correo
    WHERE idPersona = p_idPersona;

    -- Actualizar Colaborador
    UPDATE colaboradores 
    SET fk_regimen = p_idRegimen, fk_categoria = p_idCategoria, condicion_laboral = p_condicion, inicio_contrato = p_inicio_contrato
    WHERE idColaborador = p_idColaborador;

    -- Manejo Dinámico de Usuario
    SELECT idUsuario INTO v_idUsuario FROM usuarios WHERE fk_colaborador = p_idColaborador LIMIT 1;
    
    IF p_generar_usuario = 1 THEN
        IF v_idUsuario IS NULL THEN
            INSERT INTO usuarios (username, password_hash, estado, fk_rol, fk_colaborador)
            VALUES (p_username, p_password_hash, 1, p_idRol, p_idColaborador);
        ELSE
            UPDATE usuarios SET username = p_username, fk_rol = p_idRol, estado = 1 WHERE idUsuario = v_idUsuario;
            IF p_password_hash IS NOT NULL AND p_password_hash != '' THEN
                UPDATE usuarios SET password_hash = p_password_hash WHERE idUsuario = v_idUsuario;
            END IF;
        END IF;
    ELSE
        IF v_idUsuario IS NOT NULL THEN
            UPDATE usuarios SET estado = 0 WHERE idUsuario = v_idUsuario;
        END IF;
    END IF;

    COMMIT;
END//
DELIMITER ;

-- ==========================================================================================================
-- ==========================================================================================================

