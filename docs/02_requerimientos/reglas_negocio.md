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
