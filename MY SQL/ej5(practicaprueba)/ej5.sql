DROP VIEW IF EXISTS resumen_ventas;

CREATE VIEW resumen_ventas AS(
	SELECT m.marca,
	cantidad_autos_vendidos(m.id,c.fecha) AS Vendidos,
	COUNT(a.patente) AS cantidad_ventas,
	SUM(c.precio) AS ganacia,
	(SELECT c2.fecha FROM compra c2 
		WHERE  MONTH(c2.fecha) = MONTH(c.fecha) 
		AND YEAR(c2.fecha) = YEAR(c.fecha) 
		GROUP BY  c2.fecha
		ORDER BY SUM(c2.precio) DESC LIMIT 1 
		
	) 
	FROM modelo m 
		JOIN auto a ON a.modelo_id = m.id
		JOIN compra c ON c.auto_patente = a.patente
	GROUP BY YEAR(c.fecha), MONTH(c.fecha) ,a.modelo_id
)
