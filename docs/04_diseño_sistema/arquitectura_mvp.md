### Arquitectura:
El sistema se rige bajo una **Arquitectura Lógica de Tres Capas**, implementada a través del patrón arquitectónico **MVC (Modelo-Vista-Controlador)**. Esta estructura garantiza la separación de responsabilidades, facilitando el mantenimiento, la depuración y el cumplimiento del requerimiento no funcional de mantenibilidad (RNF-08) en un entorno de escritorio desarrollado con Java Swing.

- **Capa de Presentación (Vista):** Compuesta exclusivamente por las interfaces gráficas (Formularios `JFrame`, `JPanel`, `JDialog`). Su única responsabilidad es la captura de eventos del usuario y la renderización de la información. Esta capa carece de lógica de negocio o sentencias de acceso a datos.
    
- **Capa de Negocio (Controlador):** Actúa como el puente orquestador del sistema. Escucha los eventos generados por la Vista (botones, selección de tablas), ejecuta las reglas de negocio (ej. validación de disponibilidad de vacantes, validación de edades mínimas) y solicita el procesamiento de datos a la capa inferior.
    
- **Capa de Acceso a Datos (Modelo):** Encargada de la persistencia de la información. Gestiona la conexión al motor de base de datos MySQL y ejecuta las sentencias SQL puras mediante la API JDBC.
