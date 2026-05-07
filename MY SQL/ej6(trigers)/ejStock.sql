-- 1
DELIMITER //

CREATE TRIGGER Update_Stock BEFORE INSERT  ON  Pedido_producto FOR EACH ROW
BEGIN
	UPDATE producto 
	SET stock = stock - NEW.cantidad
	WHERE codProducto = NEW.Producto_codProducto;
END

DELIMITER ;
