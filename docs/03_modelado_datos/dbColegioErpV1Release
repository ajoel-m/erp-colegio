CREATE DATABASE dbColegioSM;
USE dbColegioSM;

CREATE TABLE roles (
    idRol INT PRIMARY KEY AUTO_INCREMENT,
    nombre_rol VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(150) NULL
);

CREATE TABLE personas (
    idPersona INT PRIMARY KEY AUTO_INCREMENT,
    dni_ce VARCHAR(12) NOT NULL UNIQUE, 
    nombre1 VARCHAR(30) NOT NULL, 
    nombre2 VARCHAR(30) NULL, 
    apellido1 VARCHAR(40) NOT NULL, 
    apellido2 VARCHAR(40) NOT NULL, 
    fecha_nacimiento DATE NOT NULL,
    telefono CHAR(9) NULL, 
    direccion VARCHAR(200) NULL, 
    correo VARCHAR(100) NULL 
); 

CREATE INDEX ix_personas_apellido1 ON personas (apellido1); 
CREATE INDEX ix_personas_apellido2 ON personas (apellido2);

CREATE TABLE apoderados (
    idApoderado INT PRIMARY KEY AUTO_INCREMENT,
    fk_persona INT UNIQUE NOT NULL,
    FOREIGN KEY (fk_persona) REFERENCES personas(idPersona)
);

CREATE TABLE estados_estudiantes (
    idEstadoEstudiante INT PRIMARY KEY AUTO_INCREMENT, 
    nombre_estado VARCHAR(20) NOT NULL,
    CONSTRAINT uk_estado UNIQUE (nombre_estado)
);

CREATE TABLE estudiantes (
    idEstudiante INT PRIMARY KEY AUTO_INCREMENT,
    fk_persona INT UNIQUE NOT NULL,
    fk_estado_estudiante INT NOT NULL,
    FOREIGN KEY (fk_persona) REFERENCES personas(idPersona), 
    FOREIGN KEY (fk_estado_estudiante) REFERENCES estados_estudiantes(idEstadoEstudiante)
); 

CREATE TABLE cat_parentescos (
    idParentesco INT PRIMARY KEY AUTO_INCREMENT,
    parentesco VARCHAR(50) NOT NULL,
    CONSTRAINT uk_parentesco UNIQUE(parentesco)
);

CREATE TABLE apoderados_estudiantes (
    fk_apoderado INT NOT NULL, 
    fk_estudiante INT NOT NULL, 
    fk_parentesco INT NOT NULL,
    PRIMARY KEY (fk_apoderado, fk_estudiante),
    FOREIGN KEY (fk_apoderado) REFERENCES apoderados(idApoderado), 
    FOREIGN KEY (fk_estudiante) REFERENCES estudiantes(idEstudiante), 
    FOREIGN KEY (fk_parentesco) REFERENCES cat_parentescos(idParentesco)
);

CREATE TABLE anios_lectivos (
    idAnioLectivo INT PRIMARY KEY AUTO_INCREMENT, 
    anio CHAR(4) NOT NULL, 
    fecha_inicio DATE NOT NULL, 
    fecha_fin DATE NOT NULL, 
    estado VARCHAR(20) NOT NULL DEFAULT 'VIGENTE' CHECK (estado IN ('VIGENTE', 'FINALIZADO')),
    CONSTRAINT uk_anio_lectivo UNIQUE(anio),
    CONSTRAINT ck_anios_fechas CHECK (fecha_fin > fecha_inicio)
); 

CREATE TABLE tipos_periodizacion (
    idTipoPeriodizacion INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(20) NOT NULL,
    CONSTRAINT uk_tipo_periodizacion UNIQUE (tipo)
);

CREATE TABLE periodos_lectivos (
    idPeriodoLectivo INT PRIMARY KEY AUTO_INCREMENT,
    fk_tipo_periodizacion INT NOT NULL,
    numero SMALLINT NOT NULL,
    fk_anio_lectivo INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    FOREIGN KEY (fk_tipo_periodizacion) REFERENCES tipos_periodizacion(idTipoPeriodizacion),
    FOREIGN KEY (fk_anio_lectivo) REFERENCES anios_lectivos(idAnioLectivo),
    CONSTRAINT uk_periodo_lectivo UNIQUE (fk_tipo_periodizacion, numero, fk_anio_lectivo),
    CONSTRAINT ck_periodos_fechas CHECK (fecha_fin > fecha_inicio)
);

