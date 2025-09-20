-- Create practice schema and tables
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'practice')
BEGIN
    EXEC('CREATE SCHEMA practice');
END


-- Create token master table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'token_master' AND schema_id = SCHEMA_ID('practice'))
BEGIN
    CREATE TABLE practice.token_master (
        id INT IDENTITY(1,1) PRIMARY KEY,
        token_id VARCHAR(32) NOT NULL UNIQUE,
        created_datetime DATETIME2 DEFAULT GETDATE(),
        expire_datetime DATETIME2 DEFAULT DATEADD(HOUR, 24, GETDATE()),
        is_active BIT DEFAULT 1
    );
END

SELECT 'Tables created successfully' AS Status;

-- Exercise 1: Basic Random String Generation

-- Step 1: Understand NEWID() and CHECKSUM()
SELECT 
    NEWID() AS RandomGUID,
    CHECKSUM(NEWID()) AS RandomNumber,
    ABS(CHECKSUM(NEWID())) AS PositiveRandomNumber;

-- Step 2: Generate single random character
DECLARE @char_set VARCHAR(62) = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
DECLARE @random_position INT = ABS(CHECKSUM(NEWID())) % LEN(@char_set) + 1;

SELECT 
    @char_set AS CharacterSet,
    LEN(@char_set) AS SetLength,
    @random_position AS RandomPosition,
    SUBSTRING(@char_set, @random_position, 1) AS RandomCharacter;

-- Step 3: Generate 8-character random string
DECLARE @result VARCHAR(8) = '';
DECLARE @i INT = 1;

WHILE @i <= 8
BEGIN
    SET @result = @result + SUBSTRING(@char_set, ABS(CHECKSUM(NEWID())) % LEN(@char_set) + 1, 1);
    SET @i = @i + 1;
END

SELECT @result AS RandomString8Chars;

-- select name from sys.databases




-- Query to list all user-created tables with schema and creation date
SELECT 
    SCHEMA_NAME(schema_id) AS SchemaName,
    name AS TableName,
    create_date AS CreatedDate
FROM sys.tables
ORDER BY SchemaName, TableName;



-- list all schema in test_db
select * from information_schema.schemata;



--list all tables in master db in practice schmea 
select * from information_schema.tables where table_schema = 'practice'

-- print top 1 line of master db practice schma token_master table 


use master

-- list all schemas in master db

SELECT * FROM practice.token_master;



select name from sys.tables

-- ... existing code ...

-- Drop the existing table if it exists to recreate with proper size
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'token_master' AND schema_id = SCHEMA_ID('practice'))
BEGIN
    DROP TABLE practice.token_master;
END

-- Create token master table with larger token_id column
CREATE TABLE practice.token_master (
    id INT IDENTITY(1,1) PRIMARY KEY,
    token_id VARCHAR(50) NOT NULL UNIQUE,  -- Increased size to accommodate longer tokens
    created_datetime DATETIME2 DEFAULT GETDATE(),
    expire_datetime DATETIME2 DEFAULT DATEADD(HOUR, 24, GETDATE()),
    is_active BIT DEFAULT 1
);

-- ... existing code ...

-- Insert sample data into token_master table (with corrected token lengths)
INSERT INTO practice.token_master (token_id, created_datetime, expire_datetime, is_active)
VALUES 
    ('abc123def456ghi789jkl012mno345pq', GETDATE(), DATEADD(HOUR, 24, GETDATE()), 1),
    ('xyz987wvu654tsr321qpo098nml765ki', DATEADD(HOUR, -2, GETDATE()), DATEADD(HOUR, 22, GETDATE()), 1),
    ('mno456pqr789stu012vwx345yzab678c', DATEADD(HOUR, -25, GETDATE()), DATEADD(HOUR, -1, GETDATE()), 0),
    ('def789ghi012jkl345mno678pqr901st', DATEADD(MINUTE, -30, GETDATE()), DATEADD(HOUR, 23, DATEADD(MINUTE, -30, GETDATE())), 1);

-- ... existing code ...

select * from practice.token_master

