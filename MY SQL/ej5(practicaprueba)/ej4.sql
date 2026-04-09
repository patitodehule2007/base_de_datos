DROP VIEW IF EXISTS DatosVentas;

CREATE VIEW DatosVentas AS(
SELECT co.*,cl.dni,cl.mail,a.patente,a.color,m.marca, estaPagado(co.id) as pagado FROM compra co
JOIN cliente cl ON cl.dni = co.cliente_dni
JOIN auto a ON co.auto_patente = a.patente
JOIN modelo m ON m.id = a.modelo_id)
