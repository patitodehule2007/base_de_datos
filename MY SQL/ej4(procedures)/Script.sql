


DELIMITER // 

#1 
DROP PROCEDURE IF EXISTS ProdMayorAlProm  //

CREATE  PROCEDURE IF NOT EXISTS ProdMayorAlProm(OUT p_num_Gente INT)
BEGIN
	DECLARE v_prom float;
	SELECT AVG(p.buyPrice ) INTO v_prom FROM products p ;

	SELECT * FROM products p 
	WHERE p.buyPrice  > v_prom;
	
	SELECT AVG(p.buyPrice ) INTO v_prom FROM products p ;
	SELECT COUNT(*) INTO p_num_Gente FROM products p 
	WHERE p.buyPrice  > v_prom;
	
END //

DELIMITER ;

CALL ProdMayorAlProm(@cantGente);
SELECT @cantGente;


# 2


DELIMITER //

DROP PROCEDURE  IF EXISTS BorrarOrden //

CREATE PROCEDURE IF NOT EXISTS BorrarOrden(IN p_order_number int,OUT p_afected_Rows INT)
BEGIN
	
	SELECT 0 INTO p_afected_Rows;
	
	DELETE FROM orderdetails
	WHERE orderNumber = p_order_number;

	SELECT ROW_COUNT()  INTO p_afected_Rows;

	DELETE FROM orders 
	WHERE orderNumber = p_order_number;
	
	
END //

DELIMITER ;

CALL BorrarOrden(10100,@afected_Rows);
SELECT @afected_Rows AS Filas_Eliminadas;




# 3

DELIMITER // 

DROP PROCEDURE IF EXISTS DeleteProductLine //

CREATE PROCEDURE IF NOT EXISTS DeleteProductLine(IN p_product_Line_code VARCHAR(256) ,OUT p_text_res VARCHAR(256))
BEGIN
	IF (Producs_on_Lines(p_product_Line_code) <> 0) THEN
	SELECT "La línea de productos no pudo borrarse porque contiene productos asociados" INTO p_text_res;
	ELSE
		DELETE FROM productlines 
		WHERE productLine = p_product_Line_code;
		SELECT "La línea de productos fue borrada" INTO p_text_res;
	END IF;
	
END //


DELIMITER ;

CALL DeleteProductLine("Classic Cars", @Text_Res);
SELECT @Text_Res AS Resultado;



# 4

DELIMITER //

DROP PROCEDURE IF EXISTS Modify_order_coment //

CREATE PROCEDURE IF NOT EXISTS Modify_order_coment(IN p_order_Number int,IN p_comment varchar(256),OUT opCode INT)
BEGIN
	UPDATE orders 
	SET comments = p_comment
	WHERE orderNumber  = p_order_Number;
	# le ponemos esto xq el orderNumber es unique o con lo cual es maximo es 1
	SELECT ROW_COUNT() INTO opCode;
	
END //

DELIMITER ;

CALL Modify_order_coment(10100,"pepe",@Modify_order_coment_opCode);
SELECT @Modify_order_coment_opCode AS Res;




# 9

DELIMITER //

DROP PROCEDURE IF EXISTS  ListaCiudades //

CREATE PROCEDURE IF NOT EXISTS ListaCiudades(OUT p_listaCiudades VARCHAR(4000)  )
BEGIN
	DECLARE hayFilas int DEFAULT 1;
	DECLARE ciudad varchar(256);
	declare Ciudad_cursor cursor for SELECT DISTINCT o.city  FROM offices o ;

	declare continue handler for not found set hayFilas = 0;
	
	SET p_listaCiudades = "";
	
	open Ciudad_cursor;
		bucle:loop
			fetch Ciudad_cursor into ciudad;
			if hayFilas = 0 then
				leave bucle;
			end if;
				SET p_listaCiudades = CONCAT(p_listaCiudades, ciudad, ', ');
				
			end loop bucle;
	close Ciudad_cursor;

END //

DELIMITER ;

CALL ListaCiudades(@Lista_Ciudades_res);
SELECT @Lista_Ciudades_res;







 