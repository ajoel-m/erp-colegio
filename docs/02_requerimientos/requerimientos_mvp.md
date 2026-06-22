## Requerimientos Funcionales MVP
|        |                                         |                                                                                                                    |                  |
| ------ | --------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | ---------------- |
| Código | Módulo                                  | Requerimiento funcional                                                                                            | Prioridad MoSCoW |
| RF-01  | Seguridad y acceso                      | El sistema debe permitir el inicio y cierre de sesión mediante credenciales válidas.                               | M                |
| RF-02  | Seguridad y acceso                      | El sistema debe restringir el acceso a funcionalidades según el rol del usuario.                                   | M                |
| RF-03  | Seguridad y acceso                      | El sistema debe permitir la administración de usuarios, roles y permisos para un usuario ‘root’ o ‘administrador’. | M                |
| RF-04  | Configuración institucional y académica | El sistema debe permitir registrar y mantener el año lectivo, periodos y calendario escolar.                       | M                |
| RF-05  | Configuración institucional y académica | El sistema debe permitir registrar grados, secciones, vacantes y asignaturas.                                      | M                |
| RF-06  | Gestión de estudiantes y apoderados     | El sistema debe permitir registrar, actualizar, consultar y dar de baja lógica a estudiantes.                      | M                |
| RF-07  | Gestión de estudiantes y apoderados     | El sistema debe permitir registrar, actualizar y vincular apoderados con uno o más estudiantes.                    | M                |
| RF-08  | Matrícula, traslado y retiro            | El sistema debe permitir matricular estudiantes en un año lectivo, grado y sección determinados.                   | M                |
| RF-09  | Matrícula, traslado y retiro            | El sistema debe validar la edad del estudiante antes de permitir la matrícula.                                     | M                |
| RF-10  | Matrícula, traslado y retiro            | El sistema debe validar la existencia de vacantes antes de confirmar una matrícula.                                | M                |
| RF-11  | Matrícula, traslado y retiro            | El sistema debe permitir registrar traslados y retiros conservando el historial del estudiante.                    | S                |
| RF-12  | Matrícula, traslado y retiro            | El sistema debe permitir aprobar matrículas extemporáneas solo a Dirección.                                        | S                |
| RF-13  | Gestión de colaboradores                | El sistema debe permitir registrar y mantener los datos de colaboradores institucionales.                          | M                |
| RF-14  | Gestión de colaboradores                | El sistema debe permitir asociar docentes y personal administrativo a cargos o roles institucionales.              | M                |
|        |                                         |                                                                                                                    |                  |
| RF-18  | Planificación académica                 | El sistema debe permitir asignar docentes a secciones, grados y asignaturas.                                       | M                |
| RF-19  | Planificación académica                 | El sistema debe permitir definir horarios académicos y detectar conflictos de asignación.                          | S                |

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
