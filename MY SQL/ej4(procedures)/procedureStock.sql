-- 1
DELIMITER //

CREATE PROCEDURE update_stock()
BEGIN
	DECLARE sigue BOOLEAN DEFAULT true;
	
	DECLARE CONTINUE handler FOR NOT FOUND set sigue = FALSE;
	DECLARE v_codProd int;
	DECLARE v_cantProd int;
	
	
	DECLARE product CURSOR FOR (
		SELECT p.codProducto ,sum(ip.cantidad ) AS cantProd
		FROM ingresostock i  
		JOIN ingresostock_producto ip ON i.idIngreso  = ip.IngresoStock_idIngreso 
		JOIN producto p ON ip.Producto_codProducto = p.codProducto 
		WHERE i.fecha > now() - INTERVAL 2 WEEK
		GROUP BY p.codProducto 
	);
	
	OPEN product;
	bucle: LOOP 
		FETCH product INTO v_codProd,v_cantProd;
		IF NOT sigue THEN
			LEAVE bucle;
		END IF;
		UPDATE producto 
		SET cantidad = cantidad + v_cantProd
		WHERE codProducto = v_codProd;
	END LOOP;
	CLOSE product;
END ;

DELIMITER ;
