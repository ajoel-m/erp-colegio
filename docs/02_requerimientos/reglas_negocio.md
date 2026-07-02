## Reglas del negocio:
### Matricula

| Código | Nombre de la regla                     | Tipo                        | Regla refinada                                                                                                                                                         |
| ------ | -------------------------------------- | --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| RN-11  | Validación documental de matrícula     | Restricción administrativa  | Un estudiante no podrá adquirir estado de matrícula definitiva mientras no se valide la documentación obligatoria exigida por la institución y la normativa educativa. |
| RN-12  | Estados de matrícula                   | Regla operativa             | El proceso de matrícula debe manejar estados institucionales diferenciados como matrícula condicional, regularizada y retirada.                                        |
| RN-13  | Edad mínima de ingreso a primaria      | Restricción normativa       | El estudiante matriculado en primer grado de primaria debe cumplir la edad mínima establecida por la normativa educativa vigente.                                      |
| RN-14  | Asignación de vacantes                 | Restricción operativa       | La matrícula de estudiantes está sujeta a la disponibilidad de vacantes por grado y sección.                                                                           |
| RN-15  | Matrícula extemporánea                 | Restricción de autorización | Solo Dirección puede aprobar matrículas fuera del cronograma oficial.                                                                                                  |
| RN-18  | Permanencia académica anual            | Estructura académica        | Un estudiante solo puede pertenecer a una sección por grado dentro de un mismo año lectivo.                                                                            |
| RN-19  | Relación estudiante-apoderado          | Estructura organizacional   | Un apoderado puede estar asociado a uno o varios estudiantes.                                                                                                          |
| RN-20  | Conservación del historial estudiantil | Trazabilidad institucional  | Los traslados, retiros y cambios académicos del estudiante deben conservar su historial institucional.                                                                 |

### Seguridad

| Código | Nombre de la regla            | Tipo                          | Regla refinada                                                                                                              |
| ------ | ----------------------------- | ----------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| RN-06  | Restricción de acceso docente | Seguridad / Compartimentación | Un docente solo puede acceder a la información académica correspondiente a las secciones y asignaturas que tiene asignadas. |

### Académico

| Código | Nombre de la regla                     | Tipo                        | Regla refinada                                                                                                                                                         |
| ------ | -------------------------------------- | --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|RN-16|Distribución horaria docente|Restricción de planificación académica|Un docente no puede tener asignaciones simultáneas en más de una sección o asignatura dentro del mismo bloque horario.|
|RN-17|Integridad de horarios académicos|Restricción operativa|Los horarios académicos no deben presentar conflictos entre docentes, aulas, grados o secciones.|


### Nuevas Reglas de Negocio (V1.0)

|**Código**|**Nombre de la regla**|**Tipo**|**Regla refinada**|
|---|---|---|---|
|**RN-21**|Registro de asistencia por asignatura|Operativa|La asistencia estudiantil no es un registro diario global, sino que debe estar estrictamente vinculada a la asignación académica (docente-asignatura-aula) correspondiente.|
|**RN-22**|Responsabilidad de calificación|Seguridad|Únicamente el docente vinculado formalmente a una asignación académica tiene autorización para registrar o modificar las calificaciones de dicho grupo.|
|**RN-23**|Escala de calificación y conversión|Lógica de cálculo|El ingreso de calificaciones al sistema se realizará exclusivamente en formato numérico decimal (0 a 20). El sistema realizará la conversión a escala alfabética (AD, A, B, C) de forma automática únicamente para la visualización y emisión de reportes.|
|**RN-24**|Determinación de Situación Final|Lógica de negocio|Al generar el acta final, el sistema calculará automáticamente si el estudiante es 'PROMOVIDO' o 'REPITENTE' basándose en los promedios. Los estudiantes repitentes quedarán habilitados para matricularse en las secciones regulares disponibles del siguiente año (no en secciones exclusivas).|
|**RN-25**|Cierre de Año Lectivo|Restricción administrativa|El cierre del año lectivo es potestad exclusiva de la Dirección, debe alinearse al calendario escolar (MINEDU) y su ejecución bloqueará de forma irreversible cualquier modificación de notas o asistencias de ese periodo.|
