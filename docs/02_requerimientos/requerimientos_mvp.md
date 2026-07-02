### Requerimientos Funcionales (V1.0)

|**Código**|**Módulo**|**Requerimiento funcional**|**Prioridad (MoSCoW)**|
|---|---|---|---|
|**RF-01**|Seguridad y acceso|El sistema debe permitir el inicio y cierre de sesión mediante credenciales válidas.|**M**|
|**RF-02**|Seguridad y acceso|El sistema debe restringir el acceso a funcionalidades según el rol del usuario.|**M**|
|**RF-03**|Seguridad y acceso|El sistema debe permitir la administración de usuarios, roles y permisos.|**M**|
|**RF-04**|Config. Institucional|El sistema debe permitir registrar y mantener el año lectivo, periodos y calendario escolar.|**M**|
|**RF-05**|Config. Institucional|El sistema debe permitir registrar grados, secciones, vacantes y asignaturas.|**M**|
|**RF-06**|Estudiantes y apoderados|El sistema debe permitir registrar, actualizar, consultar y dar de baja a estudiantes.|**M**|
|**RF-07**|Estudiantes y apoderados|El sistema debe permitir registrar, actualizar y vincular apoderados con estudiantes.|**M**|
|**RF-08**|Matrícula y traslados|El sistema debe permitir matricular estudiantes en un año, grado y sección.|**M**|
|**RF-09**|Matrícula y traslados|El sistema debe validar la edad del estudiante antes de permitir la matrícula.|**M**|
|**RF-10**|Matrícula y traslados|El sistema debe validar la existencia de vacantes antes de confirmar una matrícula.|**M**|
|**RF-11**|Matrícula y traslados|El sistema debe permitir registrar traslados y retiros conservando el historial.|**S**|
|**RF-12**|Matrícula y traslados|El sistema debe permitir aprobar matrículas extemporáneas solo a Dirección.|**S**|
|**RF-13**|Gestión de colaboradores|El sistema debe permitir registrar y mantener los datos de colaboradores.|**M**|
|**RF-18**|Planificación académica|El sistema debe permitir asignar docentes a secciones, grados y asignaturas.|**M**|
|**RF-19**|Planificación académica|El sistema debe permitir definir horarios académicos y detectar conflictos.|**S**|
|**RF-20**|**Control de Asistencia**|El sistema debe permitir al docente registrar la asistencia diaria de los estudiantes por cada clase (asignación académica).|**M**|
|**RF-21**|**Control de Asistencia**|El sistema debe permitir registrar la hora de entrada y salida de los colaboradores.|**M**|
|**RF-22**|**Evaluaciones y Notas**|El sistema debe permitir al docente configurar tipos de evaluación y ponderaciones por asignatura.|**M**|
|**RF-23**|**Evaluaciones y Notas**|El sistema debe permitir registrar calificaciones numéricas decimales (0 a 20) por estudiante.|**M**|
|**RF-24**|**Evaluaciones y Notas**|El sistema debe calcular automáticamente promedios y realizar su conversión a la escala alfabética.|**M**|
|**RF-25**|**Cierre y Actas**|El sistema debe generar actas finales calculando automáticamente la situación del estudiante (Promovido/Repite) según sus promedios.|**M**|
|**RF-26**|**Cierre y Actas**|El sistema debe permitir a Dirección ejecutar el cierre del año lectivo, bloqueando definitivamente la modificación de notas y asistencias.|**M**|


## Requerimientos no Funcionales
|        |                     |                                                                                                              |                  |
| ------ | ------------------- | ------------------------------------------------------------------------------------------------------------ | ---------------- |
| Código | Categoría           | Requerimiento no funcional                                                                                   | Prioridad MoSCoW |
|        |                     |                                                                                                              |                  |
| RNF-03 | Seguridad           | Las credenciales deben protegerse con un mecanismo robusto de almacenamiento seguro de contraseñas.          | M                |
|        |                     |                                                                                                              |                  |
| RNF-08 | Mantenibilidad      | La solución debe separar claramente lógica de negocio, acceso a datos y presentación.                        | M                |
|        |                     |                                                                                                              |                  |
| RNF-01 | Usabilidad          | La interfaz debe ser responsive y funcionar correctamente en escritorio, tablet y móvil.                     | S                |
| RNF-07 | Compatibilidad      | El sistema debe operar correctamente en navegadores web modernos y en dispositivos móviles de uso frecuente. | S                |
|        |                     |                                                                                                              |                  |
| RNF-06 | Disponibilidad      | La plataforma debe garantizar una disponibilidad del 99% durante el calendario escolar.                      | S                |
|        |                     |                                                                                                              |                  |
| RNF-05 | Tolerancia a fallos | El sistema debe permitir copias de seguridad periódicas y restauración de la base de datos.                  | S                |
