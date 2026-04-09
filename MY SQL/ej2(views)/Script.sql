

# 6

CREATE VIEW ClientesSinPago AS (
SELECT c.* FROM customers c 
LEFT JOIN payments p  ON p.customerNumber  = c.customerNumber 
WHERE p.checkNumber IS NULL
);

SELECT * FROM ClientesSinPago

# 10


CREATE VIEW ClientesConComprasViejas AS (
	SELECT  c.customerName,c.phone ,c.addressLine1  FROM customers c 
	JOIN orders o  ON o.customerNumber  = c.customerNumber 
	WHERE o.orderDate < now() - INTERVAL 2 YEAR
	AND o.orderNumber  IN (
		SELECT o2.orderNumber  FROM  orderdetails o2 
		GROUP BY o2.orderNumber 
		HAVING SUM(o2.priceEach * o2.quantityOrdered ) > 30000
));

SELECT * FROM ClientesConComprasViejas;

# 11 
CREATE VIEW OrdenesSinEntregaoTardes AS (
SELECT * FROM orders o 
WHERE o.requiredDate < o.shippedDate 
OR o.shippedDate  IS NULL
);

SELECT * FROM OrdenesSinEntregaoTardes;

# 13


CREATE VIEW PersonaConMayorCantidadOrdenes  as( SELECT c2.* FROM (
	SELECT c2.customerNumber ,count(o2.quantityOrdered ) AS Ammount_Orders FROM customers c2
	JOIN orders o ON o.customerNumber  = c2.customerNumber 
	JOIN orderdetails o2 ON o2.orderNumber  = o.orderNumber
	GROUP BY c2.customerNumber
	)
AS UsersCount
JOIN customers c2 ON c2.customerNumber  = UsersCount.customerNumber 
ORDER BY Ammount_Orders
LIMIT 1
);

SELECT * FROM PersonaConMayorCantidadOrdenes;


