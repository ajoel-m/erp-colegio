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
