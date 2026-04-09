
DELIMITER //
CREATE FUNCTION IF NOT EXISTS cantidad_autos_vendidos(p_id_modelo INT,p_mes DATE)
RETURNS INT 
DETERMINISTIC 
BEGIN 
	DECLARE v_cantidad_vendidos int DEFAULT 0;
	
	SELECT COUNT(*) INTO v_cantidad_vendidos FROM auto a 
	JOIN compra c ON c.auto_patente  = a.patente 
	WHERE a.modelo_id  = p_id_modelo 
	AND MONTH(p_mes) = MONTH(c.fecha)
	AND YEAR(p_mes) = YEAR(c.fecha);
	
	RETURN v_cantidad_vendidos;
	
	
END //



DELIMITER ;


