CREATE TABLE `customers_audit` (
  `IdAudit` INT AUTO_INCREMENT NOT NULL,
  `Operacion` CHAR(6) NOT NULL, 
  `Last_date_modified` DATETIME NOT NULL,

  `customerNumber` INT(11), 
  `customerName` VARCHAR(50),
  `contactLastName` VARCHAR(50),
  `contactFirstName` VARCHAR(50),
  `creditLimit` DECIMAL(10,2),
  
  PRIMARY KEY (`IdAudit`),

  CONSTRAINT `fk_audit_customer` 
    FOREIGN KEY (`customerNumber`) REFERENCES `customers` (`customerNumber`)
    ON DELETE SET NULL 
    ON UPDATE CASCADE
);
-- 1.a

DELIMITER //

CREATE TRIGGER log_customer_creation AFTER INSERT ON customers FOR EACH row
BEGIN
	INSERT INTO customers_audit(
	Operation,
	Last_date_modified,
	customerNumber,
	customerName,
	contactLastName,
	contactFirstName,
	creditLimit
	)
	VALUES (
	"INSERT",
	NOW(),
	NEW.customerNumber,
	NEW.customerName,
	NEW.contactLastName,
	NEW.contactFirstName,
	NEW.creditLimit
	);
END
DELIMITER ;



-- 1.b

DELIMITER //

CREATE TRIGGER log_customer_creation BEFORE UPDATE ON customers FOR EACH row
BEGIN
	INSERT INTO customers_audit(
	Operation,
	Last_date_modified,
	customerNumber,
	customerName,
	contactLastName,
	contactFirstName,
	creditLimit
	)
	VALUES (
	"UPDATE",
	NOW(),
	NEW.customerNumber,
	NEW.customerName,
	NEW.contactLastName,
	NEW.contactFirstName,
	NEW.creditLimit
	);
END
DELIMITER ;



-- 1.c

DELIMITER //

CREATE TRIGGER log_customer_creation BEFORE DELETE ON customers FOR EACH row
BEGIN
	INSERT INTO customers_audit(
	Operation,
	Last_date_modified,
	customerNumber,
	customerName,
	contactLastName,
	contactFirstName,
	creditLimit
	)
	VALUES (
	"DELETE",
	NOW(),
	NEW.customerNumber,
	NEW.customerName,
	NEW.contactLastName,
	NEW.contactFirstName,
	NEW.creditLimit
	);
END
DELIMITER ;


-- 2

CREATE TABLE `employees_audit` (
  `IdAudit` INT AUTO_INCREMENT NOT NULL,
  `Operacion` CHAR(6) NOT NULL, 
  `Usuario` VARCHAR(100) NOT NULL,
  `Last_date_modified` DATETIME NOT NULL,
  

  `employeeNumber` INT(11),
  `lastName` VARCHAR(50),
  `firstName` VARCHAR(50),
  `extension` VARCHAR(10),
  `email` VARCHAR(100),
  `officeCode` VARCHAR(10),
  `reportsTo` INT(11),
  `jobTitle` VARCHAR(50),
  
  PRIMARY KEY (`IdAudit`)
) 


--2.a
DELIMITER //

CREATE TRIGGER log_employee_insert 
AFTER INSERT ON employees 
FOR EACH ROW
BEGIN
    INSERT INTO employees_audit (
        Operacion, Usuario, Last_date_modified,
        employeeNumber, lastName, firstName, extension, 
        email, officeCode, reportsTo, jobTitle
    )
    VALUES (
        'INSERT', USER(), NOW(),
        NEW.employeeNumber, NEW.lastName, NEW.firstName, NEW.extension, 
        NEW.email, NEW.officeCode, NEW.reportsTo, NEW.jobTitle
    );
END //

DELIMITER ;

--2.b
DELIMITER //

CREATE TRIGGER log_employee_update 
BEFORE UPDATE ON employees 
FOR EACH ROW
BEGIN
    INSERT INTO employees_audit (
        Operacion, Usuario, Last_date_modified,
        employeeNumber, lastName, firstName, extension, 
        email, officeCode, reportsTo, jobTitle
    )
    VALUES (
        'UPDATE', USER(), NOW(),
        NEW.employeeNumber, NEW.lastName, NEW.firstName, NEW.extension, 
        NEW.email, NEW.officeCode, NEW.reportsTo, NEW.jobTitle
    );
END //

DELIMITER ;


--2.c

DELIMITER //

CREATE TRIGGER log_employee_update 
BEFORE UPDATE ON employees 
FOR EACH ROW
BEGIN
    INSERT INTO employees_audit (
        Operacion, Usuario, Last_date_modified,
        employeeNumber, lastName, firstName, extension, 
        email, officeCode, reportsTo, jobTitle
    )
    VALUES (
        'UPDATE', USER(), NOW(),
        NEW.employeeNumber, NEW.lastName, NEW.firstName, NEW.extension, 
        NEW.email, NEW.officeCode, NEW.reportsTo, NEW.jobTitle
    );
END //

DELIMITER ;

-- 3

DELIMITER //

CREATE TRIGGER RESTRICT_delete BEFORE DELETE ON  producto FOR EACH ROW
BEGIN
	IF(	
	SELECT 1 FROM orders o 
	JOIN  orderdetails o2 ON o.orderNumber = o2.orderNumber 
	WHERE o.orderDate > (NOW() - INTERVAL 3 MONTH)
	) THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No se puede borrar el cliente: tiene pedidos activos en los últimos 3 meses.';
	END IF;
END

DELIMITER ;
