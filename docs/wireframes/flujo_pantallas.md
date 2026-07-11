## Lista Final de Wireframes y Especificación de Componentes (V1.0)
### I. Contenedores y Acceso Principal
- FrmLogin (JDialog - Modal):

Propósito: Bloquear el acceso al sistema hasta la validación de credenciales.

Componentes: JTextField (Usuario), JPasswordField (Contraseña encriptada) y JButton (Ingresar/Salir).

Flujo: Consulta la tabla usuarios cruzando con roles para inicializar la sesión del empleado.

- FrmPrincipal (JFrame - Maximizado MDI):

Propósito: Actuar como la ventana maestra de la institución.

Componentes: JMenuBar superior con opciones compartimentadas y un JDesktopPane central. Incorpora un JPanel inferior como barra de estado para mostrar de forma persistente el usuario activo, su rol y el año lectivo vigente.

Flujo: Habilita o deshabilita los JMenuItem dinámicamente según el rol del usuario autenticado para cumplir con las restricciones de seguridad.

### II. Paneles Operativos de Gestión (Cargados internamente en el JDesktopPane)
- pnlConfigAcademica (Sprint 2 - Depurado):

Propósito: Configurar la estructura del año escolar y las aulas.

Componentes: JPanel con bordes titulados para la apertura del año (campos de texto para año y componentes JDateChooser para fechas de inicio/fin) y otro para la asignación de vacantes (JComboBox cargados dinámicamente para nivel, grado y sección, y un campo numérico para vacantes). Incluye un JTable de solo lectura para listar la oferta configurada.

Flujo: Almacena los datos en anios_lectivos y mapea la capacidad física en grado_seccion_anio.

- pnlGestionColab (Sprint 2 - Depurado con Dirección):

Propósito: Administrar el legajo del personal docente y administrativo.

Componentes: Bloque de datos personales que incluye obligatoriamente el campo unificado para nombres, apellidos, teléfono, correo, fecha de nacimiento y el campo de dirección físico. Bloque laboral con selectores para cargo, régimen contratado y fecha de inicio. Bloque de acceso con una casilla (JCheckBox) que habilita los campos de usuario, rol y contraseña si el colaborador requiere acceso al sistema.

Flujo: Modifica y registra de forma masiva a través de los procedimientos almacenados correspondientes.

- pnlGestionEstudiantes (Sprint 3 - Depurado con UX Interactiva):

Propósito: Registrar y mantener las fichas de los alumnos y sus apoderados en una sola vista.

Componentes: * Bloque Estudiante: Cuadros de texto unificados para Nombres y Apellidos, selector de fecha de nacimiento y un JComboBox para el estado institucional (leído de estados_estudiantes). Se omite el campo dirección.

Bloque Apoderado: Campo txtDniApoderado. Cuenta con un escuchador KeyReleased que, al detectar 8 dígitos, busca en la base de datos y autocompleta nombres, teléfono y correo si el registro ya existe. Selector dinámico para el parentesco (cat_parentescos).

Bloque de Navegación: Campo txtBusquedaRapida con filtro en tiempo real mediante KeyReleased conectado a un JTable que muestra las relaciones de la vista de estudiantes.

Flujo: Inserta de manera transaccional en personas, estudiantes, apoderados y apoderados_estudiantes.

- pnlAsignacionDocente (Sprint 4 - Depurado):

Propósito: Planificar y estructurar la carga académica de los profesores.

Componentes: Selector de búsqueda de docentes, combos dinámicos para el año vigente, grado/aula y asignaturas (poblado desde asignaturas_grados). Matriz o tabla horaria para definir días de la semana y bloques de tiempo (hora inicio/fin).

Flujo: El controlador valida la distribución horaria para impedir cruces simultáneos en el mismo horario antes de realizar la inserción en asignaciones_academicas y horarios_asignaturas.

- pnlMatricula (Sprint 4 - Depurado):

Propósito: Ejecutar la inscripción de los estudiantes en los periodos escolares correspondientes.

Componentes: Campo de búsqueda rápida por DNI del alumno (con trigger de auto-búsqueda al llegar al octavo carácter) que muestra los datos personales en etiquetas de solo lectura. Selectores académicos de año lectivo, grado, sección y turno con indicadores visuales de vacantes disponibles. Bloque de validación normativa con casillas automáticas deshabilitadas que verifican de forma interna la edad cronológica y el cupo en el aula.

Flujo: Inserta el registro definitivo en la tabla matriculas bajo una transacción segura que descuenta la vacante.

- pnlAsistenciaEstudiantes (Sprint 5 - Depurado):

Propósito: Permitir al docente registrar la asistencia diaria vinculada a su curso.

Componentes: Selector desplegable que muestra exclusivamente la carga académica del docente logueado para el día y hora actual. Un JTable que carga la lista de los alumnos matriculados en dicha sección, incorporando una columna renderizada con un componente JCheckBox booleano para marcar la asistencia de forma masiva o individual.

Flujo: Registra los estados de forma directa en asistencias_estudiantes.

- pnlControlPersonal (Sprint 5 - Depurado):

Propósito: Terminal autónomo de marcación de jornada laboral para los colaboradores.

Componentes: Reloj digital interactivo en la cabecera actualizado mediante un hilo de ejecución en tiempo real (Timer). Un único campo de entrada de texto enfocado por defecto para capturar el DNI del trabajador y botones grandes para definir la acción (Entrada / Salida). Un área de texto o tabla inferior de solo lectura para listar las últimas marcaciones exitosas del día.

Flujo: Envía la transacción a asistencias_colaboradores y procesa de forma interna las excepciones capturadas desde los triggers del motor de base de datos.

- pnlEvaluaciones (Sprint 6 - Depurado):

Propósito: Controlar el ingreso de calificaciones de los periodos lectivos bimestrales o trimestrales.

Componentes: Selectores superiores de asignatura asignada y periodo académico vigente. Un JTable dinámico donde las columnas se estructuran según los tipos de evaluación configurados. Las celdas de puntajes numéricos decimales (0 a 20) son editables. Las columnas de Promedio Final y Calificación Alfabética son estrictamente de solo lectura.

Flujo: Un escuchador sobre el modelo de la tabla intercepta cuando una nota es modificada y calcula localmente la equivalencia alfabética (AD, A, B, C) antes de efectuar la persistencia en resultados_estudiantes y calificaciones_finales_periodo.

- pnlActasCierre (Sprint 7 - Depurado):

Propósito: Emitir los documentos oficiales de rendimiento y procesar la clausura irreversible del año.

Componentes: Selectores de sección y grado para generar una vista tabular con los promedios anuales consolidados de los estudiantes y su Situación Final calculada de manera automática (Promovido / Repitente). Botones para la exportación directa de actas a formato PDF. En la sección inferior, un botón de seguridad crítico para ejecutar el cierre definitivo respaldado por cuadros de confirmación severos.

Flujo: Almacena masivamente en las tablas actas y detalle_acta, y cambia el estado del año lectivo a 'FINALIZADO', bloqueando futuras modificaciones en cascada.