CREATE TABLE secciones (
    idSeccion INT PRIMARY KEY AUTO_INCREMENT, 
    nombre_seccion CHAR(1) UNIQUE NOT NULL DEFAULT 'A'
);

CREATE TABLE grados ( 
    idGrado INT PRIMARY KEY AUTO_INCREMENT,
    nivel_grado VARCHAR(40) NOT NULL CHECK (nivel_grado IN ('primaria', 'secundaria')), 
    grado TINYINT NOT NULL,
    CONSTRAINT chk_grado_valido CHECK (
        (nivel_grado = 'primaria' AND grado BETWEEN 1 AND 6) OR 
        (nivel_grado = 'secundaria' AND grado BETWEEN 1 AND 5)
    )
); 

CREATE TABLE grado_seccion_anio (
    idGradoSeccionAnio INT PRIMARY KEY AUTO_INCREMENT, 
    fk_grado INT NOT NULL, 
    fk_seccion INT NOT NULL,
    fk_anio INT NOT NULL,
    vacantes INT NOT NULL CHECK(vacantes > 0),
    turno VARCHAR(20) NOT NULL CHECK (turno IN ('MAÑANA', 'TARDE')),
    FOREIGN KEY (fk_grado) REFERENCES grados(idGrado), 
    FOREIGN KEY (fk_seccion) REFERENCES secciones(idSeccion),
    FOREIGN KEY (fk_anio) REFERENCES anios_lectivos(idAnioLectivo),
    CONSTRAINT uk_grado_seccion_anio UNIQUE (fk_grado, fk_seccion, fk_anio)
);

CREATE TABLE categorias_colaboradores (
    idCategoriaColaborador INT PRIMARY KEY AUTO_INCREMENT, 
    puesto_colaborador VARCHAR(20) NOT NULL,
    CONSTRAINT uk_puesto UNIQUE (puesto_colaborador)
);

CREATE TABLE cat_regimenes_laborales (
    idRegimen INT PRIMARY KEY AUTO_INCREMENT, 
    nombre_regimen VARCHAR(100) NOT NULL,
    CONSTRAINT uk_regimen UNIQUE (nombre_regimen)
); 

CREATE TABLE colaboradores (
    idColaborador INT PRIMARY KEY AUTO_INCREMENT, 
    fk_regimen INT NOT NULL,
    inicio_contrato DATE NOT NULL, 
    fin_contrato DATE NULL, 
    condicion_laboral VARCHAR(30) NOT NULL,
    fk_persona INT UNIQUE NOT NULL, 
    fk_categoria INT NOT NULL,
    FOREIGN KEY (fk_regimen) REFERENCES cat_regimenes_laborales(idRegimen),
    FOREIGN KEY (fk_persona) REFERENCES personas (idPersona), 
    FOREIGN KEY (fk_categoria) REFERENCES categorias_colaboradores (idCategoriaColaborador)
);

CREATE TABLE usuarios (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    estado BIT NOT NULL DEFAULT 1,
    fk_rol INT NOT NULL,
    fk_colaborador INT UNIQUE NULL,
    FOREIGN KEY (fk_rol) REFERENCES roles(idRol),
    FOREIGN KEY (fk_colaborador) REFERENCES colaboradores(idColaborador)
);

CREATE TABLE matriculas (
    idMatricula INT PRIMARY KEY AUTO_INCREMENT,
    estado_matricula VARCHAR(20) NOT NULL CHECK (estado_matricula IN ('condicional', 'regularizada', 'retirada', 'activa')),
    fk_anio_lectivo INT NOT NULL, 
    fk_grado_seccion_anio INT NOT NULL,
    fk_estudiante INT NOT NULL, 
    fk_colaborador_registrador INT NOT NULL,
    FOREIGN KEY (fk_anio_lectivo) REFERENCES anios_lectivos (idAnioLectivo), 
    FOREIGN KEY (fk_grado_seccion_anio) REFERENCES grado_seccion_anio (idGradoSeccionAnio),
    FOREIGN KEY (fk_estudiante) REFERENCES estudiantes (idEstudiante), 
    FOREIGN KEY (fk_colaborador_registrador) REFERENCES colaboradores (idColaborador), 
    CONSTRAINT uk_matricula_anio UNIQUE (fk_anio_lectivo, fk_estudiante)
);

