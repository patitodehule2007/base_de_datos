

# 1
delimiter //
DROP FUNCTION IF exists ordenesPorEstado //

CREATE FUNCTION ordenesPorEstado(
	p_fechaInicio date,
	p_fechaFin date,
	p_estado varchar(15)
)
RETURNS int 
DETERMINISTIC 
BEGIN 
	DECLARE cantPedidos int;
	
	SELECT count(*) INTO cantPedidos FROM orders o
	WHERE o.orderDate  BETWEEN p_fechaInicio AND p_fechaFin
	AND o.status  = p_estado;
	RETURN cantPedidos;
END;

delimiter ;

SELECT  ordenesPorEstado('2003-01-06',now(),'Shipped') AS CantEnvios;


# 2
delimiter //
DROP FUNCTION IF exists ordenesEntregadas //

CREATE FUNCTION ordenesEntregadas(
	p_fechaInicio date,
	p_fechaFin date
)
RETURNS int 
DETERMINISTIC 
BEGIN 
	DECLARE cantPedidos int;
	
	SELECT count(*) INTO cantPedidos FROM orders o
	WHERE o.shippedDate   BETWEEN p_fechaInicio AND p_fechaFin
	AND o.status  = "Shipped";
	RETURN cantPedidos;
END;
delimiter ;

SELECT ordenesEntregadas('2003-01-06',now()) AS 

# 3

delimiter //
DROP FUNCTION IF exists obtener_oficina_Empleado //

CREATE FUNCTION obtener_oficina_Empleado(
	p_numUsuario int
)
RETURNS varchar(256) 
DETERMINISTIC 
BEGIN 
	DECLARE v_ciudad varchar(256) ;
	
	
	SELECT o.city  INTO v_ciudad FROM customers c 
	JOIN employees e ON e.employeeNumber  = c.salesRepEmployeeNumber 
	JOIN offices o ON e.officeCode  = o.officeCode 
	WHERE c.customerNumber  = p_numUsuario;
	
	RETURN v_ciudad;
END;
delimiter ;

SELECT obtener_oficina_Empleado(484);
# 4

DELIMITER //
DROP FUNCTION if exists Producs_on_Lines //

CREATE FUNCTION IF NOT EXISTS Producs_on_Lines(
	p_productLine VARCHAR(256)
)
RETURNS int
DETERMINISTIC
BEGIN
	RETURN (
		SELECT count(p.productCode) FROM products p
		WHERE p.productLine = p_productLine
	);
END

delimiter ;
SELECT Producs_on_lines("Classic Cars") AS Products_On_Lines;



# 7
DELIMITER //
CREATE FUNCTION ObtenerGanacia(
 p_orderNumber int,
 p_productCode varchar(256)
)
RETURNS float
DETERMINISTIC 
BEGIN
	RETURN( 
		SELECT (o2.priceEach  - p.buyPrice)*o2.quantityOrdered    FROM orders o 
		JOIN orderdetails o2 ON o2.orderNumber = o.orderNumber 
		JOIN products p  ON p.productCode = o2.productCode 
		WHERE o.orderNumber  = p_orderNumber
		AND o2.productCode = p_productCode
	);
END //
DELIMITER ;


SELECT ObtenerGanacia(10100,"S18_1749") AS ganacia;


# 8

DELIMITER //

CREATE FUNCTION isTheOrderCanceled(
p_order_Number int
)
RETURNS int
DETERMINISTIC
BEGIN
	DECLARE v_status VARCHAR(256);
	SELECT o.status INTO v_status FROM orders o 
	WHERE o.orderNumber  = p_order_Number;

	IF v_status = "Cancelled" THEN 
		RETURN -1;
	END IF;
	RETURN 0;
END // 
DELIMITER ;




SELECT isTheOrderCanceled(10179);


# 10
DROP FUNCTION IF EXISTS BuscanVentasPorDebajoPrecioRecomendado;

DELIMITER // 

CREATE FUNCTION BuscanVentasPorDebajoPrecioRecomendado(
p_codigo_producto varchar(256)
)
RETURNS FLOAT
DETERMINISTIC
BEGIN
	
	DECLARE v_ordersTotal float DEFAULT 0;
	DECLARE v_odersLowPrice float DEFAULT 0;
	
	
	SELECT SUM(o.quantityOrdered ) into v_ordersTotal FROM products p 
	JOIN orderdetails o ON o.productCode  = p.productCode 
	WHERE o.productCode = p_codigo_producto;


	SELECT SUM(o.quantityOrdered ) INTO v_odersLowPrice FROM products p 
	JOIN orderdetails o ON o.productCode  = p.productCode 
	WHERE o.productCode = p_codigo_producto
	AND p.MSRP < o.priceEach ;
	
	IF v_ordersTotal = 0 OR v_ordersTotal IS NULL OR v_odersLowPrice IS NULL THEN
        RETURN 0;
    ELSE
        RETURN (v_odersLowPrice * 100) / v_ordersTotal;
    END IF;

END //
DELIMITER ;

SELECT BuscanVentasPorDebajoPrecioRecomendado("S10_1678");

#12

DROP FUNCTION IF EXISTS FindBestPaidProdInPeriod;

DELIMITER //

CREATE FUNCTION FindBestPaidProdInPeriod(
p_start_date DATE,
p_end_date DATE,
p_prod_code VARCHAR(256)
)
RETURNS float
DETERMINISTIC
BEGIN

	DECLARE v_RES float;

	

	SELECT o.priceEach INTO v_RES FROM products p 	
	JOIN orderdetails o ON o.productCode = p.productCode 
	JOIN orders o2 ON o2.orderDate  BETWEEN  p_start_date AND p_end_date
	WHERE p.productCode = p_prod_code
	ORDER BY o.priceEach   DESC
	LIMIT 1;
	
	IF(v_RES IS null) THEN
		RETURN 0;
	
	END IF;
	RETURN v_RES;
	
	
	

END //
DELIMITER ;


 SELECT  FindBestPaidProdInPeriod(
DATE_SUB(CURRENT_DATE, INTERVAL 50 YEAR), 
   CURRENT_DATE,
 "S10_1678") AS FindBestPaidProdInPeriod;

 # 14


 DROP FUNCTION IF EXISTS getEmployeReportingLastName;
DELIMITER //

CREATE FUNCTION getEmployeReportingLastName(
	p_employeeNumber INT
)
RETURNS VARCHAR(256)
DETERMINISTIC
BEGIN
	RETURN(
	SELECT e.lastName  FROM employees e 
	WHERE e.employeeNumber = (SELECT e2.reportsTo   FROM employees e2 WHERE e2.employeeNumber = p_employeeNumber )
	);
END //

DELIMITER ;

SELECT getEmployeReportingLastName(1056) ;
