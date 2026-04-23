


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




# 10


CREATE TABLE `Canceled_orders` (
  `orderNumber` int NOT NULL,
  `orderDate` date NOT NULL,
  `requiredDate` date NOT NULL,
  `shippedDate` date DEFAULT NULL,
  `status` varchar(15) NOT NULL,
  `comments` text,
  `customerNumber` int NOT NULL,
  PRIMARY KEY (`orderNumber`),
  KEY `customerNumber` (`customerNumber`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`customerNumber`) REFERENCES `customers` (`customerNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



DELIMITER //

DROP PROCEDURE IF EXISTS insertCancelledOrders //

CREATE PROCEDURE insertCancelledOrders(OUT p_numMovidos int)
BEGIN 
	DECLARE v_orderNumber INT;
	DECLARE v_orderDate DATE;
	DECLARE v_requiredDate DATE;
	DECLARE v_shippedDate DATE;
	DECLARE v_status VARCHAR(256);
	DECLARE v_comments VARCHAR(256);
	DECLARE v_customerNumber INT;

	DECLARE sigue TINYINT DEFAULT 1;

	DECLARE ordenesCanceladas CURSOR  FOR (SELECT orderNumber,orderDate,requiredDate,shippedDate,status,comments,customerNumber FROM orders o WHERE o.status = "Cancelled");
	DECLARE CONTINUE handler FOR NOT FOUND SET sigue = 0;
	
	SET p_numMovidos = 0;
	OPEN ordenesCanceladas;
	
	bucle:LOOP
		FETCH ordenesCanceladas INTO v_orderNumber,v_orderDate,v_requiredDate,v_shippedDate,v_status,v_comments,v_customerNumber;
		IF sigue = 0 THEN
			LEAVE bucle;
		END IF;
		INSERT INTO Canceled_orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments,customerNumber)
		VALUES (v_orderNumber, v_orderDate, v_requiredDate, v_shippedDate, v_status, v_comments,v_customerNumber);
		SET  p_numMovidos = p_numMovidos + 1;
	END LOOP;
	CLOSE ordenesCanceladas;
	
	
END //

CALL insertCancelledOrders(@numMovidos) //
SELECT @numMovidos //


DELIMITER ;




# 11



DROP PROCEDURE IF EXISTS obtenerPedidos;

DELIMITER //


CREATE PROCEDURE obtenerPedidos(IN p_codigo_cliente int)
BEGIN 
	DECLARE sig int DEFAULT 1;
	DECLARE v_order_num int;
	DECLARE v_sum float;
	DECLARE orderSums CURSOR FOR(
		SELECT o2.orderNumber, SUM(o2.quantityOrdered * o2.priceEach )  FROM orders o 
		JOIN orderdetails o2 ON o2.orderNumber  = o.orderNumber
		WHERE o.customerNumber = p_codigo_cliente
		GROUP BY o2.orderNumber
	);
	DECLARE CONTINUE handler FOR NOT FOUND SET sig = 0;
	OPEN orderSums;
		bucle:LOOP
			FETCH orderSums INTO v_order_num,v_sum;
			IF sig = 0 THEN
				LEAVE bucle;
			END IF;
	
			UPDATE orders
				SET comments = CONCAT("El total de la orden es ",v_sum )
				WHERE comments IS NULL
				AND orderNumber = v_order_num
				AND customerNumber = p_codigo_cliente;
		END LOOP;
	CLOSE orderSums;
END


DELIMITER ;


CALL obtenerPedidos(363)
