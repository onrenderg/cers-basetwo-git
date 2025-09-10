--@block

SELECT name 
FROM sys.databases;



--@block
USE secExpense;
GO
SELECT name 
FROM sys.tables;



--@block 
-- query to check in database  schemas 

USE secExpense;
GO
    
SELECT * FROM sys.schemas;



--@block
-- query using secExpense create procedure that create  table employ  with data inserted based in argumet to procudure 2 arune anme and number

USE secExpense;
GO

--@block 
CREATE OR ALTER PROCEDURE dbo.CreateEmployWithData
    @EmpName NVARCHAR(100),
    @EmpNumber INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'employ')
    BEGIN
        CREATE TABLE dbo.employ (
            ID INT IDENTITY(1,1) PRIMARY KEY,
            EmpName NVARCHAR(100) NOT NULL,
            EmpNumber INT NOT NULL
        );
    END

    INSERT INTO dbo.employ (EmpName, EmpNumber)
    VALUES (@EmpName, @EmpNumber);
END;
GO

exec dbo.CreateEmployWithData @EmpName = 'John Doe', @EmpNumber = 1234567890;



--@block 
CREATE OR ALTER PROCEDURE dbo.CreateEmployWithData
    @EmpName NVARCHAR(100),
    @EmpNumber INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'employ')
    BEGIN
        CREATE TABLE dbo.employ (
            ID INT IDENTITY(1,1) PRIMARY KEY,
            EmpName NVARCHAR(100) NOT NULL,
            EmpNumber INT NOT NULL
        );
    END

    INSERT INTO dbo.employ (EmpName, EmpNumber)
    VALUES (@EmpName, @EmpNumber);
END;



exec dbo.CreateEmployWithData @EmpName = 'John Doe', @EmpNumber = 1234567890;





exec dbo.CreateEmployWithData @EmpName = 'John Doe', @EmpNumber = 1234567890;

use secExpense

select name 
from sys.tables

select * from sys.databases;



select * from sys.tables

USE secExpense;

-- look at the table
SELECT * FROM sys.tables WHERE name = 'employ'