CREATE TABLE categorias_asignaturas (
    idCategoriaAsignatura INT PRIMARY KEY AUTO_INCREMENT,
    tipo_asignatura VARCHAR(40) NOT NULL,
    CONSTRAINT uk_cat_asignatura UNIQUE (tipo_asignatura) 
);

CREATE TABLE asignaturas (
    idAsignatura INT PRIMARY KEY AUTO_INCREMENT, 
    nombre_asignatura VARCHAR(40) NOT NULL, 
    fk_categoria_asignatura INT NOT NULL,
    FOREIGN KEY (fk_categoria_asignatura) REFERENCES categorias_asignaturas (idCategoriaAsignatura),
    CONSTRAINT uk_nombre_asignatura UNIQUE(nombre_asignatura)
); 

CREATE TABLE asignaturas_grados (
    idAsignaturaGrado INT PRIMARY KEY AUTO_INCREMENT, 
    fk_asignatura INT NOT NULL,
    fk_grado INT NOT NULL,
    FOREIGN KEY (fk_asignatura) REFERENCES asignaturas (idAsignatura),
    FOREIGN KEY (fk_grado) REFERENCES grados(idGrado),
    CONSTRAINT uk_asignatura_grado UNIQUE (fk_asignatura, fk_grado)
);

CREATE TABLE asignaciones_academicas (
    idAsignacionAcademica INT PRIMARY KEY AUTO_INCREMENT,
    fk_docente INT NOT NULL,
    fk_asignatura_grado INT NOT NULL,
    fk_grado_seccion_anio INT NOT NULL,
    FOREIGN KEY (fk_docente) REFERENCES colaboradores(idColaborador),
    FOREIGN KEY (fk_asignatura_grado) REFERENCES asignaturas_grados(idAsignaturaGrado),
    FOREIGN KEY (fk_grado_seccion_anio) REFERENCES grado_seccion_anio(idGradoSeccionAnio),
    CONSTRAINT uk_docente_asignacion UNIQUE (fk_docente, fk_asignatura_grado, fk_grado_seccion_anio)
);

CREATE TABLE horarios_asignaturas (
    idHorarioAsignatura INT PRIMARY KEY AUTO_INCREMENT, 
    hora_inicio TIME NOT NULL, 
    hora_fin TIME NOT NULL, 
    dia_semana VARCHAR(15) NOT NULL CHECK (dia_semana IN ('lunes', 'martes', 'miercoles', 'jueves', 'viernes')), 
    fk_asignacion_academica INT NOT NULL,
    FOREIGN KEY (fk_asignacion_academica) REFERENCES asignaciones_academicas (idAsignacionAcademica),
    CONSTRAINT ck_horas CHECK (hora_fin > hora_inicio),
    CONSTRAINT uk_horario_asignatura UNIQUE (fk_asignacion_academica, dia_semana, hora_inicio, hora_fin)
);


CREATE TABLE tipos_evaluacion (
    idTipoEvaluacion INT PRIMARY KEY AUTO_INCREMENT, 
    nombre VARCHAR(30) NOT NULL UNIQUE, 
    descripcion VARCHAR(100) NULL, 
    es_recuperable BIT NOT NULL DEFAULT 0, 
    tipo_area VARCHAR(20) NOT NULL CHECK (tipo_area IN ('ACADEMICA', 'FISICA', 'TRANSVERSAL'))
);

CREATE TABLE ponderaciones_evaluacion (
    fk_tipo_evaluacion INT NOT NULL, 
    fk_asignacion_academica INT NOT NULL,
    peso DECIMAL (4,2) NOT NULL CHECK (peso>0), 
    PRIMARY KEY (fk_tipo_evaluacion, fk_asignacion_academica),
    FOREIGN KEY (fk_tipo_evaluacion) REFERENCES tipos_evaluacion(idTipoEvaluacion),
    FOREIGN KEY (fk_asignacion_academica) REFERENCES asignaciones_academicas(idAsignacionAcademica)
);

CREATE TABLE evaluaciones(
    idEvaluacion INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE NOT NULL,
    fk_tipo_evaluacion INT NOT NULL,
    fk_asignacion_academica INT NOT NULL,
    fk_periodo_lectivo INT NOT NULL,
    FOREIGN KEY (fk_tipo_evaluacion) REFERENCES tipos_evaluacion (idTipoEvaluacion),
    FOREIGN KEY (fk_asignacion_academica) REFERENCES asignaciones_academicas (idAsignacionAcademica),
    FOREIGN KEY (fk_periodo_lectivo) REFERENCES periodos_lectivos(idPeriodoLectivo)
);

