/* ROLLUP */
SELECT ub.ciudad, tm.dia, CONCAT(cl.nombre, ' ',cl.apellido) AS Cliente, SUM(he.beneficio) as total_beneficio
FROM hechos_entregas AS he
JOIN dim_cliente AS cl ON cl.id_cliente = he.id_cliente
JOIN dim_tiempo AS tm ON tm.id_tiempo = he.id_tiempo
JOIN dim_ubicacion AS ub ON ub.id_ubicacion = he.id_ubicacion
GROUP BY ROLLUP(ub.ciudad, tm.dia, cl.nombre, cl.apellido );

/* CUBE */
SELECT ub.ciudad, tm.dia, CONCAT(cl.nombre, ' ',cl.apellido) AS Cliente, SUM(he.beneficio) as total_beneficio
FROM hechos_entregas AS he
JOIN dim_cliente AS cl ON cl.id_cliente = he.id_cliente
JOIN dim_tiempo AS tm ON tm.id_tiempo = he.id_tiempo
JOIN dim_ubicacion AS ub ON ub.id_ubicacion = he.id_ubicacion
GROUP BY CUBE(ub.ciudad, tm.dia, cl.nombre, cl.apellido );

/* SLICE */
SELECT he.id_cliente, he.id_tiempo, he.id_ubicacion, he.precio_total, he.coste_envio, he.beneficio, he.estado_entrega, 
		ub.ciudad, tm.dia, CONCAT(cl.nombre, ' ',cl.apellido) AS Cliente
FROM hechos_entregas AS he
JOIN dim_cliente AS cl ON cl.id_cliente = he.id_cliente
JOIN dim_tiempo AS tm ON tm.id_tiempo = he.id_tiempo
JOIN dim_ubicacion AS ub ON ub.id_ubicacion = he.id_ubicacion
WHERE he.id_cliente = 1;

/* DICE */
SELECT he.id_cliente, he.id_tiempo, he.id_ubicacion, he.precio_total, he.coste_envio, he.beneficio, he.estado_entrega, 
		ub.ciudad, tm.dia, CONCAT(cl.nombre, ' ',cl.apellido) AS Cliente
FROM hechos_entregas AS he
JOIN dim_cliente AS cl ON cl.id_cliente = he.id_cliente
JOIN dim_tiempo AS tm ON tm.id_tiempo = he.id_tiempo
JOIN dim_ubicacion AS ub ON ub.id_ubicacion = he.id_ubicacion
WHERE (he.id_cliente = 1 OR he.id_cliente = 2)  AND he.id_tiempo = 2;


/* PIVOT */
-- Cargar la extensión tablefunc si no está habilitada
CREATE EXTENSION IF NOT EXISTS tablefunc;
-- Consulta de pivote utilizando crosstab
SELECT * FROM crosstab(
  'SELECT
     t.dia,
	 t.fecha_envio,
	 d.sexo,
     SUM(h.beneficio) AS beneficio
   FROM
     dim_tiempo t
     JOIN hechos_entregas h ON t.id_tiempo = h.id_tiempo
     JOIN dim_cliente d ON h.id_cliente = d.id_cliente
   GROUP BY t.dia, t.fecha_envio, d.sexo
   ORDER BY 1, 2',
  'SELECT DISTINCT sexo FROM dim_cliente ORDER BY 1'
) AS ct(dia_envio VARCHAR, fecha_envio date, femenino NUMERIC, masculino NUMERIC, otro NUMERIC);