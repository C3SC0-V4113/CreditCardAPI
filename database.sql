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

-- Creación de la tabla Transaction
CREATE TABLE [Transactions] (
    TransactionId INT IDENTITY(1,1) PRIMARY KEY,
    CreditCardId INT NOT NULL,
    TransactionDate DATE NOT NULL,
    Description VARCHAR(255),
    Amount DECIMAL(18, 2) NOT NULL,
    FOREIGN KEY (CreditCardId) REFERENCES CreditCards(CreditCardId)
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
-- Obtener estado de cuenta
CREATE PROCEDURE spGetCreditCardStatement
    @CreditCardId INT
AS
BEGIN
    SELECT 
        cc.CreditCardId,
        cc.CardNumber,
        cc.FirstName,
        cc.LastName,
        cc.CurrentBalance,
        cc.CreditLimit,
        ISNULL(SUM(t.Amount), 0) AS TotalPurchasesCurrentMonth,
        ISNULL(SUM(t.Amount), 0) AS TotalPurchasesLastMonth,
        0 AS InterestBonificable,
        0 AS MinimumPayment,
        cc.CurrentBalance AS TotalAmountDue,
        cc.CurrentBalance AS TotalAmountWithInterest
    FROM 
        CreditCards cc
    LEFT JOIN 
        [Transactions] t ON cc.CreditCardId = t.CreditCardId
    WHERE 
        cc.CreditCardId = @CreditCardId
    GROUP BY 
        cc.CreditCardId, cc.CardNumber, cc.FirstName, cc.LastName, cc.CurrentBalance, cc.CreditLimit
END;

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

-- Obtener historial de transacciones
CREATE PROCEDURE spGetTransactions
    @CreditCardId INT
AS
BEGIN
    SELECT 
        t.TransactionId,
        t.TransactionDate,
        t.Description,
        t.Amount
    FROM 
        [Transactions] t
    WHERE 
        t.CreditCardId = @CreditCardId
    ORDER BY 
        t.TransactionDate DESC;
END;

-- Insertar datos de prueba
INSERT INTO CreditCards (CardNumber, FirstName, LastName, CurrentBalance, CreditLimit)
VALUES 
('1234567812345678', 'John', 'Doe', 500.00, 1000.00),
('2345678923456789', 'Jane', 'Smith', 300.00, 1500.00);

INSERT INTO [Transactions] (CreditCardId, TransactionDate, Description, Amount)
VALUES 
(1, GETDATE(), 'Grocery Store', 50.00),
(1, GETDATE(), 'Gas Station', 30.00),
(2, GETDATE(), 'Online Purchase', 100.00);

-- Datos de prueba 2
INSERT INTO CreditCards (CardNumber, FirstName, LastName, CurrentBalance, CreditLimit)
VALUES ('1234567812345678', 'Juan', 'Perez', 1000.00, 5000.00),
       ('2345678923456789', 'Maria', 'Gomez', 2000.00, 6000.00);

INSERT INTO Purchases (CreditCardId, PurchaseDate, Description, Amount)
VALUES (1, GETDATE(), 'Compra en tienda A', 150.00),
       (1, GETDATE(), 'Compra en tienda B', 200.00),
       (2, GETDATE(), 'Compra en tienda C', 300.00);

INSERT INTO Payments (CreditCardId, PaymentDate, Amount)
VALUES (1, GETDATE(), 100.00),
       (2, GETDATE(), 200.00);

INSERT INTO Transactions (CreditCardId, TransactionDate, Description, Amount)
VALUES (1, GETDATE(), 'Compra en tienda A', 150.00),
       (1, GETDATE(), 'Compra en tienda B', 200.00),
       (2, GETDATE(), 'Compra en tienda C', 300.00),
       (1, GETDATE(), 'Pago realizado', -100.00),
       (2, GETDATE(), 'Pago realizado', -200.00);


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

CREATE PROCEDURE sp_GetTransactions
    @CreditCardId INT
AS
BEGIN
    SELECT * FROM Transactions WHERE CreditCardId = @CreditCardId ORDER BY TransactionDate DESC;
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