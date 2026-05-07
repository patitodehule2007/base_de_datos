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
		SET stock = stock + v_cantProd
		WHERE codProducto = v_codProd;
	END LOOP;
	CLOSE product;
END ;

DELIMITER ;

-- 2
DELIMITER //

CREATE PROCEDURE update_prices()
BEGIN
    DECLARE  cursor_prices CURSOR FOR (
    SELECT COUNT(*),codProducto FROM producto
    Join stocks.pedido_producto pp on producto.codProducto = pp.Producto_codProducto
    GROUP BY codProducto
    ) ;
    DECLARE sigue boolean default TRUE;
    DECLARE CONTINUE handler for not found set sigue = false;

    DECLARE v_num_Prod int;
    DECLARE v_cod_Prod int;


    OPEN cursor_prices;
    bucle: loop
        fetch cursor_prices into v_num_Prod,v_cod_Prod;
        if(NOT sigue) THEN
            leave bucle;
        end if;
        if(v_num_Prod < 100) THEN
            UPDATE producto
                set precio = precio*0.9
                WHERE producto.codProducto = v_cod_Prod;
        end if;
    end loop;
    CLOSE cursor_prices;
end;

DELIMITER ;