-- Vista para cargar la tabla de aulas configuradas y calcular las vacantes ocupadas en tiempo real
CREATE VIEW vw_aulas_configuradas AS
SELECT 
    gsa.idGradoSeccionAnio,
    al.anio,
    g.nivel_grado,
    g.grado,
    s.nombre_seccion,
    gsa.turno,
    gsa.vacantes,
    (SELECT COUNT(*) 
     FROM matriculas m 
     WHERE m.fk_grado_seccion_anio = gsa.idGradoSeccionAnio 
       AND m.estado_matricula IN ('condicional', 'regularizada', 'activa')) AS vacantes_ocupadas
FROM grado_seccion_anio gsa
INNER JOIN anios_lectivos al ON gsa.fk_anio = al.idAnioLectivo
INNER JOIN grados g ON gsa.fk_grado = g.idGrado
INNER JOIN secciones s ON gsa.fk_seccion = s.idSeccion
ORDER BY al.anio DESC, g.nivel_grado, g.grado, s.nombre_seccion;
