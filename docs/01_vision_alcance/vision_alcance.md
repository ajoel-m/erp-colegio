### 1.1 Propósito

Definir los requisitos funcionales y no funcionales para el desarrollo de la Versión 1.0 (V1.0) del ERP escolar, orientado a la gestión integral de instituciones educativas de nivel primario y secundario.

### 1.2 Objetivo del sistema

Digitalizar y centralizar los procesos de gestión institucional, permitiendo administrar la población estudiantil, personal académico, procesos de matrícula, control de asistencia, evaluación académica y emisión de documentos oficiales, mediante una aplicación de escritorio.

### 1.3 Alcance del MVP

La Versión 1.0 cubrirá el ciclo académico completo:

- Módulo de Seguridad: Control de acceso, roles y permisos de usuarios.

- Módulo de Personas: Gestión de estudiantes, apoderados (y su vinculación) y colaboradores.

- Módulo Académico (Configuración): Gestión de años lectivos, periodos, grados, secciones, asignaturas y asignación de carga docente con control de horarios.

- Módulo de Matrículas: Registro de matrículas regulares y extemporáneas con validación de vacantes y edad.

- Módulo de Operación Diaria: Registro de asistencia de estudiantes y colaboradores.

- Módulo de Evaluación: Definición de ponderaciones, registro de evaluaciones y cálculo automático de notas o promedios.

- Módulo de Cierre y Reportes: Generación de actas oficiales, promedios anuales, situaciones finales (Promovido/Repite) y reportes institucionales.

No forman parte de la V1.0 (Futura Escalabilidad):

- Integración directa con la API del SIAGIE (Ministerio de Educación).

- Módulo de facturación o control de pagos/pensiones.

Flujo del Sistema:
[ Configuración y Matrícula ] ──> [ Operación: Asistencia y Notas ] ──> [ Cierre: Actas y Reportes ]

### 1.4  Stakeholders

|Stakeholder|Interés|
|---|---|
|Director|Supervisión institucional reportes estadísticos y aprobación de documentos oficiales.|
|Secretaria|Operación administrativa eficiente (matrículas, atención a apoderados, constancias).|
|Docente|Gestión ágil de sus aulas, toma de asistencia y registro de calificaciones.|
|Administrador del sistema|Gestión técnica, auditoría y seguridad de la información.|
|Institución educativa|Modernización, trazabilidad de datos y reducción de tiempos operativos.|

---

## 1.5. Actores

#### Administrador

Responsable de la creación de usuarios, asignación de roles y configuración técnica inicial de la base de datos.

#### Director

Responsable de la configuración académica (apertura del año lectivo, creación de aulas, asignación docente) y la visualización de reportes de rendimiento.

#### Secretaria

Responsable del registro de estudiantes, actualización de datos de apoderados y ejecución del proceso de matrícula.

#### Docente

Responsable de acceder a su carga académica asignada, registrar la asistencia diaria de sus estudiantes y procesar las calificaciones por periodo.
#### Docente

Responsable de consultar información académica asignada.
