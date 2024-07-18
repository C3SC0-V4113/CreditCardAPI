use master
-- Creación de la base de datos
CREATE DATABASE CreditCardDB;
GO

USE CreditCardDB;
GO

-- Creación de la tabla CreditCard
CREATE TABLE CreditCards (
    CreditCardId INT IDENTITY(1,1) PRIMARY KEY,
    CardNumber VARCHAR(16) NOT NULL,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    CurrentBalance DECIMAL(18, 2) NOT NULL,
    CreditLimit DECIMAL(18, 2) NOT NULL
);

-- Creación de la tabla Purchase
CREATE TABLE Purchases (
    PurchaseId INT IDENTITY(1,1) PRIMARY KEY,
    CreditCardId INT NOT NULL,
    PurchaseDate DATE NOT NULL,
    Description VARCHAR(255),
    Amount DECIMAL(18, 2) NOT NULL,
    FOREIGN KEY (CreditCardId) REFERENCES CreditCards(CreditCardId)
);

-- Creación de la tabla Payment
CREATE TABLE Payments (
    PaymentId INT IDENTITY(1,1) PRIMARY KEY,
    CreditCardId INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(18, 2) NOT NULL,
    FOREIGN KEY (CreditCardId) REFERENCES CreditCards(CreditCardId)
);

-- Procedimientos almacenados
-- Registrar una compra
CREATE PROCEDURE spAddPurchase
    @CreditCardId INT,
    @PurchaseDate DATE,
    @Description VARCHAR(255),
    @Amount DECIMAL(18, 2)
AS
BEGIN
    INSERT INTO Purchases (CreditCardId, PurchaseDate, Description, Amount)
    VALUES (@CreditCardId, @PurchaseDate, @Description, @Amount);
END;

-- Registrar un pago
CREATE PROCEDURE spAddPayment
    @CreditCardId INT,
    @PaymentDate DATE,
    @Amount DECIMAL(18, 2)
AS
BEGIN
    INSERT INTO Payments (CreditCardId, PaymentDate, Amount)
    VALUES (@CreditCardId, @PaymentDate, @Amount);

    UPDATE CreditCards
    SET CurrentBalance = CurrentBalance - @Amount
    WHERE CreditCardId = @CreditCardId;
END;

-- Datos de prueba 
INSERT INTO CreditCards (CardNumber, FirstName, LastName, CurrentBalance, CreditLimit)
VALUES ('1234567812345678', 'Juan', 'Perez', 1000.00, 5000.00),
       ('2345678923456789', 'Maria', 'Gomez', 2000.00, 6000.00);

INSERT INTO Purchases (CreditCardId, PurchaseDate, Description, Amount)
VALUES (10, GETDATE(), 'Compra en tienda A', 150.00),
       (10, GETDATE(), 'Compra en tienda B', 200.00),
       (11, GETDATE(), 'Compra en tienda C', 300.00);

INSERT INTO Payments (CreditCardId, PaymentDate, Amount)
VALUES (10, GETDATE(), 100.00),
       (11, GETDATE(), 200.00);


-- Procedimientos almacenados 
CREATE PROCEDURE sp_GetCreditCardDetails
    @CreditCardId INT
AS
BEGIN
    SELECT * FROM CreditCards WHERE CreditCardId = @CreditCardId;
END;


CREATE PROCEDURE sp_GetPayments
    @CreditCardId INT
AS
BEGIN
    SELECT * FROM Payments WHERE CreditCardId = @CreditCardId;
END;

CREATE PROCEDURE sp_InsertPurchase
    @CreditCardId INT,
    @PurchaseDate DATETIME,
    @Description NVARCHAR(200),
    @Amount DECIMAL(18, 2)
AS
BEGIN
    INSERT INTO Purchases (CreditCardId, PurchaseDate, Description, Amount)
    VALUES (@CreditCardId, @PurchaseDate, @Description, @Amount);
END;

CREATE PROCEDURE sp_InsertPayment
    @CreditCardId INT,
    @PaymentDate DATETIME,
    @Amount DECIMAL(18, 2)
AS
BEGIN
    INSERT INTO Payments (CreditCardId, PaymentDate, Amount)
    VALUES (@CreditCardId, @PaymentDate, @Amount);
END;

-- Procedimiento para obtener compras
CREATE PROCEDURE sp_GetPurchases
    @CreditCardId INT
AS
BEGIN
    SELECT * FROM Purchases WHERE CreditCardId = @CreditCardId ORDER BY PurchaseDate DESC;
END;

-- Procedimiento para obtener el total de compras del mes actual
CREATE PROCEDURE sp_GetTotalCurrentMonth
    @CreditCardId INT
AS
BEGIN
    SELECT SUM(Amount) AS TotalCurrentMonth
    FROM Purchases
    WHERE CreditCardId = @CreditCardId AND
          MONTH(PurchaseDate) = MONTH(GETDATE()) AND
          YEAR(PurchaseDate) = YEAR(GETDATE());
END;

-- Procedimiento para obtener el total de compras del mes anterior
CREATE PROCEDURE sp_GetTotalPreviousMonth
    @CreditCardId INT
AS
BEGIN
    SELECT SUM(Amount) AS TotalPreviousMonth
    FROM Purchases
    WHERE CreditCardId = @CreditCardId AND
          MONTH(PurchaseDate) = MONTH(DATEADD(MONTH, -1, GETDATE())) AND
          YEAR(PurchaseDate) = YEAR(DATEADD(MONTH, -1, GETDATE()));
END;

-- Procedimiento para obtener el estado de cuenta
CREATE PROCEDURE sp_GetStatement
    @CreditCardId INT
AS
BEGIN
    SELECT c.FirstName, c.LastName, c.CardNumber, c.CurrentBalance, c.CreditLimit
    FROM CreditCards c
    WHERE c.CreditCardId = @CreditCardId;

    SELECT p.PurchaseId, p.PurchaseDate, p.Description, p.Amount
    FROM Purchases p
    WHERE p.CreditCardId = @CreditCardId
    ORDER BY p.PurchaseDate DESC;
END;