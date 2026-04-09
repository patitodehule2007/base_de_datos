
DELIMITER //

CREATE  FUNCTION IF NOT EXISTS obtener_comision(p_empleado_dni int)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
	DECLARE v_anios_exp int;
	DECLARE v_porcentaje_comision double;
	DECLARE v_cantidad_vendida double;
	
	SELECT (YEAR(NOW()) - YEAR(e.fechaIngreso)) INTO v_anios_exp FROM empleado e
	WHERE e.dni = p_empleado_dni;
	
	IF(v_anios_exp < 5) THEN
		SET v_porcentaje_comision = 5;
	ELSEIF( v_anios_exp >= 5 AND v_anios_exp < 10 ) THEN
		SET v_porcentaje_comision = 7;
	ELSE 
		SET v_porcentaje_comision = 10;
	END IF;
	
	SELECT  SUM(c.precio) INTO v_cantidad_vendida
	FROM empleado e
	JOIN compra c ON c.empleado_dni  = e.dni
	WHERE e.dni  = p_empleado_dni
	AND MONTH(c.fecha) = MONTH(NOW())
	AND YEAR(c.fecha) = YEAR(NOW());
	
	RETURN v_cantidad_vendida * v_porcentaje_comision/100;
	
	
	
END //


DELIMITER ;