CREATE TABLE resultados_estudiantes(
    idResultadoEstudiante INT PRIMARY KEY AUTO_INCREMENT,
    puntaje DECIMAL (5,2) NOT NULL CHECK (puntaje BETWEEN 0 AND 20),
    fk_estudiante INT NOT NULL, 
    fk_evaluaciones INT NOT NULL,
    observaciones VARCHAR(256),
    FOREIGN KEY (fk_estudiante) REFERENCES estudiantes (idEstudiante), 
    FOREIGN KEY (fk_evaluaciones) REFERENCES evaluaciones(idEvaluacion)
);

CREATE TABLE calificaciones_finales_periodo (
    idCalificacionFinalPeriodo INT PRIMARY KEY AUTO_INCREMENT,
    promedio_final DECIMAL (5,2) NULL CHECK (promedio_final BETWEEN 0 AND 20),
    calificacion_alfabetica CHAR(2) CHECK (calificacion_alfabetica IN ('C', 'B', 'A', 'AD')),
    fk_estudiante INT NOT NULL,
    fk_periodo_lectivo INT NOT NULL,
    fk_asignacion_academica INT NOT NULL,
    FOREIGN KEY (fk_estudiante) REFERENCES estudiantes(idEstudiante),
    FOREIGN KEY (fk_periodo_lectivo) REFERENCES periodos_lectivos(idPeriodoLectivo),
    FOREIGN KEY (fk_asignacion_academica) REFERENCES asignaciones_academicas(idAsignacionAcademica),
    CONSTRAINT uk_calificacion_final UNIQUE (fk_estudiante, fk_periodo_lectivo, fk_asignacion_academica)
);

CREATE TABLE tipos_situacion_final(
    idTipoSituacion INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL UNIQUE, 
    descripcion VARCHAR(200) NULL, 
    permite_matricula_proximo_anio BIT NOT NULL DEFAULT 1
);

CREATE TABLE asistencias_estudiantes (
    idAsistenciaEstudiante INT PRIMARY KEY AUTO_INCREMENT, 
    fecha_asistencia DATE NOT NULL DEFAULT (CURRENT_DATE), 
    esta_presente BIT NOT NULL,
    fk_estudiante INT NOT NULL,
    fk_asignacion_academica INT NOT NULL,
    FOREIGN KEY (fk_estudiante) REFERENCES estudiantes (idEstudiante),
    FOREIGN KEY (fk_asignacion_academica) REFERENCES asignaciones_academicas (idAsignacionAcademica),
    CONSTRAINT uk_asistencia_estudiante UNIQUE (fk_estudiante, fecha_asistencia, fk_asignacion_academica)
);

CREATE TABLE calendarios_escolares(
    idCalendarioEscolar INT PRIMARY KEY AUTO_INCREMENT, 
    descripcion VARCHAR(100) NULL, 
    fk_anio_lectivo INT NOT NULL,
    FOREIGN KEY (fk_anio_lectivo) REFERENCES anios_lectivos (idAnioLectivo)
);

CREATE TABLE actividades_calendarios (
    idActividadCalendario INT PRIMARY KEY AUTO_INCREMENT, 
    nombre_actividad VARCHAR(100) NOT NULL,
    fecha_actividad DATE NOT NULL,
    detalle_actividad VARCHAR(200) NOT NULL, 
    categoria_actividad VARCHAR(40) NOT NULL, 
    fk_calendario_escolar INT NOT NULL,
    FOREIGN KEY (fk_calendario_escolar) REFERENCES calendarios_escolares(idCalendarioEscolar)
);

CREATE TABLE colaboradores_actividades (
    fk_colaborador INT NOT NULL, 
    fk_actividad_calendario INT NOT NULL,
    PRIMARY KEY (fk_colaborador, fk_actividad_calendario),
    FOREIGN KEY (fk_colaborador) REFERENCES colaboradores (idColaborador), 
    FOREIGN KEY (fk_actividad_calendario) REFERENCES actividades_calendarios (idActividadCalendario)
); 

