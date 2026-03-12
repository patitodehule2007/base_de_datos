

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






