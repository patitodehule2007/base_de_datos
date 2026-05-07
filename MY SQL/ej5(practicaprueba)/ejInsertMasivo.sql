DROP PROCEDURE IF EXISTS update_reporteVentas

// DELIMITER

CREATE PROCEDURE update_reporteVentas() # 3m
BEGIN
 DECLARE noneLeft boolean DEFAULT FALSE;
 
 DECLARE oid int;
 DECLARE name varchar(50);
 DECLARE pais varchar(50);
 DECLARE gastado float;
 DECLARE items int;
 DECLARE estado varchar(15);
 DECLARE diasParaEntrega int;

 DECLARE orderCursor CURSOR FOR
  SELECT o.orderNumber, c.customerName, c.country, (od.priceEach * od.quantityOrdered) AS spent, sum(od.quantityOrdered) AS cantItems, o.status, DAY(timediff(o.requiredDate, now())) FROM orders o
  JOIN customers c ON o.customerNumber = c.customerNumber
  JOIN orderdetails od ON o.orderNumber = od.orderNumber
  GROUP BY o.orderNumber;
 
 DECLARE CONTINUE handler FOR NOT FOUND SET noneLeft = TRUE;
 
 OPEN orderCursor;

 FETCH orderCursor INTO oid, name, pais, gastado, items, estado, diasParaEntrega;
 WHILE NOT noneLeft DO
  INSERT INTO reporteVentas VALUES (oid, name, pais, gastado, items, estado, diasParaEntrega);
 
  FETCH orderCursor INTO oid, name, pais, gastado, items, estado, diasParaEntrega;
 END WHILE;
  
 CLOSE orderCursor;
END ;


DROP PROCEDURE IF EXISTS InsertarOrdenes;

CREATE PROCEDURE InsertarOrdenes()
BEGIN
    DECLARE i          INT DEFAULT 0;
    DECLARE v_orderNum INT;
    DECLARE v_custNum  INT;
    DECLARE v_prod1    VARCHAR(15);
    DECLARE v_prod2    VARCHAR(15);
    DECLARE v_prod3    VARCHAR(15);
    DECLARE v_price1   DECIMAL(10,2);
    DECLARE v_price2   DECIMAL(10,2);
    DECLARE v_price3   DECIMAL(10,2);
    DECLARE v_custCount INT;
    DECLARE v_prodCount INT;

    SELECT COALESCE(MAX(orderNumber), 108000) + 1 INTO v_orderNum FROM orders;

    SELECT COUNT(*) INTO v_custCount FROM customers;
    SELECT COUNT(*) INTO v_prodCount FROM products;


    IF v_prodCount < 3 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Se necesitan al menos 3 productos en la tabla';
    END IF;

    WHILE i < 50000 DO

        -- Cliente aleatorio existente
        SELECT customerNumber
          INTO v_custNum
          FROM customers
         ORDER BY RAND()
         LIMIT 1;

        -- 3 productos distintos aleatorios + sus precios
        SELECT productCode, MSRP
          INTO v_prod1, v_price1
          FROM products
         ORDER BY RAND()
         LIMIT 1;

        SELECT productCode, MSRP
          INTO v_prod2, v_price2
          FROM products
         WHERE productCode <> v_prod1
         ORDER BY RAND()
         LIMIT 1;

        SELECT productCode, MSRP
          INTO v_prod3, v_price3
          FROM products
         WHERE productCode NOT IN (v_prod1, v_prod2)
         ORDER BY RAND()
         LIMIT 1;

        -- Insertar la orden
        INSERT INTO orders (
            orderNumber, orderDate, requiredDate, shippedDate,
            status, comments, customerNumber
        ) VALUES (
            v_orderNum,
            CURDATE(),
            DATE_ADD(CURDATE(), INTERVAL 7  DAY),
            DATE_ADD(CURDATE(), INTERVAL 14 DAY),
            'Shipped',
            CONCAT('Orden generada automáticamente #', v_orderNum),
            v_custNum
        );

        -- Insertar los 3 productos (orderLineNumber 1, 2, 3)
        INSERT INTO orderdetails (
            orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber
        ) VALUES
            (v_orderNum, v_prod1, FLOOR(1 + RAND() * 10), v_price1, 1),
            (v_orderNum, v_prod2, FLOOR(1 + RAND() * 10), v_price2, 2),
            (v_orderNum, v_prod3, FLOOR(1 + RAND() * 10), v_price3, 3);

        SET v_orderNum = v_orderNum + 1;
        SET i = i + 1;

    END WHILE;

END ;

DROP PROCEDURE IF EXISTS update_reporteVentas_rapido;

CREATE PROCEDURE update_reporteVentas_rapido() # 1.3s| 
BEGIN
 INSERT INTO reporteVentas 
 SELECT o.orderNumber, c.customerName, c.country, (od.priceEach * od.quantityOrdered) AS spent, sum(od.quantityOrdered) AS cantItems, o.status, DAY(timediff(o.requiredDate, now())) FROM orders o
 JOIN customers c ON o.customerNumber = c.customerNumber
 JOIN orderdetails od ON o.orderNumber = od.orderNumber
 GROUP BY o.orderNumber;
END ;

DELIMITER ;