CREATE TABLE asistencias_colaboradores(
    idAsistenciaColaborador INT PRIMARY KEY AUTO_INCREMENT, 
    fecha DATE NOT NULL,
    esta_presente BIT NOT NULL, 
    hay_tardanza BIT NOT NULL,
    hora_entrada TIME NULL, 
    hora_salida TIME NULL, 
    fk_colaborador INT NOT NULL, 
    fk_anio_lectivo INT NOT NULL,
    FOREIGN KEY (fk_colaborador) REFERENCES colaboradores (idColaborador), 
    FOREIGN KEY (fk_anio_lectivo) REFERENCES anios_lectivos (idAnioLectivo),
    CONSTRAINT uk_asistencia_colaborador UNIQUE (fk_colaborador, fecha)
);

CREATE TABLE actas(
    idActa INT PRIMARY KEY AUTO_INCREMENT,
    fk_matricula INT NOT NULL,
    tipo_acta VARCHAR(100),
    fecha_emision DATE NOT NULL DEFAULT (CURRENT_DATE),
    promedio_final DECIMAL(5,2) NOT NULL CHECK(promedio_final BETWEEN 0 AND 20), 
    fk_tipo_situacion INT,
    estado VARCHAR(100),
    fk_colaborador_responsable INT NOT NULL,
    observaciones VARCHAR(250),
    FOREIGN KEY (fk_matricula) REFERENCES matriculas(idMatricula),
    FOREIGN KEY (fk_tipo_situacion) REFERENCES tipos_situacion_final(idTipoSituacion),
    FOREIGN KEY (fk_colaborador_responsable) REFERENCES colaboradores(idColaborador),
    CONSTRAINT uk_acta UNIQUE (fk_matricula, tipo_acta)
);

CREATE TABLE detalle_acta(
    idDetalleActa INT PRIMARY KEY AUTO_INCREMENT, 
    fk_acta INT NOT NULL,
    fk_asignacion_academica INT NOT NULL,
    nota_final DECIMAL (5,2) NOT NULL CHECK (nota_final BETWEEN 0 AND 20), 
    calificacion_alfabetica CHAR(2) CHECK (calificacion_alfabetica IN ('C', 'B', 'A', 'AD')), 
    FOREIGN KEY (fk_acta) REFERENCES actas(idActa),
    FOREIGN KEY (fk_asignacion_academica) REFERENCES asignaciones_academicas(idAsignacionAcademica),
    CONSTRAINT uk_promedio_anual UNIQUE (fk_acta, fk_asignacion_academica)
);

CREATE TABLE asignaturas_pendientes(
    idAsignaturaPendiente INT PRIMARY KEY AUTO_INCREMENT, 
    fk_detalle_acta INT NOT NULL, 
    estado_recuperacion VARCHAR(20) NOT NULL CHECK (estado_recuperacion IN ('PENDIENTE', 'APROBADO', 'DESAPROBADO')), 
    nota_recuperacion DECIMAL (5,2) NULL CHECK (nota_recuperacion BETWEEN 0 AND 20), 
    fecha_evaluacion_recuperacion DATE NULL, 
    FOREIGN KEY (fk_detalle_acta) REFERENCES detalle_acta(idDetalleActa),
    CONSTRAINT uk_asignatura_pendiente UNIQUE (fk_detalle_acta)
); 

DELIMITER //

CREATE TRIGGER trg_asistencia_colaborador_bi
BEFORE INSERT ON asistencias_colaboradores
FOR EACH ROW
BEGIN
    IF NEW.hora_salida IS NOT NULL AND NEW.hora_entrada IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede registrar hora de salida sin hora de entrada';
    END IF;
    IF NEW.hora_salida IS NOT NULL AND NEW.hora_entrada IS NOT NULL AND NEW.hora_salida <= NEW.hora_entrada THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La hora de salida debe ser posterior a la hora de entrada';
    END IF;
END//

CREATE TRIGGER trg_asistencia_colaborador_bu
BEFORE UPDATE ON asistencias_colaboradores
FOR EACH ROW
BEGIN
    IF NEW.hora_salida IS NOT NULL AND NEW.hora_entrada IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede registrar hora de salida sin hora de entrada';
    END IF;
    IF NEW.hora_salida IS NOT NULL AND NEW.hora_entrada IS NOT NULL AND NEW.hora_salida <= NEW.hora_entrada THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La hora de salida debe ser posterior a la hora de entrada';
    END IF;
END//

DELIMITER ;


-- creo que son 37 tablas
