### Patrones de Diseño

Para asegurar un código limpio y evitar el fuerte acoplamiento entre los componentes gráficos y la base de datos, el sistema implementa los siguientes patrones de diseño de software:

- **Data Access Object (DAO):** Patrón estructural fundamental que abstrae y encapsula todos los accesos a la base de datos. Por cada entidad principal del dominio existe una clase DAO (ej. `EstudianteDAO`, `MatriculaDAO`) encargada exclusivamente de las operaciones CRUD (Create, Read, Update, Delete). El controlador interactúa con la base de datos únicamente a través del DAO, manteniendo el código SQL completamente aislado.
    
- **Data Transfer Object (DTO) / Entidades:** Clases Java planas (POJOs) que representan las entidades del dominio (ej. `Estudiante`, `Matricula`, `Usuario`). Su función es encapsular y transportar los datos de forma segura e íntegra a través de las distintas capas del sistema (desde el DAO, pasando por el Controlador, hasta la Vista).
    
- **Singleton:** Patrón creacional aplicado de forma estricta a la clase gestora de la base de datos (`ConexionDB`). Garantiza la instanciación de una única conexión compartida a MySQL durante todo el ciclo de vida de la aplicación. Esto optimiza el consumo de memoria y previene bloqueos por sobrecarga de peticiones concurrentes a la base de datos.
### Principios Rectores de Desarrollo (SOLID)

El desarrollo del código fuente en Java respetará los principios SOLID para garantizar la mantenibilidad y escalabilidad del MVP:

- **Principio de Responsabilidad Única (SRP):** Cada clase tendrá un único propósito. La interfaz gráfica (`JFrame`) no procesará lógica, el `Controlador` no ejecutará sentencias SQL, y el `DAO` no validará reglas de negocio.
    
- **Principio de Abierto/Cerrado (OCP):** El sistema estará abierto a la extensión pero cerrado a la modificación. (Ejemplo: la futura implementación del patrón _Strategy_ para exportar reportes permitirá añadir nuevos formatos sin modificar el código existente).
    
- **Principio de Segregación de Interfaces (ISP):** Se crearán interfaces específicas para cada DAO (ej. `IEstudianteDAO`), evitando que las clases implementen métodos que no necesitan.
