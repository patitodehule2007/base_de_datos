-- 1
DELIMITER //

CREATE TRIGGER Update_Stock BEFORE INSERT  ON  Pedido_producto FOR EACH ROW
BEGIN
	UPDATE producto 
	SET stock = stock - NEW.cantidad
	WHERE codProducto = NEW.Producto_codProducto;
END

DELIMITER ;
-- 2
DELIMITER //

CREATE TRIGGER Update_rank 
AFTER INSERT ON pedido 
FOR EACH ROW
BEGIN
    DECLARE v_gasto_total DECIMAL(12,2) DEFAULT 0;
    DECLARE v_categoria VARCHAR(10);

    SELECT COALESCE(SUM(pp.cantidad * pp.precioUnitario), 0) 
    INTO v_gasto_total  
    FROM pedido_producto pp 
    JOIN pedido p ON p.idPedido = pp.Pedido_idPedido 
    WHERE p.Cliente_codCliente = NEW.Cliente_codCliente 
      AND p.fecha_pedido >= (NOW() - INTERVAL 2 YEAR);


    IF (v_gasto_total <= 50000) THEN
        SET v_categoria = 'Bronce';
    ELSEIF (v_gasto_total <= 100000) THEN
        SET v_categoria = 'Plata';
    ELSE
        SET v_categoria = 'Oro';
    END IF;

    UPDATE cliente 
    SET categoria = v_categoria 
    WHERE codCliente = NEW.Cliente_codCliente;

END //

DELIMITER ;

-- 3
-- se puede hacer un alter para cambiar a un delte on cascade
-- o usar un on delete rrestrict y obligar a que se eliminte todo manualmente
DELIMITER //

CREATE TRIGGER tg_clean_before_delete_pedido
BEFORE DELETE ON pedido
FOR EACH ROW
BEGIN
    DELETE FROM pedido_producto 
    WHERE Pedido_idPedido = OLD.idPedido;
END //

DELIMITER ;