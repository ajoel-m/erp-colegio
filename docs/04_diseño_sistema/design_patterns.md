### Patrones seguidos

Para asegurar un código limpio y evitar el fuerte acoplamiento entre los componentes gráficos y la base de datos, el sistema implementa los siguientes patrones de diseño de software:

- **Data Access Object (DAO):** Patrón estructural fundamental que abstrae y encapsula todos los accesos a la base de datos. Por cada entidad principal del dominio existe una clase DAO (ej. `EstudianteDAO`, `MatriculaDAO`) encargada exclusivamente de las operaciones CRUD (Create, Read, Update, Delete). El controlador interactúa con la base de datos únicamente a través del DAO, manteniendo el código SQL completamente aislado.

El sistema utiliza clases DAO para concentrar las operaciones con la base de datos. Cada DAO contiene las consultas SQL o llamadas a procedimientos almacenados relacionadas con una entidad del sistema.

Para mantener el código ordenado, cada clase tendrá una responsabilidad clara. Los formularios se encargarán de la interacción con el usuario, los controladores coordinarán las acciones y los DAO realizarán las operaciones con la base de datos.

El módulo de reportes permitirá generar actas y resúmenes académicos. Inicialmente se priorizará la generación en PDF o mediante JasperReports, según el avance del proyecto.
