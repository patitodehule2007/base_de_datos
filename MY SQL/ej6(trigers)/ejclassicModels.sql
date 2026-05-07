-- 1

CREATE TABLE `customers_audit` (
  `IdAudit` INT AUTO_INCREMENT NOT NULL,
  `Operacion` CHAR(6) NOT NULL, 
  `User` int NOT NULL,
  `Last_date_modified` DATETIME NOT NULL,

  `customerNumber` INT(11),
  `customerName` VARCHAR(50),
  `contactLastName` VARCHAR(50),
  `contactFirstName` VARCHAR(50),
  `creditLimit` DECIMAL(10,2),
  
  PRIMARY KEY (`IdAudit`)

  CONSTRAINT `fk_audit_user` 
    FOREIGN KEY (`User_ID`) REFERENCES `customer` (`customerNumber`)
    ON DELETE SET NULL 
    ON UPDATE CASCADE
);

CREATE trigger 