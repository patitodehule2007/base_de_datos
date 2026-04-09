DELIMITER //

CREATE FUNCTION IF NOT EXISTS estaPagado(p_id_compra int)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN 
	DECLARE v_cantidad_pagada float DEFAULT 0;
	DECLARE v_precio_auto float DEFAULT 0;
	
	SELECT SUM(p.monto) INTO v_cantidad_pagada FROM pago 
	WHERE compra_id = p_id_compra;
	
	SELECT a.precio INTO v_precio_auto FROM compra c
	JOIN auto a ON a.patente = c.auto_patente
	WHERE c.id = p_id_compra;
	
	RETURN v_cantidad_pagada = v_precio_auto;
	
END //

DELIMITER ;